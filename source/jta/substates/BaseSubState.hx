package jta.substates;

import jta.Data;

/**
 * Base class used for all substates in the game.
 * @author Joalor64
 */
class BaseSubState extends FlxSubState
{
	override public function create():Void
	{
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		FlxG.stage.frameRate = Data.settings.framerate;
	}

	public function transitionState(state:FlxState, ?noTransition:Bool = false):Void
	{
		FlxTransitionableState.skipNextTransIn = noTransition;
		FlxTransitionableState.skipNextTransOut = noTransition;

		FlxG.switchState(state);
	}
}
