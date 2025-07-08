package jta.states;

import jta.Data;
import jta.Global;
import jta.modding.PolymodHandler;

class Startup extends FlxState
{
	var haxeflixel:FlxSprite;
	var haxeflixelTxt:FlxText;

	override public function create():Void
	{
		super.create();

		Data.init();
		Global.load();
		PolymodHandler.init(OPENFL);

		if (!Data.settings.skipSplash)
		{
			haxeflixel = new FlxSprite().loadGraphic(Paths.image('haxeflixel'), true, 16, 16);
			haxeflixel.animation.add("green", [0], 1);
			haxeflixel.animation.add("yellow", [1], 1);
			haxeflixel.animation.add("red", [2], 1);
			haxeflixel.animation.add("blue", [3], 1);
			haxeflixel.animation.add("full", [4, 5, 6, 7, 8, 9], 12, false);
			haxeflixel.screenCenter();
			haxeflixel.scale.set(10, 10);
			haxeflixel.alpha = 0;
			add(haxeflixel);

			haxeflixelTxt = new FlxText(0, haxeflixel.y + 130, FlxG.width, "");
			haxeflixelTxt.setFormat(Paths.font("main.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			haxeflixelTxt.screenCenter(X);
			add(haxeflixelTxt);

			new FlxTimer().start(0.041, function(tmr:FlxTimer):Void
			{
				haxeflixel.alpha = 1;
				haxeflixel.animation.play("green");
				haxeflixelTxt.text = "Made";
				haxeflixelTxt.color = 0x00b922;
			});
			new FlxTimer().start(0.184, function(tmr:FlxTimer):Void
			{
				haxeflixel.animation.play("yellow");
				haxeflixelTxt.text = "Made with";
				haxeflixelTxt.color = 0xffc132;
			});
			new FlxTimer().start(0.334, function(tmr:FlxTimer):Void
			{
				haxeflixel.animation.play("red");
				haxeflixelTxt.text = "Made with Haxe";
				haxeflixelTxt.color = 0xf5274e;
			});
			new FlxTimer().start(0.495, function(tmr:FlxTimer):Void
			{
				haxeflixel.animation.play("blue");
				haxeflixelTxt.text = "Made with HaxeFli";
				haxeflixelTxt.color = 0x3641ff;
			});
			new FlxTimer().start(0.636, function(tmr:FlxTimer):Void
			{
				haxeflixel.animation.play("full");
				haxeflixelTxt.text = "Made with HaxeFlixel";
				haxeflixelTxt.color = 0x04cdfb;
				new FlxTimer().start(1.5, function(tmr:FlxTimer):Void
				{
					FlxTween.tween(haxeflixel, {alpha: 0}, 0.5, {
						onComplete: function(twn:FlxTween):Void
						{
							haxeflixel.kill();
							haxeflixel.destroy();
							new FlxTimer().start(0.5, function(tmr:FlxTimer):Void
							{
								FlxG.switchState(() -> new MainMenu());
							});
						}
					});
					FlxTween.tween(haxeflixelTxt, {alpha: 0}, 0.5);
				});
			});
		}
		else
		{
			FlxG.switchState(() -> new MainMenu());
		}
	}
}
