package jta.modding.base;

import polymod.hscript.HScriptedClass;
import flixel.FlxBasic;

/**
 * A script that can be tied to `FlxTypedGroup`.
 */
@:hscriptClass
class ScriptedFlxGroup extends FlxTypedGroup<FlxBasic> implements HScriptedClass {}
