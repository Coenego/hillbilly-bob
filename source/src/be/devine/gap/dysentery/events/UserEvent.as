package be.devine.gap.dysentery.events
{
	import flash.events.Event;
	
	public class UserEvent extends Event
	{
		// Properties
		public static const USER_LOGGED_IN:String = "userLoggedIn";
		public static const USER_LOGGED_OUT:String = "userLoggedOut";
		public static const USER_REGISTERED:String = "userRegistered";
		
		// Constructor
		public function UserEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event{
			return new UserEvent(type, bubbles, cancelable);
		}
	}
}