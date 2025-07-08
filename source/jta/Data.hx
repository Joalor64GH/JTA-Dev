package jta;

@:structInit class Settings
{
	public var volume:Int = 100;
	public var framerate:Int = 60;
	public var fpsCounter:Bool = true;
	#if desktop
	public var fullscreen:Bool = false;
	#end

	public var skipSplash:Bool = false;

	public var keyboardBinds:Array<FlxKey> = [LEFT, DOWN, UP, RIGHT, SPACE, SHIFT, ENTER, ESCAPE];
	public var gamepadBinds:Array<FlxGamepadInputID> = [DPAD_LEFT, DPAD_DOWN, DPAD_UP, DPAD_RIGHT, A, B, START, BACK];
}

class Data
{
	public static var settings:Settings = {};

	public static function init():Void
	{
		for (key in Reflect.fields(settings))
			if (Reflect.field(FlxG.save.data, key) != null)
				Reflect.setField(settings, key, Reflect.field(FlxG.save.data, key));

		if (Main.fpsDisplay != null)
			Main.fpsDisplay.visible = settings.fpsCounter;

		if (FlxG.save.data.framerate == null)
		{
			final refreshRate:Int = FlxG.stage.application.window.displayMode.refreshRate;
			settings.framerate = Std.int(FlxMath.bound(refreshRate, 60, 240));
		}

		Main.framerate = settings.framerate;
	}

	public static function saveSettings():Void
	{
		for (key in Reflect.fields(settings))
			Reflect.setField(FlxG.save.data, key, Reflect.field(settings, key));

		FlxG.save.flush();

		trace('settings saved!');
	}
}
