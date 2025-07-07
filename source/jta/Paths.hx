package jta;

import flixel.graphics.frames.FlxAtlasFrames;
import openfl.media.Sound;

using haxe.io.Path;

enum SpriteSheetType
{
	ASEPRITE;
	PACKER;
	SPARROW;
	TEXTURE_PATCHER_JSON;
	TEXTURE_PATCHER_XML;
}

@:keep
class Paths
{
	static function findAsset(path:String, exts:Array<String>):String
	{
		for (ext in exts)
			if (path.extension() == '' && Assets.exists(path.withExtension(ext)))
				return path.withExtension(ext);
		return path;
	}

	public static function exists(path:String):Bool
		return Assets.exists(path);

	inline static public function csv(key:String):String
		return 'assets/$key.csv';

	inline static public function sound(key:String, ?cache:Bool = true):Null<Sound>
	{
		var path = findAsset('assets/sounds/$key', [#if !web "ogg" #else "mp3" #end, "wav"]);
		return Assets.getSound(path, cache);
	}

	inline static public function music(key:String, ?cache:Bool = true):Null<Sound>
	{
		var path = findAsset('assets/music/$key', [#if !web "ogg" #else "mp3" #end, "wav"]);
		return Assets.getSound(path, cache);
	}

	inline static public function font(key:String, ?cache:Bool = true):Null<String>
	{
		var path = findAsset('assets/fonts/$key', ["ttf", "otf"]);
		return Assets.getFont(path, cache).fontName;
	}

	inline static public function image(key:String):String
		return 'assets/images/$key.png';

	public static inline function spritesheet(key:String, ?type:SpriteSheetType):Null<FlxAtlasFrames>
	{
		type = type ?? SPARROW;
		return switch (type)
		{
			case ASEPRITE: FlxAtlasFrames.fromAseprite(image(key), image(key).withExtension('json'));
			case PACKER: FlxAtlasFrames.fromSpriteSheetPacker(image(key), image(key).withExtension('txt'));
			case SPARROW: FlxAtlasFrames.fromSparrow(image(key), image(key).withExtension('xml'));
			case TEXTURE_PATCHER_JSON: FlxAtlasFrames.fromTexturePackerJson(image(key), image(key).withExtension('json'));
			case TEXTURE_PATCHER_XML: FlxAtlasFrames.fromTexturePackerXml(image(key), image(key).withExtension('xml'));
			default: FlxAtlasFrames.fromSparrow(image('errorSparrow'), image('errorSparrow').withExtension('xml'));
		}
	}
}
