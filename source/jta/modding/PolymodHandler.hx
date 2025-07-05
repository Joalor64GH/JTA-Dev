package jta.modding;

import polymod.Polymod;
import polymod.format.ParseRules;

class PolymodHandler
{
	static final MOD_DIR:String = 'mods';
	static final CORE_DIR:String = 'assets';
	static final API_VERSION:String = '1.0.0';

	public static var trackedMods:Array<ModMetadata> = [];

	public static function init(?framework:Null<Framework>):Void
	{
		Polymod.clearScripts();

		Polymod.addDefaultImport(jta.Paths);

		Polymod.addImportAlias('flixel.effects.particles.FlxEmitter', flixel.effects.particles.FlxEmitter);
		Polymod.addImportAlias('flixel.group.FlxContainer', flixel.group.FlxContainer);
		Polymod.addImportAlias('flixel.group.FlxGroup', flixel.group.FlxGroup);
		Polymod.addImportAlias('flixel.group.FlxSpriteContainer', flixel.group.FlxSpriteContainer);
		Polymod.addImportAlias('flixel.group.FlxSpriteGroup', flixel.group.FlxSpriteGroup);
		Polymod.addImportAlias('flixel.math.FlxPoint', flixel.math.FlxPoint.FlxBasePoint);

		#if cpp
		Polymod.blacklistImport('cpp.Lib');
		#end
		Polymod.blacklistImport('haxe.Serializer');
		Polymod.blacklistImport('haxe.Unserializer');
		Polymod.blacklistImport('lime.system.CFFI');
		Polymod.blacklistImport('lime.system.System');
		Polymod.blacklistImport('lime.system.JNI');
		Polymod.blacklistImport('lime.utils.Assets');
		Polymod.blacklistImport('openfl.desktop.NativeProcess');
		Polymod.blacklistImport('openfl.utils.Assets');
		Polymod.blacklistImport('Sys');
		Polymod.blacklistImport('Reflect');
		Polymod.blacklistImport('Type');

		if (!FileSystem.exists(MOD_DIR))
			FileSystem.createDirectory(MOD_DIR);

		framework ??= FLIXEL;

		Polymod.init({
			modRoot: MOD_DIR,
			dirs: getMods(),
			framework: framework,
			apiVersionRule: API_VERSION,
			errorCallback: onError,
			frameworkParams: {
				coreAssetRedirect: CORE_DIR
			},
			parseRules: getParseRules(),
			useScriptedClasses: true,
			ignoredFiles: Polymod.getDefaultIgnoreList()
		});

		jta.registries.level.PlayerRegistry.loadPlayers();
		jta.registries.level.ObjectRegistry.loadObjects();
		jta.registries.LevelRegistry.loadLevels();
	}

	public static function getMods():Array<String>
	{
		trackedMods = [];

		if (FlxG.save.data.disabledMods == null)
		{
			FlxG.save.data.disabledMods = [];
			FlxG.save.flush();
		}

		var daList:Array<String> = [];

		for (i in Polymod.scan({modRoot: MOD_DIR, apiVersionRule: '*.*.*', errorCallback: onError}))
		{
			if (i != null)
			{
				trackedMods.push(i);
				if (!FlxG.save.data.disabledMods.contains(i.id))
					daList.push(i.id);
			}
		}

		return daList != null && daList.length > 0 ? daList : [];
	}

	public static function getModIDs():Array<String>
	{
		return (trackedMods.length > 0) ? [for (i in trackedMods) i.id] : [];
	}

	public static function getParseRules():ParseRules
	{
		final output:ParseRules = ParseRules.getDefault();
		output.addType("txt", TextFileFormat.LINES);
		output.addType("hxc", TextFileFormat.PLAINTEXT);
		return output != null ? output : null;
	}

	static function onError(error:PolymodError):Void
	{
		switch (error.code)
		{
			case MOD_LOAD_PREPARE:
				trace(error.message);
			case MOD_LOAD_DONE:
				trace(error.message);
			case MISSING_ICON:
				trace(error.message);
			default:
				switch (error.severity)
				{
					case NOTICE:
						trace(error.message);
					case WARNING:
						trace(error.message);
					case ERROR:
						trace(error.message);
				}
		}
	}
}
