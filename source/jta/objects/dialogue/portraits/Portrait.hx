package jta.objects.dialogue.portraits;

class Portrait extends FlxSprite
{
	public var portraitID:String;

	public function new(portraitID:String):Void
	{
		super();

		this.portraitID = portraitID;
	}

	public function changeFace(name:String):Void {}
}
