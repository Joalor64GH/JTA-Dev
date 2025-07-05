package jta.states.level;

import flixel.tile.FlxTilemap;
import jta.registries.level.PlayerRegistry;
import jta.registries.level.ObjectRegistry;
import jta.objects.level.Player;
import jta.objects.level.Object;
import jta.objects.HUD;
import jta.input.Input;
import jta.Paths;

class Level extends FlxState
{
	public var levelNumber:Int;
	public var levelName:String;

	private var player:Player;

	private var map:FlxTilemap;
	private var background:FlxTilemap;
	private var objects:FlxTypedGroup<Object>;

	private var camHUD:FlxCamera;
	private var hud:HUD;

	private var camFollowControllable:Bool = false;

	public function new(levelNumber:Int):Void
	{
		super();
		this.levelNumber = levelNumber;
	}

	override public function create():Void
	{
		camHUD = new FlxCamera();
		camHUD.bgColor = 0;
		FlxG.cameras.add(camHUD, false);

		if (background != null)
			add(background);

		if (map != null)
			add(map);

		if (objects != null)
			add(objects);

		if (player != null)
			add(player);

		hud = new HUD();
		hud.cameras = [camHUD];
		add(hud);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (player != null)
		{
			if (map != null)
				FlxG.collide(map, player);

			if (camFollowControllable && player.y >= 0 && player.y <= FlxG.height)
				FlxG.camera.follow(player, LOCKON, 0.9);

			if (objects != null)
			{
				FlxG.collide(objects, player);
				objects.forEach(function(obj:Object):Void
				{
					if (obj != null && player.characterControllable && player.overlaps(obj))
					{
						if (Input.pressed('confirm'))
							obj.interact();
					}
					else
						obj.overlap();
				});
			}
		}
	}

	public function loadPlayer(id:String, x:Float, y:Float):Player
	{
		player = PlayerRegistry.fetchPlayer(id);
		player.setPosition(x, y);
		add(player);
		return player;
	}

	public function createObject(id:String, x:Float, y:Float):Object
	{
		if (objects == null)
			objects = new FlxTypedGroup<Object>();

		final object:Object = ObjectRegistry.fetchObject(id);
		object.setPosition(x, y);
		return objects.add(object);
	}

	public function loadMap(path:String, image:String, ?w:Int = 16, ?h:Int = 16):FlxTilemap
	{
		map = new FlxTilemap();
		map.loadMapFromCSV(Paths.csv('levels/' + path + '-map'), Paths.image('tiles/' + image), w, h);
		map.screenCenter();
		add(map);
		return map;
	}

	public function loadMapBackground(path:String, image:String, ?w:Int = 16, ?h:Int = 16):FlxTilemap
	{
		background = new FlxTilemap();
		background.loadMapFromCSV(Paths.csv('levels/' + path + '-background'), Paths.image('tiles/' + image + '_bg'), w, h);
		background.screenCenter();
		add(background);
		return background;
	}
}
