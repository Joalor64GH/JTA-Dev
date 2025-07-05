package jta.registries.level;

import jta.objects.level.Player;
import jta.objects.level.ScriptedPlayer;

class PlayerRegistry
{
	private static final playerClasses:Map<String, String> = [];

	public static function loadPlayers():Void
	{
		clearPlayers();

		final playerList:Array<String> = ScriptedPlayer.listScriptClasses();

		if (playerList.length > 0)
		{
			FlxG.log.notice('Initiating ${playerList.length} players...');

			for (player in playerList)
			{
				final play:Player = ScriptedPlayer.init(player, 'unknown');

				if (play == null)
					continue;

				FlxG.log.notice('Initialized player "${play.characterID}"!');

				playerClasses.set(play.characterID, player);
			}
		}

		FlxG.log.notice('Successfully loaded ${Lambda.count(playerClasses)} player(s)!');
	}

	public static function fetchPlayer(characterID:String):Null<Player>
	{
		if (!playerClasses.exists(characterID))
		{
			FlxG.log.error('Unable to load "${characterID}", not found in cache');

			return null;
		}

		final playerClass:Null<String> = playerClasses.get(characterID);

		if (playerClass != null)
		{
			final player:Player = ScriptedPlayer.init(playerClass, characterID);

			if (player == null)
			{
				FlxG.log.error('Unable to initiate "${characterID}"');

				return null;
			}

			return player;
		}

		return null;
	}

	public static function clearPlayers():Void
	{
		if (playerClasses != null)
			playerClasses.clear();
	}
}