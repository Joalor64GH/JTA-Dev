package jta.objects.dialogue;

import flixel.util.FlxSignal;
import jta.registries.dialogue.TyperRegistry;
import jta.objects.dialogue.typers.Typer;
import jta.objects.dialogue.TextTyper;
import jta.input.Input;
import jta.Paths;
import jta.Data;

using flixel.util.FlxArrayUtil;

typedef WriterData =
{
	typer:String,
	?portrait:String,
	text:String
}

class Writer extends TextTyper
{
	public var skippable:Bool = true;
	public var finishCallback:Void->Void = null;
	public var onPortraitChange:FlxTypedSignal<String->Void> = new FlxTypedSignal<String->Void>();

	private var done:Bool = false;
	private var list:Array<WriterData> = [];
	private var page:Int = 0;

	public function startDialogue(list:Array<WriterData>):Void
	{
		this.list = list ?? [{typer: 'default', text: 'Error!'}];

		page = 0;

		if (list[page] != null)
			changeDialogue(list[page]);
	}

	public function changeDialogue(dialogue:WriterData):Void
	{
		if (dialogue == null)
			dialogue = {typer: 'default', text: 'Error!'};

		onPortraitChange.dispatch(dialogue.portrait ?? '');

		done = false;

		start(TyperRegistry.fetchTyper(dialogue.typer ?? 'default'), dialogue.text);
	}

	public override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (Input.justPressed('confirm') && finished && !done)
		{
			if (page < list.indexOf(list.last()))
			{
				page++;
				changeDialogue(list[page]);
			}
			else if (page == list.indexOf(list.last()))
			{
				if (finishCallback != null)
					finishCallback();

				done = true;
			}
		}
		else if (Input.justPressed('cancel') && !finished && skippable)
			skip();
	}
}
