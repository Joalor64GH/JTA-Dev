package jta.substates;

import jta.Paths;
import jta.input.Input;
import jta.states.MainMenu;
import jta.states.BaseState;
import jta.substates.BaseSubState;

class PauseMenu extends BaseSubState
{
	var selections:Array<String> = ["Resume", "Restart", "Return to Menu"];
	var selectedIndex:Int = 0;

	var selectionGroup:FlxTypedGroup<FlxText>;

	override public function create():Void
	{
		cameras = [FlxG.cameras.list[1]];

		var bg:FlxSprite = new FlxSprite().makeGraphic(900, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		bg.alpha = 0.5;
		add(bg);

		var title:FlxText = new FlxText(10, 10, FlxG.width, "PAUSED?");
		title.setFormat(Paths.font('main'), 40, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		title.scrollFactor.set();
		add(title);

		selectionGroup = new FlxTypedGroup<FlxText>();
		add(selectionGroup);

		for (i in 0...selections.length)
		{
			var selection:FlxText = new FlxText(10, 100 + i * 42, FlxG.width, selections[i]);
			selection.setFormat(Paths.font('main'), 36, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			selection.scrollFactor.set();
			selection.ID = i;
			selectionGroup.add(selection);
		}

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
					close();
				case 1:
					FlxG.sound.play(Paths.sound('select'));
					BaseState.resetState();
				case 2:
					FlxG.sound.play(Paths.sound('cancel'));
					transitionState(new MainMenu());
			}
		}

		selectionGroup.forEach(function(text:FlxText)
		{
			text.color = (text.ID == selectedIndex) ? FlxColor.YELLOW : FlxColor.WHITE;
		});

		super.update(elapsed);
	}

	private function changeSelection(num:Int):Void
	{
		FlxG.sound.play(Paths.sound('scroll'));
		selectedIndex = FlxMath.wrap(selectedIndex + num, 0, selections.length - 1);
	}
}
