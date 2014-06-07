package be.devine.gap.dysentery.views.game.popup
{
	import be.devine.gap.dysentery.Assets;
	import be.devine.gap.dysentery.controllers.MainController;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class HowTo extends Sprite
	{
		// Properties
		private var _mainController:MainController;
		
		private var _bg:Image
		
		private var _btnOk:Button;
		
		// Constructor
		public function HowTo()
		{
			super();
			
			_mainController = MainController.getInstance();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		// Methods
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			drawScreen();
		}
		
		private function drawScreen():void
		{
			_bg = new Image(Assets.getTexture("BGGameHelp"));
			_bg.x = -(stage.stageWidth * .5);
			_bg.y = -(stage.stageHeight * .5);
			addChild(_bg);
			
			_btnOk = new Button(Assets.getAtlas().getTexture('btnOK'));
			_btnOk.addEventListener(Event.TRIGGERED, buttonClickHandler);
			_btnOk.y = 105;
			_btnOk.x = 160;
			addChild(_btnOk);
		}
		
		private function buttonClickHandler(e:Event):void
		{
			_mainController.toggleHelp(false);
		}
	}
}