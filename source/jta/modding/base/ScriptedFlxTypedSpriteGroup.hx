package jta.modding.base;

import polymod.hscript.HScriptedClass;
import flixel.group.FlxSpriteGroup;

/**
 * A script that can be tied to `FlxTypedSpriteGroup`.
 */
@:hscriptClass
class ScriptedFlxTypedSpriteGroup extends FlxSpriteGroup.FlxTypedSpriteGroup<Dynamic> implements HScriptedClass {}
