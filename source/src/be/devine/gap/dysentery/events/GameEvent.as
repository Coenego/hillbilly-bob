package be.devine.gap.dysentery.events
{
	import flash.events.Event;
	
	public class GameEvent extends Event
	{
		// Properties
		public static const ACHIEVING_POINTS:String = "achievingPoints";
		
		public var points:Number = 0;
		
		// Constructor
		public function GameEvent(type:String, _points:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.points = _points;
			super(type, bubbles, cancelable);
		}
	}
}