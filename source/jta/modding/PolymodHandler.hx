package jta.modding;

import polymod.Polymod;
import polymod.format.ParseRules;
import polymod.fs.ZipFileSystem;
import flixel.util.FlxStringUtil;
#if windows
import jta.api.native.WindowsAPI;
#end
import jta.util.macro.ClassMacro;
import jta.util.WindowUtil;
import jta.util.TimerUtil;
import jta.locale.Locale;
#if sys
import sys.FileSystem;
#end

/**
 * Handles the initialization and management of mods in the game.
 * @see https://github.com/FunkinCrew/Funkin/blob/main/source/funkin/modding/PolymodHandler.hx
 */
class PolymodHandler
{
	/**
	 * The root directory for mods.
	 */
	static final MOD_DIR:String =
		#if (REDIRECT_ASSETS_FOLDER && macos)
		'../../../../../../../mods'
		#elseif REDIRECT_ASSETS_FOLDER
		'../../../../mods'
		#else
		'mods'
		#end;

	/**
	 * The core directory for assets.
	 */
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

	/**
	 * The API version of the modding system.
	 */
	static final API_VERSION:String = '1.0.0';

	/**
	 * Stores the metadata of currently loaded mods.
	 */
	public static var trackedMods:Array<ModMetadata> = [];

	/**
	 * Loads all mods and initializes the Polymod system.
	 * @param framework The framework to use for modding.
	 */
	public static function init(?framework:Null<Framework>):Void
	{
		Polymod.clearScripts();

		Polymod.addDefaultImport(jta.util.ScriptUtil);
		Polymod.addDefaultImport(jta.util.ScriptUtil.BlendMode);
		Polymod.addDefaultImport(jta.util.ScriptUtil.FlxTextBorderStyle);
		Polymod.addDefaultImport(jta.util.ScriptUtil.FlxAxes);

		Polymod.addImportAlias('flixel.effects.particles.FlxEmitter', flixel.effects.particles.FlxEmitter);
		Polymod.addImportAlias('flixel.group.FlxContainer', flixel.group.FlxContainer);
		Polymod.addImportAlias('flixel.group.FlxGroup', flixel.group.FlxGroup);
		Polymod.addImportAlias('flixel.group.FlxSpriteContainer', flixel.group.FlxSpriteContainer);
		Polymod.addImportAlias('flixel.group.FlxSpriteGroup', flixel.group.FlxSpriteGroup);
		Polymod.addImportAlias('flixel.math.FlxPoint', flixel.math.FlxPoint.FlxBasePoint);

		Polymod.addImportAlias("lime.utils.Assets", Assets);
		Polymod.addImportAlias("openfl.utils.Assets", Assets);
		Polymod.addImportAlias("haxe.Json", jta.util.ScriptUtil.NativeJson);
		
		Polymod.addImportAlias("flash.display.BlendMode", jta.util.ScriptUtil.BlendMode);
		Polymod.addImportAlias("openfl.display.BlendMode", jta.util.ScriptUtil.BlendMode);
		Polymod.addImportAlias("flixel.util.FlxAxes", jta.util.ScriptUtil.FlxAxes);

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

		for (cls in ClassMacro.listClassesInPackage('jta.util.macro'))
		{
			if (cls == null)
				continue;

			Polymod.blacklistImport(Type.getClassName(cls));
		}

		for (cls in ClassMacro.listClassesInPackage('extension.androidtools'))
		{
			if (cls == null)
				continue;

			Polymod.blacklistImport(Type.getClassName(cls));
		}

		for (cls in ClassMacro.listClassesInPackage('hscript'))
		{
			if (cls == null)
				continue;

			Polymod.blacklistImport(Type.getClassName(cls));
		}

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

		Locale.init(); // Initialize localization before Polymod
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
			ignoredFiles: Polymod.getDefaultIgnoreList(),
			extensionMap: ['frag' => TEXT, 'vert' => TEXT],
			customFilesystem: buildFileSystem(),
			firetongue: Locale.tongue
		});

		final registriesStart:Float = TimerUtil.start();

		jta.registries.dialogue.TyperRegistry.loadTypers();
		jta.registries.dialogue.PortraitRegistry.loadPortraits();

		jta.registries.level.PlayerRegistry.loadPlayers();
		jta.registries.level.ObjectRegistry.loadObjects();

		jta.registries.LevelRegistry.loadLevels();

		jta.registries.ModuleRegistry.loadModules();

		FlxG.log.notice('Registries loading took: ${TimerUtil.seconds(registriesStart)}');
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

	private static inline function buildFileSystem():ZipFileSystem
	{
		return new ZipFileSystem({modRoot: MOD_DIR, autoScan: true});
	}

	public static function getParseRules():ParseRules
	{
		final output:ParseRules = ParseRules.getDefault();
		output.addType('txt', TextFileFormat.LINES);
		output.addType('hxc', TextFileFormat.PLAINTEXT);
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

				#if (windows && debug && cpp)
				WindowsAPI.messageBox(code, error.message);
				#elseif debug
				WindowUtil.showAlert(code, error.message);
				#end
			case ERROR:
				FlxG.log.error('($code) ${error.message}');

				#if (windows && cpp)
				WindowsAPI.messageBox(code, error.message, MSG_ERROR);
				#else
				WindowUtil.showAlert(code, error.message);
				#end
		}
	}
}
