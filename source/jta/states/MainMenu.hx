package jta.states;

import jta.Paths;
import jta.input.Input;
import jta.states.BaseState;
import jta.states.config.Settings;
import jta.registries.LevelRegistry;

class MainMenu extends BaseState
{
	var selections:Array<String> = ["Start Game", "Options"];
	var selectedIndex:Int = 0;

	var selectionGroup:FlxTypedGroup<FlxText>;

	var player:FlxSprite;

	var animTimer:Float = 0;
	var animCooldown:Float = 3 + FlxG.random.float(0, 2);
	var isAnimating:Bool = false;

	var versionTxt:FlxText;

	public function new():Void
	{
		super();

		#if desktop
		selections.push("Exit");
		#end
	}

	override public function create():Void
	{
		#if hxdiscord_rpc
		jta.api.DiscordClient.changePresence('Main Menu', null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/menu_bg'));
		bg.screenCenter();
		add(bg);

		var logo:FlxSprite = new FlxSprite(0, 125).loadGraphic(Paths.image('menu/mainmenu/logo'));
		logo.scale.set(4, 4);
		logo.screenCenter(X);
		add(logo);

		FlxTween.tween(logo, {y: logo.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});

		selectionGroup = new FlxTypedGroup<FlxText>();
		add(selectionGroup);

		for (i in 0...selections.length)
		{
			var selection:FlxText = new FlxText(10, 400 + i * 42, FlxG.width, selections[i]);
			selection.setFormat(Paths.font('main'), 36, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			selection.ID = i;
			selectionGroup.add(selection);
		}

		player = new FlxSprite(0, 700).loadGraphic(Paths.image('menu/mainmenu/playerTitle'), true, 15, 38);
		player.animation.add('idle', [0], 1);
		player.animation.add('blink', [1], 1);
		player.animation.add('left', [2], 1);
		player.animation.add('right', [3], 1);
		player.scale.set(9.5, 9.5);
		player.screenCenter(X);
		add(player);

		FlxTween.tween(player, {y: 500}, 1, {ease: FlxEase.quadOut});

		versionTxt = new FlxText(0, FlxG.height - 30, 250, "v" + Lib.application.meta.get('version') + " (DEMO)", 24);
		versionTxt.setFormat(Paths.font('main'), 24, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionTxt);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (Input.justPressed('up'))
			changeSelection(-1);
		else if (Input.justPressed('down'))
			changeSelection(1);

		if (Input.justPressed('confirm'))
		{
			switch (selectedIndex)
			{
				case 0:
					FlxG.sound.play(Paths.sound('select'));
					transitionState(LevelRegistry.fetchLevel(272));
				case 1:
					FlxG.sound.play(Paths.sound('select'));
					transitionState(new Settings());
				case 2:
					#if desktop
					Sys.exit(0);
					#elseif web
					lime.utils.Log.error('What?! This shouldn\'t be possible!');
					#end
			}
		}

		selectionGroup.forEach(function(text:FlxText)
		{
			text.color = (text.ID == selectedIndex) ? FlxColor.YELLOW : FlxColor.WHITE;
		});

		#if debug
		if (Input.justPressed('v'))
		{
			transitionState(new jta.video.VideoState('paint', () ->
			{
				transitionState(new jta.states.MainMenu());
			}));
		}
		#end

		super.update(elapsed);

		versionTxt.x = FlxG.width - versionTxt.width - 10;

		animTimer += elapsed;

		if (!isAnimating && animTimer >= animCooldown)
		{
			animTimer = 0;
			animCooldown = 3 + FlxG.random.float(0, 2);
			isAnimating = true;

			var anims:Array<String> = ["idle", "left", "right"];
			var nextAnim = FlxG.random.getObject(anims);

			player.animation.play("blink");

			FlxTimer.wait(0.2, function():Void
			{
				player.animation.play(nextAnim);
				isAnimating = false;
			});
		}
	}

	private function changeSelection(num:Int):Void
	{
		FlxG.sound.play(Paths.sound('scroll'));
		selectedIndex = FlxMath.wrap(selectedIndex + num, 0, selections.length - 1);
	}
}
