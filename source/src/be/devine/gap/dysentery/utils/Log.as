package be.devine be.devine.gap.dysentery.utils
{	
	import flash.external.ExternalInterface;

	public class Log
	{
		public static function info(...rest):void
		{
			trace.apply(Log, rest);
			ExternalInterface.call.apply(Log, ["console.log"].concat(rest));	
		}
	}
}