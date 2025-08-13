package;

import jta.Game;
import jta.Assets;
import jta.debug.FPS;
import jta.api.CrashHandler;
import jta.api.DiscordClient;
import jta.video.GlobalVideo;
import jta.video.VideoHandler;
import jta.video.WebmHandler;
import jta.util.CleanupUtil;
import jta.util.ResizeUtil;
#if hxgamemode
import hxgamemode.GamemodeClient;
#end

/**
 * The main entry point for the game.
 */
class Main extends openfl.display.Sprite
{
	/**
	 * Configuration for the game.
	 * This includes the game dimensions, framerate, initial state, and options for splash screen and fullscreen.
	 */
	public final config:Dynamic = {
		gameDimensions: [800, 600],
		framerate: 60,
		initialState: jta.states.Startup,
		skipSplash: true,
		startFullscreen: false
	};

	/**
	 * The frame rate display.
	 */
	public static var fpsDisplay:FPS;

	public static var framerate(get, set):Float;

	static function set_framerate(cap:Float):Float
	{
		if (FlxG.game != null)
		{
			FlxG.updateFramerate = Std.int(cap);
			FlxG.drawFramerate = Std.int(cap);
		}
		return Lib.current.stage.frameRate = cap;
	}

	static function get_framerate():Float
		return Lib.current.stage.frameRate;

	/**
	 * This will make it so it's run right at startup.
	 */
	private static function __init__():Void
	{
		#if hxgamemode
		if (GamemodeClient.request_start() != 0)
			Sys.println('Failed to request gamemode start: ${GamemodeClient.error_string()}...');
		else
			Sys.println('Succesfully requested gamemode to start...');
		#end
	}

	/**
	 * Initializes the game and sets up the application.
	 */
	public function new():Void
	{
		super();

		#if android
		Sys.setCwd(Path.addTrailingSlash(android.os.Build.VERSION.SDK_INT > 30 ? android.content.Context.getObbDir() : android.content.Context.getExternalFilesDir()));
		#elseif ios
		Sys.setCwd(Path.addTrailingSlash(openfl.filesystem.File.documentsDirectory.nativePath));
		#end

		#if (desktop && !debug)
		CrashHandler.init();
		#end

		#if linux
		if (Assets.exists('icon.png'))
		{
			final icon:Null<openfl.display.BitmapData> = Assets.getBitmapData('icon.png', false);

			if (icon != null)
				Lib.application.window.setIcon(icon.image);
		}
		#end

		#if windows
		jta.api.native.WindowsAPI.darkMode(true);
		#end

		#if hxdiscord_rpc
		DiscordClient.load();
		#end

		CleanupUtil.init();
		ResizeUtil.init();

		framerate = 60; // Default framerate
		addChild(new Game(config.gameDimensions[0], config.gameDimensions[1], config.initialState, config.framerate, config.framerate, config.skipSplash,
			config.startFullscreen));

		var vidSource:String = 'assets/videos/DO NOT DELETE OR GAME WILL CRASH/dontDelete.webm';

		#if web
		var str1:String = 'HTML VIDEO';
		var vHandler = new VideoHandler();
		vHandler.init1();
		vHandler.video.name = str1;
		addChild(vHandler.video);
		vHandler.init2();
		GlobalVideo.setVid(vHandler);
		vHandler.source(vidSource);
		#elseif desktop
		var str1:String = 'WEBM VIDEO';
		var webmHandle = new WebmHandler();
		webmHandle.source(vidSource);
		webmHandle.makePlayer();
		webmHandle.webm.name = str1;
		addChild(webmHandle.webm);
		GlobalVideo.setWebm(webmHandle);
		#end

		#if android
		FlxG.android.preventDefaultKeys = [BACK];
		#end

		FlxG.sound.volumeUpKeys = [];
		FlxG.sound.volumeDownKeys = [];
		FlxG.sound.muteKeys = [];

		fpsDisplay = new FPS(10, 10, 0xffffff);
		addChild(fpsDisplay);

		FlxG.mouse.visible = false;
	}
}
