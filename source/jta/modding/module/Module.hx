package jta.modding.module;

import jta.registries.ModuleRegistry;

/**
 * Base class for all modules in the game.
 * @author Joalor64
 */
class Module extends FlxBasic
{
	/**
	 * The ID of the module.
	 */
	public var moduleID:String;

	/**
	 * The priority of the module.
	 */
	public var priority:Int;

	/**
	 * Initializes the module with an ID and priority.
	 * @param moduleID The ID of the module.
	 * @param priority The priority of the module.
	 */
	public function new(moduleID:String, priority:Int = 0)
	{
		super();

		this.moduleID = moduleID;
		this.priority = priority;
	}

	override public function toString():String
	{
		return 'Module (${this.moduleID})';
	}

	/**
	 * Called when the module is added to a state.
	 */
	public function create():Void {}

	/**
	 * Called every frame.
	 * @param elapsed The time elapsed since the last update.
	 */
	override public function update(elapsed:Float):Void {}

	/**
	 * Called when the state is destroyed or the module is unloaded.
	 */
	override public function destroy():Void {}

	/**
	 * Get another module by ID from within a module.
	 * @param id The ID of the module to fetch.
	 * @return The module with the specified ID.
	 */
	public static function getModule(id:String):Null<Module>
	{
		return ModuleRegistry.fetchModule(id);
	}
}
