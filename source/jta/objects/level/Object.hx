package jta.objects.level;

class Object extends FlxSprite
{
	public var objectID:String;

	public var objectInteractable:Bool;

	public function new(objectID:String):Void
	{
		super();

		this.objectID = objectID;
	}

	public function interact():Void {}

	public function overlap():Void {}
}
