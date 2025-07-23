package jta.modding.base;

import polymod.hscript.HScriptedClass;

/**
 * A script that can be tied to `FlxSpriteGroup`.
 */
@:hscriptClass
class ScriptedFlxSpriteGroup extends FlxSpriteGroup.FlxTypedSpriteGroup<FlxSprite> implements HScriptedClass {}
