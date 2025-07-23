package jta.objects.dialogue.portraits;

/**
 * Represents an portrait within a dialogue.
 */
class Portrait extends FlxSprite
{
	/**
	 * The ID of the portrait.
	 */
	public var portraitID:String;

	/**
	 * Initializes the portait with a specific ID.
	 * @param portraitID The ID of the portrait.
	 */
	public function new(portraitID:String):Void
	{
		super();

		this.portraitID = portraitID;
	}

	/**
	 * Changes the face of the portrait.
	 * @param name The name of the face.
	 */
	public function changeFace(name:String):Void {}
}
