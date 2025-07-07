package jta.objects.dialogue;

typedef ParsedText =
{
	cleanedText:String,
	actions:Array<Action>
}

typedef Action =
{
	index:Int,
	type:String,
	value:String
}

class TextParser
{
	private static final PARSE_REGEX:EReg = ~/(\[([a-zA-Z]+):([^\]]+)\])/;

	public static function parse(text:String):ParsedText
	{
		final cleanedText:StringBuf = new StringBuf();
		final actions:Array<Action> = new Array<Action>();

		var lastPos:Int = 0;
		var matchPos:Int = 0;

		while (PARSE_REGEX.match(text))
		{
			matchPos = PARSE_REGEX.matchedPos().pos;

			final fullMatch:String = PARSE_REGEX.matched(1);
			final type:String = PARSE_REGEX.matched(2);
			final value:String = PARSE_REGEX.matched(3);

			cleanedText.addSub(text, lastPos, matchPos - lastPos);

			actions.push({index: cleanedText.length, type: type, value: value});

			lastPos = matchPos + fullMatch.length;
			text = text.substr(lastPos);
			lastPos = 0;
		}

		cleanedText.addSub(text, lastPos, text.length - lastPos);

		return {cleanedText: cleanedText.toString(), actions: actions};
	}
}
