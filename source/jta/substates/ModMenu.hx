package jta.substates;

import flixel.FlxObject;
import jta.input.Input;
import jta.modding.PolymodHandler;
import jta.substates.BaseSubState;

class ModMenu extends BaseSubState
{
    var mods:FlxTypedGroup<FlxText>;
    // var icons:FlxTypedGroup<ModIcon>;
    var desc:FlxText;
    var selectedIndex:Int = 0;
    var came:FlxObject;

    public function new():Void
    {
        super(0x80000000);
    }

    override public function create():Void
    {
        cameras = [FlxG.cameras.list[1]];

        came = new FlxObject(80, 0, 0, 0);
        came.screenCenter(X);
        add(came);

        if (PolymodHandler.trackedMods.length > 0){

        mods = new FlxTypedGroup<FlxText>();
        add(mods);

        for (i in 0...PolymodHandler.trackedMods.length)
        {
            var text:FlxText = new FlxText(10, 100 + i * 42, FlxG.width, PolymodHandler.trackedMods[i].title);
            text.setFormat(Paths.font('main'), 36, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            text.scrollFactor.set();
            text.ID = i;
            add(text);
        }
        } else {
            var title:FlxText = new FlxText(10, 10, FlxG.width, "NO MODS INSTALLED!");
		title.setFormat(Paths.font('main'), 40, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		title.scrollFactor.set();
		add(title);
        }

        super.create();
    }

    override public function update(elapsed:Float):Void
    {
        if (Input.justPressed('confirm'))
		{
					FlxG.sound.play(Paths.sound('select'));
					close();
		}

        super.update(elapsed);
    }
}

/*class ModIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;

	public function new(bytes:haxe.io.Bytes):Void
	{
		super();

		if (bytes != null && bytes.length > 0)
		{
			try
			{
				var bmp:BitmapData = BitmapData.fromBytes(bytes);
				var sheetWidth = bmp.width;
				var sheetHeight = bmp.height;
				var frameWidth = 150;
				var frameHeight = 150;
				var framesWide = Math.floor(sheetWidth / frameWidth);
				var framesHigh = Math.floor(sheetHeight / frameHeight);
				var totalFrames = framesWide * framesHigh;

				loadGraphic(bmp, true, frameWidth, frameHeight);

				var frameIndices = [for (i in 0...totalFrames) i];
				animation.add('icon', frameIndices, 24, true);
				animation.play('icon');
			}
			catch (e:Dynamic)
			{
				FlxG.log.warn(e);
				loadGraphic(Paths.image('errorSparrow'));
			}
		}
		else
			loadGraphic(Paths.image('errorSparrow'));

		setGraphicSize(75, 75);
		scrollFactor.set();
		updateHitbox();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (sprTracker != null)
		{
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y);
			scrollFactor.set(sprTracker.scrollFactor.x, sprTracker.scrollFactor.y);
		}
	}
}*/