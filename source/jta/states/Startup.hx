package jta.states;

import jta.Data;
import jta.Global;
import jta.modding.PolymodHandler;
import jta.registries.LevelRegistry;

class Startup extends FlxState
{
	override public function create():Void
	{
		super.create();

		Data.init();
		Global.load();
		PolymodHandler.init(OPENFL);

		FlxG.switchState(() -> LevelRegistry.fetchLevel(272));
	}
}
