package jta.video;

import jta.input.Input;
import jta.states.BaseState;
import jta.video.GlobalVideo;
import flixel.sound.FlxSound;

/**
 * Class used to play videos.
 * @see https://github.com/GrowtopiaFli/openfl-haxeflixel-video-code
 */
class VideoState extends BaseState
{
	/**
	 * The source of the video to play.
	 */
	var leSource:String = '';

	/**
	 * The sound associated with the video.
	 */
	var vidSound:FlxSound = null;

	/**
	 * Callback function triggered when the video ends or is skipped.
	 */
	var onComplete:Void->Void;

	var holdTimer:Int = 0;
	var crashMoment:Int = 0;
	var itsTooLate:Bool = false;

	/**
	 * Initializes the video player with the video source and a completion callback.
	 * @param source The source of the video to play.
	 * @param onComplete Triggered when the video ends or is skipped.
	 */
	public function new(source:String, ?onComplete:Void->Void):Void
	{
		super();

		this.leSource = source;
		this.onComplete = onComplete;
	}

	override function create():Void
	{
		if (FlxG.sound.music != null)
			FlxG.sound.music.pause();

		var bg:FlxSprite = new FlxSprite();
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		if (GlobalVideo.isWebm)
			vidSound = FlxG.sound.play(Paths.videoSound(leSource), 1, false, null, true);

		var ourVideo:Dynamic = GlobalVideo.get();
		ourVideo.source(Paths.video(leSource));

		if (ourVideo == null)
		{
			end();
			return;
		}

		ourVideo.clearPause();

		if (GlobalVideo.isWebm)
			ourVideo.updatePlayer();

		ourVideo.show();

		if (GlobalVideo.isWebm)
			ourVideo.restart();
		else
			ourVideo.play();

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		var ourVideo:Dynamic = GlobalVideo.get();

		if (ourVideo == null)
		{
			end();
			return;
		}

		ourVideo.update(elapsed);

		if (ourVideo.ended || ourVideo.stopped)
		{
			ourVideo.hide();
			ourVideo.stop();
		}

		if (crashMoment > 0)
			crashMoment--;

		if (Input.pressed('any') && crashMoment <= 0 || itsTooLate && Input.pressed('any'))
		{
			holdTimer++;

			crashMoment = 16;
			itsTooLate = true;

			FlxG.sound.music.volume = 0;
			ourVideo.alpha();

			if (holdTimer > 100)
			{
				ourVideo.stop();

				end();
				return;
			}
		}
		else if (!ourVideo.paused)
		{
			ourVideo.unalpha();

			holdTimer = 0;
			itsTooLate = false;
		}

		if (ourVideo.ended)
		{
			end();
			return;
		}

		if (ourVideo.played || ourVideo.restarted)
			ourVideo.show();

		ourVideo.restarted = false;
		ourVideo.played = false;

		ourVideo.stopped = false;
		ourVideo.ended = false;

		super.update(elapsed);
	}

	public function end():Void
	{
		if (vidSound != null)
			vidSound.destroy();

		if (onComplete != null)
			onComplete();
	}
}
