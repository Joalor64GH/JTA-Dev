package jta.registries.dialogue;

import jta.objects.dialogue.portraits.ScriptedPortrait;
import jta.objects.dialogue.portraits.Portrait;

class PortraitRegistry
{
	private static final portraitScriptedClasses:Map<String, String> = [];

	public static function loadPortraits():Void
	{
		clearPortraits();

		final scriptedPortraits:Array<String> = ScriptedPortrait.listScriptClasses();

		if (scriptedPortraits.length > 0)
		{
			FlxG.log.notice('Initiating ${scriptedPortraits.length} scripted dialogue portraits...');

			for (scriptedPortrait in scriptedPortraits)
			{
				final portrait:Portrait = ScriptedPortrait.init(scriptedPortrait, 'unknown');

				if (portrait == null)
					continue;

				FlxG.log.notice('Initialized dialogue portrait "${portrait.portraitID}"!');

				portraitScriptedClasses.set(portrait.portraitID, scriptedPortrait);
			}
		}

		FlxG.log.notice('Successfully loaded ${Lambda.count(portraitScriptedClasses)} portrait(s)!');
	}

	public static function fetchPortrait(portraitID:String):Null<Portrait>
	{
		if (!portraitScriptedClasses.exists(portraitID))
		{
			FlxG.log.error('Unable to load "${portraitID}", not found in cache');

			return null;
		}

		final portraitScriptedClass:Null<String> = portraitScriptedClasses.get(portraitID);

		if (portraitScriptedClass != null)
		{
			final portrait:Portrait = ScriptedPortrait.init(portraitScriptedClass, portraitID);

			if (portrait == null)
			{
				FlxG.log.error('Unable to initiate "${portraitID}"');

				return null;
			}

			return portrait;
		}

		return null;
	}

	public static function clearPortraits():Void
	{
		if (portraitScriptedClasses != null)
			portraitScriptedClasses.clear();
	}
}
