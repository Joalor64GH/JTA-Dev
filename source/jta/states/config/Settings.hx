package jta.states.config;

import jta.Data;
import jta.input.Input;
import jta.states.MainMenu;
import jta.states.config.Option;

class Settings extends FlxState
{
	var options:Array<Option> = [];
	var selectedIndex:Int = 0;

	var selectionGroup:FlxTypedGroup<FlxText>;

	var holdTimer:FlxTimer;
	var holdDirection:Int = 0;

	public function new():Void
	{
		super();

		var option:Option = new Option('Master Volume', OptionType.Integer(0, 100, 1), FlxG.sound.volume * 100);
		option.showPercentage = true;
		option.onChange = (value:Dynamic) ->
		{
			Data.settings.volume = value;
			FlxG.sound.volume = Data.settings.volume / 100;
		};
		options.push(option);

		var option:Option = new Option('Framerate', OptionType.Integer(60, 240, 10),
			Std.int(FlxMath.bound(FlxG.stage.application.window.displayMode.refreshRate, 60, 240)));
		option.onChange = (value:Dynamic) ->
		{
			Data.settings.framerate = value;
			Main.framerate = Data.settings.framerate;
		};
		options.push(option);

		var option:Option = new Option('FPS Counter', OptionType.Toggle, Data.settings.fpsCounter);
		option.onChange = (value:Dynamic) ->
		{
			Data.settings.fpsCounter = value;
			if (Main.fpsDisplay != null)
				Main.fpsDisplay.visible = Data.settings.fpsCounter;
		};
		options.push(option);

		#if desktop
		var option:Option = new Option('Fullscreen', OptionType.Toggle, Data.settings.fullscreen);
		option.onChange = (value:Dynamic) ->
		{
			Data.settings.fullscreen = value;
			FlxG.fullscreen = Data.settings.fullscreen;
		};
		options.push(option);
		#end

		var option:Option = new Option('Skip Splash', OptionType.Toggle, Data.settings.skipSplash);
		option.onChange = (value:Dynamic) -> Data.settings.skipSplash = value;
		options.push(option);

		var option:Option = new Option('Controls', OptionType.Function, function():Void
		{
			Data.saveSettings();
			FlxG.switchState(() -> new MainMenu());
		});
		options.push(option);

		var option:Option = new Option('Exit', OptionType.Function, function():Void
		{
			Data.saveSettings();
			FlxG.switchState(() -> new MainMenu());
		});
		options.push(option);
	}

	override public function create():Void
	{
		var title:FlxText = new FlxText(10, 10, FlxG.width, "SETTINGS");
		title.setFormat(Paths.font('main'), 40, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(title);

		selectionGroup = new FlxTypedGroup<FlxText>();
		add(selectionGroup);

		for (i in 0...options.length)
		{
			var selection:FlxText = new FlxText(10, 70 + i * 42, FlxG.width, options[i].toString());
			selection.setFormat(Paths.font('main'), 36, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			selection.ID = i;
			selectionGroup.add(selection);
		}

		holdTimer = new FlxTimer();

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (Input.justPressed('up'))
		{
			selectedIndex--;
			if (selectedIndex < 0)
				selectedIndex = options.length - 1;
		}
		else if (Input.justPressed('down'))
		{
			selectedIndex++;
			if (selectedIndex >= options.length)
				selectedIndex = 0;
		}

		if (Input.justPressed('right'))
			startHold(1);
		else if (Input.justPressed('left'))
			startHold(-1);

		if (Input.justReleased('right') || Input.justReleased('left'))
		{
			if (holdTimer.active)
				holdTimer.cancel();
		}

		if (Input.justPressed('confirm'))
		{
			var option:Option = options[selectedIndex];
			if (option != null)
				option.execute();
		}

		selectionGroup.forEach(function(text:FlxText)
		{
			text.color = (text.ID == selectedIndex) ? FlxColor.YELLOW : FlxColor.WHITE;
		});

		super.update(elapsed);
	}

	private function changeValue(direction:Int = 0):Void
	{
		var option:Option = options[selectedIndex];

		if (option != null)
		{
			option.changeValue(direction);

			selectionGroup.forEach(function(txt:FlxText):Void
			{
				if (txt.ID == selectedIndex)
					txt.text = option.toString();
			});
		}
	}

	private function startHold(direction:Int = 0):Void
	{
		holdDirection = direction;

		var option:Option = options[selectedIndex];

		if (option != null)
		{
			if (option.type != OptionType.Function)
				changeValue(holdDirection);

			switch (option.type)
			{
				case OptionType.Integer(_, _, _) | OptionType.Decimal(_, _, _):
					if (!holdTimer.active)
					{
						holdTimer.start(0.5, function(timer:FlxTimer):Void
						{
							timer.start(0.05, function(timer:FlxTimer):Void
							{
								changeValue(holdDirection);
							}, 0);
						});
					}
				default:
			}
		}
	}
}
