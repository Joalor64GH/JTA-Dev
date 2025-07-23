package jta.states;

import jta.Paths;
import jta.input.Input;
import jta.states.MainMenu;
import jta.states.BaseState;
import jta.registries.LevelRegistry;

class LevelSelect extends BaseState
{
	var levelList:Array<{name:String, id:String}> = [];
	var selectedIndex:Int = 0;

	var coverGroup:FlxTypedGroup<FlxSprite>;
	var titleText:FlxText;

	override public function create():Void
	{
		#if hxdiscord_rpc
		jta.api.DiscordClient.changePresence('Level Selection Menu', null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/level_bg'));
		bg.screenCenter();
		add(bg);

		var initLevels:Array<String> = Paths.getTextArray(Paths.txt('levels/levelList'));

		if (Paths.exists(Paths.txt('levels/levelList')))
		{
			initLevels = Paths.getText(Paths.txt('levels/levelList')).trim().split('\n');

			for (i in 0...initLevels.length)
				initLevels[i] = initLevels[i].trim();
		}

		for (i in 0...initLevels.length)
		{
			var data:Array<String> = initLevels[i].split('|');
			levelList.push({name: data[0], id: data[1]});
		}

		titleText = new FlxText(0, 60, FlxG.width, "");
		titleText.setFormat(Paths.font("main"), 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		titleText.screenCenter(X);
		add(titleText);

		coverGroup = new FlxTypedGroup<FlxSprite>();
		add(coverGroup);

		updateCovers();

		super.create();
	}

	function updateCovers():Void
	{
		coverGroup.clear();

		if (levelList.length == 0)
			return;

		for (i in -1...2)
		{
			var idx = selectedIndex + i;
			if (idx < 0 || idx >= levelList.length)
				continue;

			var level = levelList[idx];
			var sprite = new FlxSprite();

			var imagePath:String = 'menu/level/' + formatLevelPath(level.name);
			if (Paths.exists(Paths.image(imagePath)))
				sprite.loadGraphic(Paths.image(imagePath));
			else
			{
				trace('Missing level image: ' + imagePath);
				sprite.loadGraphic(Paths.image('menu/level/placeholder'));
			}

			if (i == 0)
				sprite.scale.set(4, 4);
			else
				sprite.scale.set(3, 3);

			sprite.updateHitbox();

			if (i == 0)
				sprite.screenCenter();
			else if (i == -1)
			{
				sprite.x = FlxG.width / 2 - sprite.width - 190;
				sprite.screenCenter(Y);
			}
			else if (i == 1)
			{
				sprite.x = FlxG.width / 2 + 190;
				sprite.screenCenter(Y);
			}

			coverGroup.add(sprite);
		}

		titleText.text = levelList[selectedIndex].name;
	}

	override public function update(elapsed:Float):Void
	{
		if (Input.justPressed('left'))
		{
			FlxG.sound.play(Paths.sound('scroll'));
			selectedIndex = (selectedIndex - 1 + levelList.length) % levelList.length;
			updateCovers();
		}
		else if (Input.justPressed('right'))
		{
			FlxG.sound.play(Paths.sound('scroll'));
			selectedIndex = (selectedIndex + 1) % levelList.length;
			updateCovers();
		}

		if (Input.justPressed('confirm'))
		{
			FlxG.sound.play(Paths.sound('select'));
			transitionState(LevelRegistry.fetchLevel(Std.parseInt(levelList[selectedIndex].id)));
		}
		else if (Input.justPressed('cancel'))
		{
			FlxG.sound.play(Paths.sound('cancel'));
			transitionState(new MainMenu());
		}

		super.update(elapsed);
	}

	/**
	 * Formats the level path to a consistent format.
	 * @param path The path to format.
	 * @return The formatted path.
	 */
	private function formatLevelPath(path:String):String
		return path.toLowerCase().replace(' ', '-');
}
