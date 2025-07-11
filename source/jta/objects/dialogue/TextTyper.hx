package jta.objects.dialogue;

import jta.objects.dialogue.typers.Typer;
import jta.objects.dialogue.TextParser;
import flixel.sound.FlxSound;
import flixel.util.FlxSignal;

class TextTyper extends FlxText
{
	private static final IGNORE_CHARACTERS:Array<String> = [' ', '\n', '*', '^', '/', '\\'];

	public var onFunctionCall:FlxTypedSignal<String->Void> = new FlxTypedSignal<String->Void>();
	public var onFaceChange:FlxTypedSignal<String->Void> = new FlxTypedSignal<String->Void>();

	private var originalText:String = '';

	private var actions:Array<Action> = [];

	private var textPos:Int = 0;
	private var typer:Typer;
	private var delay:Float = 0;
	private var counter:Float = 0;

	private var typing:Bool = false;
	private var waiting:Bool = false;
	private var finished:Bool = false;
	private var sounds:Array<FlxSound> = [];

	public function new(x:Float, y:Float):Void
	{
		super(x, y, 0, '', 8, true);
		color = FlxColor.BLACK;
	}

	public override function update(elapsed:Float):Void
	{
		if (typing && !finished)
		{
			counter += elapsed;

			while (counter >= delay)
			{
				counter -= delay;
				processText();
			}
		}

		super.update(elapsed);
	}

	public override function destroy():Void
	{
		super.destroy();

		counter = 0;
		typing = false;
		finished = true;
		waiting = false;
		typer = FlxDestroyUtil.destroy(typer);
	}

	public function start(typer:Typer, text:String):Void
	{
		setupTyper(typer);

		counter = 0;
		waiting = finished = false;
		textPos = 0;

		final parsedText:ParsedText = TextParser.parse(text);

		originalText = parsedText.cleanedText;
		actions = parsedText.actions;

		processText();

		typing = true;
	}

	public function skip():Void
	{
		if (typing && !waiting && !finished)
		{
			textPos = originalText.length;
			processText();
		}
	}

	private inline function setupTyper(typer:Typer):Void
	{
		if (this.typer != null && this.typer != typer)
			this.typer.destroy();

		if (font != typer.fontName)
			font = typer.fontName;

		if (size != typer.fontSize)
			size = typer.fontSize;

		if (typer.fontSpacing != null && letterSpacing != typer.fontSpacing)
			letterSpacing = typer.fontSpacing;

		if (offset != typer.typerOffset)
			offset.copyFrom(typer.typerOffset);

		for (typingSound in typer.typerSounds)
		{
			if (typingSound == null)
				continue;

			final sound:FlxSound = FlxG.sound.load(typingSound.sound, typingSound.volume);

			if (typingSound.pitch != null)
				sound.pitch = typingSound.pitch;

			sounds.push(sound);
		}

		delay = (1.0 / Main.framerate) * typer.typerFPS;

		this.typer = typer;
	}

	private function processText():Void
	{
		processActions();

		if (updateTextPos())
			updateText();
	}

	private function updateTextPos():Bool
	{
		if (waiting)
			return false;

		final currentChar:String = originalText.charAt(textPos);

		playSounds(currentChar);

		textPos++;

		if (IGNORE_CHARACTERS.contains(currentChar))
			return updateTextPos();

		if (textPos > originalText.length)
			textPos = originalText.length;

		return true;
	}

	private function updateText():Void
	{
		final curText:String = originalText.substr(0, textPos);

		if (text != curText)
		{
			text = curText;

			if (textPos >= originalText.length)
			{
				counter = 0;
				typing = false;
				finished = true;
				waiting = false;
			}
		}
	}

	private function processActions():Void
	{
		if (actions != null && actions.length > 0)
		{
			while (actions.length > 0 && actions[0].index == textPos)
			{
				final action:Action = actions.shift();

				FlxG.log.notice('Currently trying to dispatch ${action.type} event.');

				switch (action.type)
				{
					case 'speed':
						final speed:Null<Float> = Std.parseFloat(action.value);

						if (speed != null && speed > 0)
							delay = (1.0 / Main.framerate) * speed;
					case 'wait':
						final waitTime:Null<Float> = Std.parseFloat(action.value);

						if (waitTime != null && waitTime > 0)
						{
							waiting = true;
							FlxTimer.wait(waitTime, () -> waiting = false);
							break;
						}
					case 'w':
						final waitTime:Null<Int> = Std.parseInt(action.value);

						if (waitTime != null && waitTime > 0)
						{
							waiting = true;
							FlxTimer.wait((1.0 / Main.framerate) * waitTime, () -> waiting = false);
							break;
						}
					case 'function':
						if (onFunctionCall != null)
							onFunctionCall.dispatch(action.value);
					case 'face':
						if (onFaceChange != null)
							onFaceChange.dispatch(action.value);
				}
			}
		}
	}

	private function playSounds(currentChar:String):Void
	{
		if (sounds?.length > 0 && !IGNORE_CHARACTERS.contains(currentChar))
		{
			for (sound in sounds)
				sound.stop();

			sounds[FlxG.random.int(0, sounds.length - 1)].play();
		}
	}
}
