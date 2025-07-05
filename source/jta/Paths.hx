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
	inline static public function csv(key:String)
		return 'assets/$key.csv';

	inline static public function sound(key:String, ?cache:Bool = true):Null<Sound>
		return Assets.getSound('assets/sounds/$key.ogg', cache);

	inline static public function music(key:String, ?cache:Bool = true):Null<Sound>
		return Assets.getSound('assets/music/$key.ogg', cache);

	inline static public function image(key:String)
		return 'assets/images/$key.png';

	inline static public function font(key:String)
	{
		var path:String = 'assets/fonts/$key';

		for (i in ["ttf", "otf"])
			if (path.extension() == '' && Assets.exists(path.withExtension(i)))
				path = path.withExtension(i);

		return path;
	}

	public static inline function spritesheet(key:String, ?type:SpriteSheetType):FlxAtlasFrames
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
