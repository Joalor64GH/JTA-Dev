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
	public static final SOUND_EXT:String = #if !web "ogg" #else "mp3" #end;
	public static final getText:String->String = #if sys File.getContent #else Assets.getText #end;

	static function findAsset(path:String, exts:Array<String>):String
	{
		for (ext in exts)
			if (path.extension() == '' && Assets.exists(path.withExtension(ext)))
				return path.withExtension(ext);
		return path;
	}

	public static function exists(path:String):Bool
		return Assets.exists(path);

	inline public static function getTextArray(path:String):Array<String>
		return exists(path) ? [for (i in getText(path).trim().split('\n')) i.trim()] : [];

	inline static public function txt(key:String):String
		return 'assets/$key.txt';

	inline static public function csv(key:String):String
		return 'assets/$key.csv';

	inline static public function sound(key:String, ?cache:Bool = true):Null<Sound>
		return Assets.getSound(findAsset('assets/sounds/$key', [SOUND_EXT, "wav"]), cache);

	inline static public function music(key:String, ?cache:Bool = true):Null<Sound>
		return Assets.getSound(findAsset('assets/music/$key', [SOUND_EXT, "wav"]), cache);

	inline static public function font(key:String, ?cache:Bool = true):Null<String>
		return Assets.getFont(findAsset('assets/fonts/$key', ["ttf", "otf"]), cache).fontName;

	inline static public function image(key:String):String
		return 'assets/images/$key.png';

	inline static public function video(key:String):String
		return 'assets/videos/$key.webm';

	inline static public function videoSound(key:String, ?cache:Bool = true):Null<Sound>
		return Assets.getSound(findAsset('assets/videos/$key', [SOUND_EXT, "wav"]), cache);

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
