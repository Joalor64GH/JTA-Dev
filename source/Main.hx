package;

import jta.debug.FPS;

class Main extends openfl.display.Sprite
{
	public final config:Dynamic = {
		gameDimensions: [800, 600],
		framerate: 60,
		initialState: jta.states.Startup,
		skipSplash: false,
		startFullscreen: false
	};

	public static var fpsDisplay:FPS;

	public static var framerate(get, set):Float;

	static function set_framerate(cap:Float):Float
	{
		if (FlxG.game != null)
		{
			var _framerate:Int = Std.int(cap);
			if (_framerate > FlxG.drawFramerate)
			{
				FlxG.updateFramerate = _framerate;
				FlxG.drawFramerate = _framerate;
			}
			else
			{
				FlxG.drawFramerate = _framerate;
				FlxG.updateFramerate = _framerate;
			}
		}
		return Lib.current.stage.frameRate = cap;
	}

	static function get_framerate():Float
		return Lib.current.stage.frameRate;

	public function new():Void
	{
		super();

		#if hxdiscord_rpc
		jta.api.DiscordClient.load();
		#end

		framerate = 60; // Default framerate
		addChild(new FlxGame(config.gameDimensions[0], config.gameDimensions[1], config.initialState, config.framerate, config.framerate, config.skipSplash,
			config.startFullscreen));

		FlxG.sound.volumeUpKeys = [];
		FlxG.sound.volumeDownKeys = [];
		FlxG.sound.muteKeys = [];

		fpsDisplay = new FPS(10, 10, 0xffffff);
		addChild(fpsDisplay);

		FlxG.mouse.visible = false;
	}
}
