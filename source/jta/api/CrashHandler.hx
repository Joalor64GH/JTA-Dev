package jta.api;

#if (desktop && !debug)
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import jta.api.DiscordClient;
import jta.api.native.WindowsAPI;

/**
 * Class to handle crashes in the application.
 */
class CrashHandler
{
	/**
	 * Initializes the crash handler.
	 */
	public static function init():Void
	{
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);

		#if cpp
		untyped __global__.__hxcpp_set_critical_error_handler(onFatalCrash);
		#end
	}

	private static function onCrash(e:UncaughtErrorEvent):Void
	{
		var stack:Array<String> = [];
		stack.push(e.error);

		for (stackItem in CallStack.exceptionStack(true))
		{
			switch (stackItem)
			{
				case CFunction:
					stack.push('C Function');
				case Module(m):
					stack.push('Module ($m)');
				case FilePos(s, file, line, column):
					stack.push('$file (line $line)');
				case Method(classname, method):
					stack.push('$classname (method $method)');
				case LocalFunction(name):
					stack.push('Local Function ($name)');
			}
		}

		e.preventDefault();
		e.stopPropagation();
		e.stopImmediatePropagation();

		final msg:String = stack.join('\n');

		#if sys
		try
		{
			if (!FileSystem.exists('./crash/'))
				FileSystem.createDirectory('./crash/');

			File.saveContent('./crash/${Lib.application.meta.get('file')}-${Date.now().toString().replace(' ', '-').replace(':', "'")}.txt', '$msg\n');
		}
		catch (e:Dynamic)
			Sys.println('Error!\nCouldn\'t save the crash dump because:\n$e');
		#end

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		#if hxdiscord_rpc
		DiscordClient.shutdown();
		#end

		#if windows
		WindowsAPI.messageBox('Error!', 'Uncaught Error: \n$msg
			\n\nIf you think this shouldn\'t have happened, report this error to GitHub repository!\nhttps://github.com/JoaTH-Team/JTA/issues', MSG_ERROR);
		#else
		Lib.application.window.alert('Uncaught Error: \n$msg
			\n\nIf you think this shouldn\'t have happened, report this error to GitHub repository!\nhttps://github.com/JoaTH-Team/JTA/issues', 'Error!');
		#end
		Sys.println('Uncaught Error: \n$msg
			\n\nIf you think this shouldn\'t have happened, report this error to GitHub repository!\nhttps://github.com/JoaTH-Team/JTA/issues');
		Sys.exit(1);
	}

	#if cpp
	private static function onFatalCrash(msg:String):Void
	{
		var errMsg:String = '';
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(' ', '_');
		dateNow = dateNow.replace(':', '\'');

		path = './crash/JTA_$dateNow.txt';

		errMsg += '${msg}\n';

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += 'in ${file} (line ${line})\n';
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += '\n\nPlease report this error to the GitHub page: https://github.com/JoaTH-Team/JTA/issues';

		if (!FileSystem.exists('./crash/'))
			FileSystem.createDirectory('./crash/');

		File.saveContent(path, '$errMsg\n');

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		Sys.println(errMsg);
		Sys.println('Crash dump saved in ${Path.normalize(path)}');

		Application.current.window.alert(errMsg, 'CRITICAL ERROR!');
		#if hxdiscord_rpc
		DiscordClient.shutdown();
		#end
		Sys.exit(1);
	}
	#end
}
#end
