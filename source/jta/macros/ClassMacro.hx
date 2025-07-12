package jta.macros;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import jta.macros.MacroUtil;

class ClassMacro
{
	public static macro function listClassesInPackage(targetPackage:String, includeSubPackages:Bool = true):ExprOf<Iterable<Class<Dynamic>>>
	{
		if (!onGenerateCallbackRegistered)
		{
			onGenerateCallbackRegistered = true;

			Context.onGenerate(onGenerate);
		}

		final request:String = 'package~$targetPackage~${includeSubPackages ? 'recursive' : 'nonrecursive'}';

		classListsToGenerate.push(request);

		return macro jta.macros.CompiledClassList.get($v{request});
	}

	public static macro function listSubclassesOf<T>(targetClassExpr:ExprOf<Class<T>>):ExprOf<List<Class<T>>>
	{
		if (!onGenerateCallbackRegistered)
		{
			onGenerateCallbackRegistered = true;

			Context.onGenerate(onGenerate);
		}

		final targetClass:ClassType = MacroUtil.getClassTypeFromExpr(targetClassExpr);

		var targetClassPath:String = null;

		if (targetClass != null)
			targetClassPath = targetClass.pack.join('.') + '.' + targetClass.name;

		final request:String = 'extend~$targetClassPath';

		classListsToGenerate.push(request);

		return macro jta.macros.CompiledClassList.getTyped($v{request}, ${targetClassExpr});
	}

	#if macro
	private static function onGenerate(allTypes:Array<haxe.macro.Type>):Void
	{
		classListsRaw = [];

		for (request in classListsToGenerate)
			classListsRaw.set(request, []);

		for (type in allTypes)
		{
			switch (type)
			{
				case TInst(t, _params):
					final classType:ClassType = t.get();
					final className:String = t.toString();

					if (!classType.isInterface)
					{
						for (request in classListsToGenerate)
						{
							if (doesClassMatchRequest(classType, request))
								classListsRaw.get(request).push(className);
						}
					}
				default:
					continue;
			}
		}

		compileClassLists();
	}

	@:noCompletion
	private static function compileClassLists():Void
	{
		final compiledClassList:ClassType = MacroUtil.getClassType('jta.macros.CompiledClassList');

		if (compiledClassList == null)
			throw 'Could not find CompiledClassList class.';

		if (compiledClassList.meta.has('classLists'))
			compiledClassList.meta.remove('classLists');

		final classLists:Array<Expr> = [];

		for (request in classListsToGenerate)
		{
			final classListEntries:Array<Expr> = [macro $v{request}];

			for (i in classListsRaw.get(request))
				classListEntries.push(macro $v{i});

			classLists.push(macro $a{classListEntries});
		}

		compiledClassList.meta.add('classLists', classLists, Context.currentPos());
	}

	@:noCompletion
	private static function doesClassMatchRequest(classType:ClassType, request:String):Bool
	{
		final splitRequest:Array<String> = request.split('~');

		switch (splitRequest[0])
		{
			case 'package':
				final classPackage:String = classType.pack.join('.');

				if (splitRequest[2] == 'recursive')
					return StringTools.startsWith(classPackage, splitRequest[1]);
				else
					return ~/^${targetPackage}(\.|$)/.match(classPackage);
			case 'extend':
				return MacroUtil.implementsInterface(classType, MacroUtil.getClassType(splitRequest[1]))
					|| MacroUtil.isSubclassOf(classType, MacroUtil.getClassType(splitRequest[1]));
			default:
				throw 'Unknown request type: ${splitRequest[0]}';
		}
	}

	private static var onGenerateCallbackRegistered:Bool = false;
	private static var classListsRaw:Map<String, Array<String>> = [];
	private static var classListsToGenerate:Array<String> = [];
	#end
}
