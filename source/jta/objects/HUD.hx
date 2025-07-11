package jta.objects;

import jta.Global;

class HUD extends FlxTypedGroup<FlxSprite>
{
	var scoreTxt:FlxText;
	var coinsTxt:FlxText;
	var livesTxt:FlxText;

	public function new():Void
	{
		super();

		livesTxt = new FlxText(10, 10, 200, "", 24);
		livesTxt.setFormat(Paths.font('main'), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(livesTxt);

		coinsTxt = new FlxText(10, 40, 200, "", 24);
		coinsTxt.setFormat(Paths.font('main'), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(coinsTxt);

		scoreTxt = new FlxText(0, 10, 250, "", 24);
		scoreTxt.setFormat(Paths.font('main'), 24, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(scoreTxt);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		scoreTxt.text = "Score: " + Global.score;
		scoreTxt.x = FlxG.width - scoreTxt.width - 10;

		coinsTxt.text = "Coins: " + Global.coins;
		livesTxt.text = "Lives: " + Global.lives;
	}
}
