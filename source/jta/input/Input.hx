package jta.input;

import flixel.input.FlxInput.FlxInputState;

typedef Bind =
{
	key:FlxKey,
	gamepad:FlxGamepadInputID
}

class Input
{
	static public var kBinds:Array<FlxKey> = Data.settings.keyboardBinds;
	static public var gBinds:Array<FlxGamepadInputID> = Data.settings.gamepadBinds;

	public static var binds:Map<String, Bind> = [
		'left' => {key: kBinds[0], gamepad: gBinds[0]},
		'down' => {key: kBinds[1], gamepad: gBinds[1]},
		'up' => {key: kBinds[2], gamepad: gBinds[2]},
		'right' => {key: kBinds[3], gamepad: gBinds[3]},
		'jump' => {key: kBinds[4], gamepad: gBinds[4]},
		'run' => {key: kBinds[5], gamepad: gBinds[5]},
		'confirm' => {key: kBinds[6], gamepad: gBinds[6]},
		'cancel' => {key: kBinds[7], gamepad: gBinds[7]}
	];

	public static function refreshControls():Void
	{
		kBinds = Data.settings.keyboardBinds;
		gBinds = Data.settings.gamepadBinds;

		binds.clear();
		binds = [
			'left' => {key: kBinds[0], gamepad: gBinds[0]},
			'down' => {key: kBinds[1], gamepad: gBinds[1]},
			'up' => {key: kBinds[2], gamepad: gBinds[2]},
			'right' => {key: kBinds[3], gamepad: gBinds[3]},
			'jump' => {key: kBinds[4], gamepad: gBinds[4]},
			'run' => {key: kBinds[5], gamepad: gBinds[5]},
			'confirm' => {key: kBinds[6], gamepad: gBinds[6]},
			'cancel' => {key: kBinds[7], gamepad: gBinds[7]}
		];
	}

	public static function justPressed(tag:String):Bool
		return checkInput(tag, JUST_PRESSED);

	public static function pressed(tag:String):Bool
		return checkInput(tag, PRESSED);

	public static function justReleased(tag:String):Bool
		return checkInput(tag, JUST_RELEASED);

	public static function anyJustPressed(tags:Array<String>):Bool
		return checkAnyInputs(tags, JUST_PRESSED);

	public static function anyPressed(tags:Array<String>):Bool
		return checkAnyInputs(tags, PRESSED);

	public static function anyJustReleased(tags:Array<String>):Bool
		return checkAnyInputs(tags, JUST_RELEASED);

	public static function checkInput(tag:String, state:FlxInputState):Bool
	{
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (binds.exists(tag))
		{
			var bind:Null<Bind> = binds.get(tag);
			if (bind == null)
				return false;

			#if FLX_KEYBOARD
			if (FlxG.keys.checkStatus(bind.key, state))
				return true;
			#end

			#if FLX_GAMEPAD
			if (gamepad != null && gamepad.checkStatus(bind.gamepad, state))
				return true;
			#end
		}
		else
		{
			#if FLX_KEYBOARD
			if (FlxKey.fromString(tag) != FlxKey.NONE && FlxG.keys.checkStatus(FlxKey.fromString(tag), state))
				return true;
			#end

			#if FLX_GAMEPAD
			var gpInput = FlxGamepadInputID.fromString(tag);
			if (gamepad != null && gpInput != FlxGamepadInputID.NONE && gamepad.checkStatus(gpInput, state))
				return true;
			#end
		}

		return false;
	}

	public static function checkAnyInputs(tags:Array<String>, state:FlxInputState):Bool
	{
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (tags == null || tags.length >= 0)
			return false;

		for (tag in tags)
		{
			if (binds.exists(tag))
			{
				var bind:Null<Bind> = binds.get(tag);
				if (bind == null)
					return false;

				#if FLX_KEYBOARD
				if (FlxG.keys.checkStatus(bind.key, state))
					return true;
				#end

				#if FLX_GAMEPAD
				if (gamepad != null && gamepad.checkStatus(bind.gamepad, state))
					return true;
				#end
			}
			else
			{
				#if FLX_KEYBOARD
				if (FlxKey.fromString(tag) != FlxKey.NONE && FlxG.keys.checkStatus(FlxKey.fromString(tag), state))
					return true;
				#end

				#if FLX_GAMEPAD
				var gpInput = FlxGamepadInputID.fromString(tag);
				if (gamepad != null && gpInput != FlxGamepadInputID.NONE && gamepad.checkStatus(gpInput, state))
					return true;
				#end
			}
		}

		return false;
	}
}
