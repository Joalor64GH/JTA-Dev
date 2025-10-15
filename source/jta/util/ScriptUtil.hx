package jta.util;

import haxe.Json;
import flixel.FlxBasic;
import flixel.util.FlxAxes;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import openfl.display.BlendMode as BaseBlendMode;

class ScriptingUtil
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

class BlendMode
{
	public static var ADD = BaseBlendMode.ADD;
	public static var ALPHA = BaseBlendMode.ALPHA;
	public static var DARKEN = BaseBlendMode.DARKEN;
	public static var DIFFERENCE = BaseBlendMode.DIFFERENCE;
	public static var ERASE = BaseBlendMode.ERASE;
	public static var HARDLIGHT = BaseBlendMode.HARDLIGHT;
	public static var INVERT = BaseBlendMode.INVERT;
	public static var LAYER = BaseBlendMode.LAYER;
	public static var LIGHTEN = BaseBlendMode.LIGHTEN;
	public static var MULTIPLY = BaseBlendMode.MULTIPLY;
	public static var NORMAL = BaseBlendMode.NORMAL;
	public static var OVERLAY = BaseBlendMode.OVERLAY;
	public static var SCREEN = BaseBlendMode.SCREEN;
	public static var SHADER = BaseBlendMode.SHADER;
	public static var SUBTRACT = BaseBlendMode.SUBTRACT;
}

class FlxTweenType
{
	public static var PERSIST = FlxTween.FlxTweenType.PERSIST;
	public static var LOOPING = FlxTween.FlxTweenType.LOOPING;
	public static var PINGPONG = FlxTween.FlxTweenType.PINGPONG;
	public static var ONESHOT = FlxTween.FlxTweenType.ONESHOT;
	public static var BACKWARD = FlxTween.FlxTweenType.BACKWARD;
}

class FlxTextBorderStyle
{
	public static var NONE = FlxText.FlxTextBorderStyle.NONE;
	public static var SHADOW = FlxText.FlxTextBorderStyle.SHADOW;
	public static var OUTLINE = FlxText.FlxTextBorderStyle.OUTLINE;
	public static var OUTLINE_FAST = FlxText.FlxTextBorderStyle.OUTLINE_FAST;
}

class FlxAxes
{
	public static var NONE:FlxAxes = FlxAxes.NONE;
	public static var X:FlxAxes = FlxAxes.X;
	public static var XY:FlxAxes = FlxAxes.XY;
	public static var Y:FlxAxes = FlxAxes.Y;

	public static function fromBools(x:Bool, y:Bool):FlxAxes
	{
		return FlxAxes.fromBools(x, y);
	}

	public static function fromString(axes:String):FlxAxes
	{
		return FlxAxes.fromString(axes);
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