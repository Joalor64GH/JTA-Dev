package jta.states;

import jta.input.Input;
import jta.states.config.Settings;
import jta.registries.LevelRegistry;

class MainMenu extends FlxState
{
	var selections:Array<String> = ["Start Game", "Options"];
	var selectedIndex:Int = 0;

	var selectionGroup:FlxTypedGroup<FlxText>;

	public function new():Void
	{
		super();

		#if desktop
		selections.push("Exit");
		#end
	}

	override public function create():Void
	{
		var title:FlxText = new FlxText(10, 10, FlxG.width, "Journey Through Aubekhia");
		title.setFormat(Paths.font('main'), 40, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(title);

		selectionGroup = new FlxTypedGroup<FlxText>();
		add(selectionGroup);

		for (i in 0...selections.length)
		{
			var selection:FlxText = new FlxText(10, 100 + i * 42, FlxG.width, selections[i]);
			selection.setFormat(Paths.font('main'), 36, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			selection.ID = i;
			selectionGroup.add(selection);
		}

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (Input.justPressed('up'))
		{
			selectedIndex--;
			if (selectedIndex < 0)
				selectedIndex = selections.length - 1;
		}
		else if (Input.justPressed('down'))
		{
			selectedIndex++;
			if (selectedIndex >= selections.length)
				selectedIndex = 0;
		}

		if (Input.justPressed('confirm'))
		{
			switch (selectedIndex)
			{
				case 0:
					FlxG.switchState(() -> LevelRegistry.fetchLevel(272));
				case 1:
					FlxG.switchState(() -> new Settings());
				#if desktop
				case 2:
					Sys.exit(0);
				#end
			}
		}

		selectionGroup.forEach(function(text:FlxText)
		{
			text.color = (text.ID == selectedIndex) ? FlxColor.YELLOW : FlxColor.WHITE;
		});

		super.update(elapsed);
	}
}
