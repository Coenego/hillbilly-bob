package be.devine.gap.dysentery.events
{
	import flash.events.Event;
	
	public class NavigationEvent extends Event
	{
		// Properties
		public static const VIEW_CHANGE:String = "viewChanged";
		
		public var view:String = "";
		
		// Constructor
		public function NavigationEvent(type:String, view:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{	
			this.view = view;			
			super(type, bubbles, cancelable);
		}
		
		// Methods
		override public function clone():Event{
			return new NavigationEvent(type, view, bubbles, cancelable);
		}
	}
}