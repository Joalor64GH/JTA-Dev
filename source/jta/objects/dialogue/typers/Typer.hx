package jta.objects.dialogue.typers;

import flixel.util.FlxStringUtil;
import flixel.util.FlxDestroyUtil;
import openfl.media.Sound;

typedef TypingSound =
{
	sound:Sound,
	volume:Float,
	?pitch:Float
}

class Typer implements IFlxDestroyable
{
	public var typerID:String;
	public var typerOffset:FlxPoint = FlxPoint.get();
	public var typerSounds:Array<TypingSound>;
	public var typerFPS:Float;
	public var fontName:String;
	public var fontSize:Int;
	public var fontSpacing:Null<Float>;

	public function new(typerID:String):Void
	{
		this.typerID = typerID;
	}

	public function destroy():Void
	{
		typerOffset = FlxDestroyUtil.put(typerOffset);
		typerSounds = FlxArrayUtil.clearArray(typerSounds);
	}

	public function toString():String
	{
		return FlxStringUtil.getDebugString([
			LabelValuePair.weak("Typer ID", typerID),
			LabelValuePair.weak("Font Name", fontName),
			LabelValuePair.weak("Font Size", fontSize),
			LabelValuePair.weak("Font Spacing", fontSpacing),
			LabelValuePair.weak("Typer Sounds", typerSounds),
			LabelValuePair.weak("Typer Letters Per Second", typerFPS)
		]);
	}
}
