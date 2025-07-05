package jta.objects.level;

import jta.objects.Vector;

class Player extends FlxSprite
{
	public var direction:Vector = new Vector(0, 0);
	public var speed:Vector = new Vector(0, 0);

	public var characterID:String;
	public var characterControllable:Bool = true;

	public function new(characterID:String):Void
	{
		super();

		this.characterID = characterID;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		this.x += direction.dx * speed.dx;
		this.y += direction.dy * speed.dy;
	}
}
