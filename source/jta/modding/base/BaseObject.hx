package jta.modding.base;

/**
 * An empty base class meant to be extended by scripts.
 * @see https://github.com/FunkinCrew/Funkin/blob/main/source/funkin/modding/base/Object.hx
 */
@:nullSafety
class BaseObject
{
	public function new():Void {}

	public function toString():String
	{
		return '(BaseObject)';
	}
}
