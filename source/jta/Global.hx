package jta;

class Global
{
	public static var coins:Int = 0;

	private static var _score:Int = 0;
	public static var score(get, set):Int;

	static function get_score():Int
		return _score;

	static function set_score(value:Int):Int
	{
		_score = (value > 9999990) ? 9999990 : value;
		return _score;
	}

	public static var lives:Int = 3;

	public static function save():Void
	{
		var save:FlxSave = new FlxSave();
		save.bind('file', Lib.application.meta.get('file'));
		save.data.coins = coins;
		save.data.score = score;
		save.data.lives = lives;
		save.close();
	}

	public static function load():Void
	{
		var save:FlxSave = new FlxSave();
		save.bind('file', Lib.application.meta.get('file'));
		if (!save.isEmpty())
		{
			if (save.data.coins != null)
				coins = save.data.coins;

			if (save.data.score != null)
				score = save.data.score;

			if (save.data.lives != null)
				lives = save.data.lives;
		}
		save.destroy();
	}
}
