package jta.registries.level;

import jta.objects.level.Object;
import jta.objects.level.ScriptedObject;

class ObjectRegistry
{
	private static final objectScriptedClasses:Map<String, String> = [];

	public static function loadObjects():Void
	{
		clearObjects();

		final scriptedObjects:Array<String> = ScriptedObject.listScriptClasses();

		if (scriptedObjects.length > 0)
		{
			FlxG.log.notice('Initiating ${scriptedObjects.length} scripted objects...');

			for (scriptedObject in scriptedObjects)
			{
				final object:Object = ScriptedObject.init(scriptedObject, 'unknown');

				if (object == null)
					continue;

				FlxG.log.notice('Initialized object "${object.objectID}"!');

				objectScriptedClasses.set(object.objectID, scriptedObject);
			}
		}

		FlxG.log.notice('Successfully loaded ${Lambda.count(objectScriptedClasses)} object(s)!');
	}

	public static function fetchObject(objectID:String):Null<Object>
	{
		if (!objectScriptedClasses.exists(objectID))
		{
			FlxG.log.error('Unable to load "${objectID}", not found in cache');

			return null;
		}

		final objectScriptedClass:Null<String> = objectScriptedClasses.get(objectID);

		if (objectScriptedClass != null)
		{
			final object:Object = ScriptedObject.init(objectScriptedClass, objectID);

			if (object == null)
			{
				FlxG.log.error('Unable to initiate "${objectID}"');

				return null;
			}

			return object;
		}

		return null;
	}

	public static function clearObjects():Void
	{
		if (objectScriptedClasses != null)
			objectScriptedClasses.clear();
	}
}
