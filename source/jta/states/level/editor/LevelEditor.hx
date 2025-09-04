package jta.states.level.editor;

import haxe.ui.components.Button;
import haxe.ui.containers.VBox;

@:build(haxe.ui.ComponentBuilder.build("assets/ui/main-view.xml"))
class LevelEditor extends haxe.ui.backend.flixel.UIState
{
    override function create()
    {
        super.create();

        var view:VBox = new VBox();
        view.x = 10;
        view.y = 10;

        var button1:Button = new Button();
        button1.text = "Click Me!";
        button1.onClick = function(e) {
            button1.text = "Thanks!";
        };

        view.addComponent(button1);
        add(view);
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