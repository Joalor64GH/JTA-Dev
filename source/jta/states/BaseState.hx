package jta.states;

import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.util.typeLimit.NextState;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import jta.registries.ModuleRegistry;
import jta.states.Startup;
import jta.input.Input;
import jta.Data;

/**
 * Base class used for all states in the game.
 * @author Joalor64
 */
class BaseState extends FlxTransitionableState
{
	/**
	 * @param noTransition Whether or not to skip the transition when entering a state.
	 */
	override public function new(?noTransition:Bool = false):Void
	{
		super();

		if (!Startup.transitionsAllowed)
		{
			noTransition = true;
			Startup.transitionsAllowed = true;
		}

		var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
		diamond.persist = true;
		diamond.destroyOnNoUse = false;
		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
			new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1), {asset: diamond, width: 32, height: 32},
			new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		FlxTransitionableState.skipNextTransIn = noTransition;
		FlxTransitionableState.skipNextTransOut = noTransition;
	}

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
		#if desktop
		if (FlxG.save.data != null)
			FlxG.fullscreen = Data.settings.fullscreen;
		#end

		if (Input.justPressed('four'))
			openSubState(new jta.substates.ModMenu());

		super.update(elapsed);

		if (FlxG.stage != null)
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
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		FlxTransitionableState.skipNextTransIn = noTransition;
		FlxTransitionableState.skipNextTransOut = noTransition;

		FlxG.switchState(state);
	}
}
