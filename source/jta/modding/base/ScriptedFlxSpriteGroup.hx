package jta.modding.base;

import polymod.hscript.HScriptedClass;
import flixel.group.FlxSpriteGroup;

/**
 * A script that can be tied to `FlxSpriteGroup`.
 */
@:hscriptClass
class ScriptedFlxSpriteGroup extends FlxSpriteGroup.FlxTypedSpriteGroup<FlxSprite> implements HScriptedClass {}
