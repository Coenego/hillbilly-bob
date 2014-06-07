package be.devine.gap.dysentery.events
{
	import flash.events.Event;
	
	public class FacebookEvent extends Event
	{
		// Properties
		public static const POST_TO_WALL:String = "postToWall";
		
		public var message:Object = null;
		
		// Methods
		public function FacebookEvent(type:String, _message:Object, bubbles:Boolean=false, cancelable:Boolean=false){
			this.message = _message;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event{
			return new FacebookEvent(type, message, bubbles, cancelable);	
		}
	}
}