package
{
	import be.devine.gap.dysentery.views.preloader.Preloader;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	
	[SWF(frameRate="60", width="1024", height="768", backgroundColor="0x231E17")]
	public class Main extends MovieClip
	{
		// Properties		
		private var _preloader:Preloader;
		private var _app:DisplayObject;
		
		// Constructor
		public function Main()
		{								
			// Stage settings
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// Preloader
			_preloader = new Preloader();
			_preloader.addEventListener(Preloader.PRELOADING_COMPLETE, completeHandler, false, 0, true);
			addChild(_preloader);
			
			// Loaderinfo			
			if(loaderInfo.bytesLoaded == loaderInfo.bytesTotal){
				_preloader.ratio = 1;
			}else{
				loaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler, false, 0, true);
			}
		}
		
		// Methods					
		private function progressHandler(e:ProgressEvent):void
		{
			if(_preloader) _preloader.ratio = e.bytesLoaded/e.bytesTotal;	
		}
		
		private function completeHandler(e:Event):void
		{
			gotoAndStop("start");
			var appClass:* = getDefinitionByName("be.devine.gap.dysentery.Application");
			_app = new appClass();
			addChild(_app);
			
			if(_preloader && _preloader != null) removeChild(_preloader);
		}
	}
}