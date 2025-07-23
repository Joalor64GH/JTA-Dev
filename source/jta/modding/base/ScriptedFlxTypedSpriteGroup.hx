package jta.modding.base;

import polymod.hscript.HScriptedClass;

/**
 * A script that can be tied to `FlxTypedSpriteGroup`.
 */
@:hscriptClass
class ScriptedFlxTypedSpriteGroup extends FlxSpriteGroup.FlxTypedSpriteGroup<Dynamic> implements HScriptedClass {}
