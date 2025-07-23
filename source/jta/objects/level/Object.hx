package jta.objects.level;

/**
 * Represents an object in a level.
 */
class Object extends FlxSprite
{
	/**
	 * The ID of the object.
	 */
	public var objectID:String;

	/**
	 * Whether or not the object can be interacted with.
	 */
	public var objectInteractable:Bool;

	/**
	 * Initializes the object with a specified ID.
	 * @param objectID The ID of the object.
	 */
	public function new(objectID:String):Void
	{
		super();

		this.objectID = objectID;
	}

	/**
	 * Function called when the object is interacted with, if it is interactable.
	 */
	public function interact():Void {}

	/**
	 * Function called when the player overlaps the object.
	 */
	public function overlap():Void {}
}
