package jta.substates;

import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.typeLimit.NextState;
import jta.registries.ModuleRegistry;
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

		for (module in ModuleRegistry.getAllModules(true))
		{
			module.create();
			add(module);
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		FlxG.stage.frameRate = Data.settings.framerate;

		for (module in ModuleRegistry.getAllModules())
			module.update(elapsed);
	}

	override public function destroy():Void
	{
		for (module in ModuleRegistry.getAllModules())
			module.destroy();
		super.destroy();
	}

	public function transitionState(state:NextState, ?noTransition:Bool = false):Void
	{
		FlxTransitionableState.skipNextTransIn = noTransition;
		FlxTransitionableState.skipNextTransOut = noTransition;

		FlxG.switchState(state);
	}
}
