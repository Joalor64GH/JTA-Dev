package jta.macros;

#if macro
import haxe.macro.Context:
#end
import haxe.rtti.Meta;

class CompiledClassList
{
	@:noCompletion
	private static var classLists:Map<String, List<Class<Dynamic>>> = [];

	@:noCompletion
	private static function init():Void
	{
		if (classLists != null && Lambda.count(classLists) > 0)
			classLists.clear();

		final metaData:Dynamic<Array<Dynamic>> = Meta.getType(CompiledClassList);

		if (metaData.classLists != null)
		{
			for (list in metaData.classLists)
			{
				final data:Array<Dynamic> = cast list;
				final id:String = cast data[0];
				final classes:List<Class<Dynamic>> = new List();

				for (i in 1...data.length)
				{
					final className:String = cast data[i];

					final classType:Class<Dynamic> = cast Type.resolveClass(className);

					classes.push(classType);
				}

				classLists.set(id, classes);
			}
		}
		else
			throw 'Class lists not properly generated. Try cleaning out your export folder, restarting your IDE, and rebuilding your project.';
	}

	public static function get(request:String):Null<List<Class<Dynamic>>>
	{
		if (classLists == null || Lambda.count(classLists) <= 0)
			init();

		if (!classLists.exists(request))
		{
			#if macro
			Context.warning('Class list $request not properly generated. Please debug the build macro.');
			#end

			classLists.set(request, new List());
		}

		return classLists.get(request);
	}

	public static inline function getTyped<T>(request:String, type:Class<T>):List<Class<T>>
	{
		return cast get(request);
	}
}
