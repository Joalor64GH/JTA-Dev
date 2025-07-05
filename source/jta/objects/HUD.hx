package jta.objects;

import jta.Global;

class HUD extends FlxTypedGroup<FlxSprite>
{
	var scoreTxt:FlxText;
	var coinsTxt:FlxText;
	var timeTxt:FlxText;
	var livesTxt:FlxText;

	public function new()
	{
		super();

		livesTxt = new FlxText(10, 10, 200, "Lives: " + Global.lives, 24);
		livesTxt.setFormat(Paths.font('main'), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(livesTxt);

		coinsTxt = new FlxText(10, 40, 200, "Coins: " + Global.coins, 24);
		coinsTxt.setFormat(Paths.font('main'), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(coinsTxt);

		scoreTxt = new FlxText(FlxG.width - 250 - 120, 10, 250, "Score: " + Global.score, 24);
		scoreTxt.setFormat(Paths.font('main'), 24, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(scoreTxt);

		timeTxt = new FlxText(FlxG.width - 120 - 10, 10, 120, "Time: 360", 24);
		timeTxt.setFormat(Paths.font('main'), 24, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(timeTxt);
	}
}
