package jta.states.level.editor;

import jta.Paths;
import jta.input.Input;
import jta.states.MainMenu;
import jta.objects.level.Player;
import jta.objects.level.Object;
import jta.registries.level.PlayerRegistry;
import jta.registries.level.ObjectRegistry;
import jta.registries.LevelRegistry;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.net.FileReference;
import openfl.net.FileFilter;
import flixel.tile.FlxTilemap;
import flixel.FlxCamera;

/**
 * A state dedicated to allowing the user to create and edit levels.
 * Built with HaxeUI for use by both developers and modders.
 * @author Joalor64
 */
// TO-DO: Add more functionality (loading and opening CSV/level script files, placing objects/tiles and player)
// MAYBE a script editor too??? Hot-reloading???? 
@:build(haxe.ui.ComponentBuilder.build("assets/ui/main-view.xml"))
class LevelEditor extends haxe.ui.backend.flixel.UIState
{
    var player:Player;
    var objects:FlxTypedGroup<Object>;

    var camHUD:FlxCamera;
    var camEditor:FlxCamera;

    override function create():Void
    {
        FlxG.mouse.visible = true;

        super.create();

        var gridLine:FlxSprite = new FlxSprite();
		var gfx = gridLine.makeGraphic(FlxG.width, FlxG.height, 0x00000000, true);
		for (x in 0...Std.int(FlxG.width / 32) + 1)
		{
			gfx.pixels.fillRect(new openfl.geom.Rectangle(x * 32, 0, 1, FlxG.height), 0x55FFFFFF);
		}
		for (y in 0...Std.int(FlxG.height / 32) + 1)
		{
			gfx.pixels.fillRect(new openfl.geom.Rectangle(0, y * 32, FlxG.width, 1), 0x55FFFFFF);
		}
		gridLine.pixels = gfx.pixels;
		gridLine.dirty = true;
		add(gridLine);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (Input.justPressed('cancel'))
        {
            FlxG.mouse.visible = false;
            FlxG.switchState(new MainMenu());
        }
    }
}