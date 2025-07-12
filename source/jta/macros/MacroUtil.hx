package jta.macros;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
#end

class MacroUtil
{
	public static macro function getDefine(key:String, defaultValue:String = null):Expr
	{
		#if !display
		var value:String = Context.definedValue(key);

		if (value != null && value.length > 0)
			return macro $v{value};
		#end

		return macro $v{defaultValue};
	}

	#if macro
	public static function getClassTypeFromExpr(e:Expr):ClassType
	{
		final parts:Array<String> = [];

		var nextSection:ExprDef = e.expr;

		while (nextSection != null)
		{
			final section:ExprDef = nextSection;

			nextSection = null;

			switch (section)
			{
				case EConst(c):
					switch (c)
					{
						case CIdent(cn):
							if (cn != 'null') parts.unshift(cn);
						default:
					}
				case EField(exp, field):
					nextSection = exp.expr;

					parts.unshift(field);
				default:
			}
		}

		final fullClassName:String = parts.join('.');

		if (fullClassName.length > 0)
		{
			switch (Context.follow(Context.getType(fullClassName), false))
			{
				case TInst(t, params):
					return t.get();
				default:
					throw 'Class type could not be parsed: ${fullClassName}';
			}
		}

		return null;
	}

	public static function isFieldStatic(field:haxe.macro.Expr.Field):Bool
	{
		return field.access.contains(AStatic);
	}

	public static function toExpr(value:Dynamic):ExprOf<Dynamic>
	{
		return Context.makeExpr(value, Context.currentPos());
	}

	public static function areClassesEqual(class1:ClassType, class2:ClassType):Bool
	{
		return class1.pack.join('.') == class2.pack.join('.') && class1.name == class2.name;
	}

	public static function getClassType(name:String):ClassType
	{
		switch (Context.getType(name))
		{
			case TInst(t, _params):
				return t.get();
			default:
				throw 'Class type could not be parsed: ${name}';
		}
	}

	public static function isSubclassOf(classType:ClassType, superClass:ClassType):Bool
	{
		if (areClassesEqual(classType, superClass))
			return true;

		if (classType.superClass != null)
			return isSubclassOf(classType.superClass.t.get(), superClass);

		return false;
	}

	public static function implementsInterface(classType:ClassType, interfaceType:ClassType):Bool
	{
		for (i in classType.interfaces)
		{
			if (areClassesEqual(i.t.get(), interfaceType))
				return true;
		}

		if (classType.superClass != null)
			return implementsInterface(classType.superClass.t.get(), interfaceType);

		return false;
	}
	#end
}
