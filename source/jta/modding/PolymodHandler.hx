package jta.modding;

import polymod.Polymod;
import polymod.format.ParseRules;
import flixel.util.FlxStringUtil;
import jta.macros.ClassMacro;
#if windows
import jta.api.native.WindowsAPI;
#end

class PolymodHandler
{
	static final MOD_DIR:String =
		#if (REDIRECT_ASSETS_FOLDER && macos)
		'../../../../../../../mods'
		#elseif REDIRECT_ASSETS_FOLDER
		'../../../../mods'
		#else
		'mods'
		#end;
	static final CORE_DIR:String =
		#if (REDIRECT_ASSETS_FOLDER && macos)
		'../../../../../../../assets'
		#elseif REDIRECT_ASSETS_FOLDER
		'../../../../assets'
		#else
		#if desktop
		'assets'
		#else
		null
		#end
		#end;

	static final API_VERSION:String = '1.0.0';

	public static var trackedMods:Array<ModMetadata> = [];

	public static function init(?framework:Null<Framework>):Void
	{
		Polymod.clearScripts();

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

		for (cls in ClassMacro.listClassesInPackage('polymod'))
		{
			if (cls == null)
				continue;

			Polymod.blacklistImport(Type.getClassName(cls));
		}

		#if sys
		for (cls in ClassMacro.listClassesInPackage('sys'))
		{
			if (cls == null)
				continue;

			Polymod.blacklistImport(Type.getClassName(cls));
		}
		#end

		#if sys
		if (!FileSystem.exists(MOD_DIR))
			FileSystem.createDirectory(MOD_DIR);
		#end

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
			loadScriptsAsync: #if html5 true #else false #end,
			ignoredFiles: Polymod.getDefaultIgnoreList()
		});

		jta.registries.dialogue.TyperRegistry.loadTypers();
		jta.registries.dialogue.PortraitRegistry.loadPortraits();

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
		var code:String = FlxStringUtil.toTitleCase(Std.string(error.code).split('_').join(' '));

		switch (error.severity)
		{
			case NOTICE:
				FlxG.log.notice('($code) ${error.message}');
			case WARNING:
				FlxG.log.warn('($code) ${error.message}');

				#if (windows && debug)
				WindowsAPI.messageBox(code, error.message);
				#end
			case ERROR:
				FlxG.log.error('($code) ${error.message}');

				#if windows
				WindowsAPI.messageBox(code, error.message, MSG_ERROR);
				#end
		}
	}
}
