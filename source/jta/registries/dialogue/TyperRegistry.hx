package jta.registries.dialogue;

import jta.objects.dialogue.typers.ScriptedTyper;
import jta.objects.dialogue.typers.Typer;

class TyperRegistry
{
	private static final typerScriptedClasses:Map<String, String> = [];

	public static function loadTypers():Void
	{
		clearTypers();

		final scriptedTypers:Array<String> = ScriptedTyper.listScriptClasses();

		if (scriptedTypers.length > 0)
		{
			FlxG.log.notice('Initiating ${scriptedTypers.length} scripted dialogue typers...');

			for (scriptedTyper in scriptedTypers)
			{
				final typer:Typer = ScriptedTyper.init(scriptedTyper, 'unknown');

				if (typer == null)
					continue;

				FlxG.log.notice('Initialized dialogue typer "${typer.typerID}"!');

				typerScriptedClasses.set(typer.typerID, scriptedTyper);
			}
		}

		FlxG.log.notice('Successfully loaded ${Lambda.count(typerScriptedClasses)} typer(s)!');
	}

	public static function fetchTyper(typerID:String):Null<Typer>
	{
		if (!typerScriptedClasses.exists(typerID))
		{
			FlxG.log.error('Unable to load "${typerID}", not found in cache');

			return null;
		}

		final typerScriptedClass:Null<String> = typerScriptedClasses.get(typerID);

		if (typerScriptedClass != null)
		{
			final typer:Typer = ScriptedTyper.init(typerScriptedClass, typerID);

			if (typer == null)
			{
				FlxG.log.error('Unable to initiate "${typerID}"');

				return null;
			}

			return typer;
		}

		return null;
	}

	public static function clearTypers():Void
	{
		if (typerScriptedClasses != null)
			typerScriptedClasses.clear();
	}
}
