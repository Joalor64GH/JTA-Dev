package jta.util;

import haxe.Json;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.util.FlxAxes;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import openfl.display.BlendMode as BaseBlendMode;

class ScriptUtil
{
	public static inline function makeFlxGroup():FlxTypedGroup<FlxBasic>
	{
		return new FlxTypedGroup<FlxBasic>();
	}

	public static inline function makeFlxSpriteGroup():FlxTypedSpriteGroup<FlxSprite>
	{
		return new FlxTypedSpriteGroup<FlxSprite>();
	}

	public static inline function screenCenter(obj:FlxObject, ?x:Bool = true, ?y:Bool = true):Void
	{
		if (x)
			obj.x = (FlxG.width - obj.width) / 2;
		if (y)
			obj.y = (FlxG.height - obj.height) / 2;
	}
}

class NativeJson
{
	public static inline function parse(text:String):Dynamic
	{
		return Json.parse(text);
	}

	public static inline function stringify(value:Dynamic, ?replacer:(key:Dynamic, value:Dynamic) -> Dynamic, ?space:String):String
	{
		return Json.stringify(value, replacer, space);
	}
}