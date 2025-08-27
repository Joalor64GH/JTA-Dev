package jta.mobile;

import jta.input.Input;
import jta.mobile.VirtualButton;

class MobilePad extends FlxGroup
{
    public var left:VirtualButton;
    public var down:VirtualButton;
    public var up:VirtualButton;
    public var right:VirtualButton;

    public var a:VirtualButton;
    public var b:VirtualButton;

    public var back:VirtualButton;
    public var pause:VirtualButton;
    public var skip:VirtualButton;

    public function new():Void
    {
        super();

        left = new VirtualButton(50, FlxG.height - 200, "left");
    down = new VirtualButton(130, FlxG.height - 130, "down");
    up = new VirtualButton(130, FlxG.height - 270, "up");
    right = new VirtualButton(210, FlxG.height - 200, "right");

    add(left);
    add(down);
    add(up);
    add(right);
    }

    public function updateInput():Void
    {
        if (left.isPressed()) Input.pressed('left') = true;
    if (right.isPressed()) Input.pressed('right') = true;
    if (up.isPressed()) Input.pressed('up') = true;
    if (down.isPressed()) Input.pressed('down') = true;
    }
}