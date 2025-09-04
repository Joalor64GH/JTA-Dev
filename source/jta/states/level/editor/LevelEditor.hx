package jta.states.level.editor;

@:build(haxe.ui.ComponentBuilder.build("assets/ui/main-view.xml"))
class LevelEditor extends haxe.ui.backend.flixel.UIState
{
    override function create()
    {
        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE)
        {
            FlxG.switchState(new jta.states.MainMenu());
        }
    }
}