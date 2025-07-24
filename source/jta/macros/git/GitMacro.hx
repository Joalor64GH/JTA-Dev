package jta.macros.git;

#if sys
import sys.io.Process;

/**
 * Class for retrieving Git commit information.
 */
class GitMacro
{
	/**
	 * Retrieves the current Git commit ID.
	 * @return The commit ID as a macro expression.
	 */
	public static macro function getCommitId():haxe.macro.Expr.ExprOf<String>
	{
		#if !display
		try
		{
			var daProcess = new Process('git', ['log', '--format=%h', '-n', '1']);
			daProcess.exitCode(true);
			return macro $v{daProcess.stdout.readLine()};
		}
		catch (e) {}
		#end
		return macro $v{"-"};
	}

	/**
	 * Retrieves the current Git commit number.
	 * @return The commit number as a macro expression.
	 */
	public static macro function getCommitNumber():haxe.macro.Expr
	{
		#if !display
		try
		{
			var process:Process = new Process('git', ['rev-list', '--count', 'HEAD']);
			process.exitCode(true);
			return macro $v{Std.parseInt(process.stdout.readLine())};
		}
		catch (e:Dynamic) {}
		#end

		return macro $v{0};
	}
}
#end
