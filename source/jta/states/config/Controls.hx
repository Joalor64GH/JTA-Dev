package jta.states.config;

import jta.Data;
import jta.Paths;
import jta.input.Input;
import jta.states.BaseState;
import jta.states.config.Settings;
import jta.substates.BaseSubState;
import flixel.addons.display.shapes.FlxShapeBox;

class DeviceSelect extends BaseSubState
{
	var selections:Array<String> = ["Keyboard", "Back"];
	var selectedIndex:Int = 0;

	var selectionGroup:FlxTypedGroup<FlxText>;

	var ignoreInputTimer:Float = 0;

	public function new():Void
	{
		super();

		ignoreInputTimer = 0.5;

		var gamepad = FlxG.gamepads.lastActive;
		if (gamepad != null)
			selections.insert(1, "Gamepad");
	}

	override public function create():Void
	{
		#if hxdiscord_rpc
		jta.api.DiscordClient.changePresence('Configuring Controls', null);
		#end

		var bg:FlxSprite = new FlxSprite().makeGraphic(900, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.5;
		add(bg);

		var title:FlxText = new FlxText(10, 10, FlxG.width, "CHOOSE DEVICE");
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
		if (ignoreInputTimer > 0)
		{
			ignoreInputTimer -= elapsed;
			return;
		}

		if (Input.justPressed('up'))
			selectedIndex = FlxMath.wrap(selectedIndex - 1, 0, selections.length - 1);
		else if (Input.justPressed('down'))
			selectedIndex = FlxMath.wrap(selectedIndex + 1, 0, selections.length - 1);

		if (Input.justPressed('confirm'))
		{
			switch (selections[selectedIndex])
			{
				case "Keyboard":
					transitionState(new Controls(false));
				case "Gamepad":
					transitionState(new Controls(true));
				case "Back":
					close();
			}
		}
		else if (Input.justPressed('cancel'))
			close();

		selectionGroup.forEach(function(text:FlxText)
		{
			text.color = (text.ID == selectedIndex) ? FlxColor.YELLOW : FlxColor.WHITE;
		});

		super.update(elapsed);
	}
}

class Controls extends BaseState
{
	var controls:Array<String> = ["left", "down", "up", "right", "jump", "run", "confirm", "cancel"];
	var selectionGroup:FlxTypedGroup<FlxText>;
	var selectedIndex:Int = 0;

	var isGamepad:Bool = false;
	var isChangingBind:Bool = false;

	var tempBG:FlxSprite;
	var anyKeyTxt:FlxText;

	public function new(?isGamepad:Bool = false):Void
	{
		super();

		this.isGamepad = isGamepad;
	}

	override public function create():Void
	{
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/settings_bg'));
		bg.screenCenter();
		add(bg);

		var titleText = isGamepad ? "GAMEPAD BINDS" : "KEYBOARD BINDS";
		var title:FlxText = new FlxText(10, 10, FlxG.width, titleText);
		title.setFormat(Paths.font('main'), 40, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(title);

		selectionGroup = new FlxTypedGroup<FlxText>();
		add(selectionGroup);

		for (i in 0...controls.length)
		{
			var tag = controls[i];
			var selection:FlxText = new FlxText(10, 100 + i * 42, FlxG.width, getBindLabel(tag, i));
			selection.setFormat(Paths.font('main'), 36, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			selection.ID = i;
			selectionGroup.add(selection);
		}

		tempBG = new FlxSprite().makeGraphic(900, FlxG.height, FlxColor.BLACK);
		tempBG.alpha = 0.6;
		tempBG.visible = false;
		add(tempBG);

		anyKeyTxt = new FlxText(0, 0, 0, "PRESS ANY " + (isGamepad ? "BUTTON" : "KEY"), 32);
		anyKeyTxt.setFormat(Paths.font('main'), 36, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		anyKeyTxt.screenCenter();
		anyKeyTxt.visible = false;
		add(anyKeyTxt);

		updateSelection();
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (!isChangingBind)
		{
			if (Input.justPressed('up'))
				selectedIndex = FlxMath.wrap(selectedIndex - 1, 0, controls.length - 1);
			else if (Input.justPressed('down'))
				selectedIndex = FlxMath.wrap(selectedIndex + 1, 0, controls.length - 1);

			if (Input.justPressed('confirm'))
			{
				isChangingBind = true;
				anyKeyTxt.text = "PRESS ANY " + (isGamepad ? "BUTTON" : "KEY");
				anyKeyTxt.visible = true;
				tempBG.visible = true;

				var selectedText:FlxText = cast selectionGroup.members[selectedIndex];
				selectedText.text = controls[selectedIndex].toUpperCase() + ": ...";
			}
			else if (Input.justPressed('cancel'))
				transitionState(new Settings());
		}
		else
		{
			if (Input.justPressed('any'))
			{
				if (isGamepad)
				{
					var pad:FlxGamepad = FlxG.gamepads.lastActive;
					var btn:FlxGamepadInputID = pad.firstJustPressedID();
					if (pad != null && btn.toString() != FlxGamepadInputID.NONE)
						Data.settings.gamepadBinds[selectedIndex] = btn;
				}
				else
					Data.settings.keyboardBinds[selectedIndex] = FlxG.keys.getIsDown()[0].ID.toString();
				Data.saveSettings();
				Input.refreshControls();
				isChangingBind = false;
				tempBG.visible = false;
				anyKeyTxt.visible = false;
				refreshBinds();
			}
		}

		updateSelection();
		super.update(elapsed);
	}

	function getBindLabel(tag:String, index:Int):String
	{
		if (isGamepad)
			return tag.toUpperCase() + ": " + FlxGamepadInputID.toStringMap.get(Data.settings.gamepadBinds[index]);
		else
			return tag.toUpperCase() + ": " + FlxKey.toStringMap.get(Data.settings.keyboardBinds[index]);
	}

	function refreshBinds():Void
	{
		for (i in 0...controls.length)
		{
			var label = getBindLabel(controls[i], i);
			var text:FlxText = cast selectionGroup.members[i];
			text.text = label;
		}
	}

	function updateSelection():Void
	{
		for (i in 0...selectionGroup.length)
		{
			var text:FlxText = cast selectionGroup.members[i];
			text.color = (i == selectedIndex) ? FlxColor.YELLOW : FlxColor.WHITE;
		}
	}
}
