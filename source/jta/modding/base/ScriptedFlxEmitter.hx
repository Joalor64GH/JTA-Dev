package jta.modding.base;

import polymod.hscript.HScriptedClass;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

/**
 * A script that can be tied to `FlxTypedEmitter`.
 */
@:hscriptClass
class ScriptedFlxEmitter extends FlxTypedEmitter<FlxParticle> implements HScriptedClass {}
