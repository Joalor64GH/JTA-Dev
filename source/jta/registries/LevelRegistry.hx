package jta.registries;

import jta.states.level.Level;
import jta.states.level.ScriptedLevel;

class LevelRegistry
{
	private static final levelScriptedClasses:Map<Int, String> = [];

	public static function loadLevels():Void
	{
		clearLevels();

		final levelList:Array<String> = ScriptedLevel.listScriptClasses();

		if (levelList.length > 0)
		{
			FlxG.log.notice('Initiating ${levelList.length} levels...');

			for (levelClass in levelList)
			{
				final level:Level = ScriptedLevel.init(levelClass, 0);

				if (level == null)
					continue;

				FlxG.log.notice('Initialized level "${level.levelNumber}"!');

				levelScriptedClasses.set(level.levelNumber, levelClass);
			}
		}

		FlxG.log.notice('Successfully loaded ${Lambda.count(levelScriptedClasses)} level(s)!');
	}

	public static function fetchLevel(levelNumber:Int):Null<Level>
	{
		if (!levelScriptedClasses.exists(levelNumber))
		{
			FlxG.log.error('Unable to load level number "${levelNumber}", not found in cache');

			return null;
		}

		final levelClass:Null<String> = levelScriptedClasses.get(levelNumber);

		if (levelClass != null)
		{
			final level:Level = ScriptedLevel.init(levelClass, levelNumber);

			if (level == null)
			{
				FlxG.log.error('Unable to initiate level number "${levelNumber}"');

				return null;
			}

			return level;
		}

		return null;
	}

	public static function clearLevels():Void
	{
		if (levelScriptedClasses != null)
			levelScriptedClasses.clear();
	}
}
