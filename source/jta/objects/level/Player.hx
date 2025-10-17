package jta.objects.level;

import flixel.FlxObject;
import jta.objects.Vector;

/**
 * Represents a player in the game.
 */
class Player extends FlxSprite
{
	/**
	 * The direction the player is facing, represented as a `Vector`.
	 */
	public var direction:Vector = new Vector(0, 0);

	/**
	 * The speed of the player, represented as a `Vector`.
	 */
	public var speed:Vector = new Vector(0, 0);

	/**
	 * The ID of the player character.
	 */
	public var characterID:String;

	/**
	 * The hitbox associated with the player character.
	 */
	public var characterHitbox:FlxObject;

	/**
	 * Whether or not the player character is controllable.
	 */
	public var characterControllable:Bool = true;

	/**
	 * Initializes the object with a specified ID.
	 * @param characterID The ID of the player character.
	 */
	public function new(characterID:String):Void
	{
		super();

		this.characterID = characterID;
	}

	/**
	 * Initializes the hitbox for the character and aligns it with the character sprite.
	 * @param width The width of the hitbox.
	 * @param height The height of the hitbox.
	 */
	public function initializeHitbox(width:Float, height:Float):Void
	{
		characterHitbox = new FlxObject(x + (this.width - width) / 2, y + this.height - height, width, height);
	}

	public override function setPosition(x:Float = 0.0, y:Float = 0.0):Void
	{
		super.setPosition(x, y);

		if (characterHitbox != null)
			characterHitbox.setPosition(x + (this.width - characterHitbox.width) / 2, y + this.height - characterHitbox.height);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		this.x += direction.dx * speed.dx;
		this.y += direction.dy * speed.dy;

		if (characterHitbox != null)
		{
			x = characterHitbox.x - (this.width - characterHitbox.width) / 2;
			y = characterHitbox.y + characterHitbox.height - this.height;

			characterHitbox.update(elapsed);
		}
	}

	public override function draw():Void
	{
		super.draw();

		if (characterHitbox != null)
		{
			characterHitbox.draw();

			#if FLX_DEBUG
			if (Controls.pressed('confirm'))
				characterHitbox.drawDebug();
			#end
		}
	}

	public override function destroy():Void
	{
		super.destroy();

		if (characterHitbox != null)
			characterHitbox.destroy();
	}
}
