package be.devine.gap.dysentery.views.preloader
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Preloader extends Sprite
	{
		// Properties
		public static const PRELOADING_COMPLETE:String = "preloadingComplete";
	
		private var _logo:BasicPreloader;
			
		private var _ratio:Number = 0;
				
		// Constructor
		public function Preloader()
		{
			super();			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
		}
		
		// Methods
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			_logo = new BasicPreloader();
			_logo.x = stage.stageWidth * .5;
			_logo.y = stage.stageHeight * .5;
			_logo.alpha = 0;
			addChild(_logo);
			
			TweenLite.to(_logo, .4, {alpha: 1});
		}
		
		// Getters & Setters
		public function get ratio():Number
		{
			return _ratio;
		}

		public function set ratio(value:Number):void
		{
			_ratio = value;
			if(_ratio >= 1){
				var timer:Timer = new Timer(1000,1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void{
					dispatchEvent(new Event(PRELOADING_COMPLETE));			
				});
				timer.start();
			}
		}
	}
}