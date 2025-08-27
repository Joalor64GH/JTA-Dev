package jta.mobile;

import jta.Paths;

class VirtualButton extends FlxSprite
{
    public var action:String;

    public function new(x:Float, y:Float, action:String):Void
    {
        super(x, y);

        this.action = action;

        loadGraphic(Paths.image('buttons/$action'));

        scrollFactor.set();
        alpha = 0.7;
    }

    public function isPressed():Bool
    {
        for (touch in FlxG.touches.list)
            if (overlapsPoint(touch.screenX, touch.screenY))
                return true;
        return false;
    }
}