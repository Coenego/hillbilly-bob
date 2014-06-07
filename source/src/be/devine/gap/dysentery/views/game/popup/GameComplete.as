package be.devine.gap.dysentery.views.game.popup
{
	import be.devine.gap.dysentery.Assets;
	import be.devine.gap.dysentery.constants.Views;
	import be.devine.gap.dysentery.controllers.GameController;
	import be.devine.gap.dysentery.controllers.MainController;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class GameComplete extends Sprite
	{
		// Properties
		private var _mainController:MainController;
		private var _gameController:GameController;
		
		private var _bg:Image;
		
		private var _txtScore:TextField;
		
		private var _btnPlayAgain:Button;
		private var _btnStopPlaying:Button;
		
		private var points:uint = 0;
		
		// Constructor
		public function GameComplete(_points:uint)
		{
			super();	
			
			_mainController = MainController.getInstance();
			_gameController = GameController.getInstance();	
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			this.points = _points;
		}
		
		// Methods
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);	
			drawScreen();
		}
		
		private function drawScreen():void
		{
			_bg = new Image(Assets.getTexture("BGGameComplete"));
			_bg.x = -(stage.stageWidth * .5);
			_bg.y = -(stage.stageHeight * .5);
			addChild(_bg);
			
			_btnPlayAgain = new Button(Assets.getAtlas().getTexture('btnPlayAgain'));
			_btnPlayAgain.addEventListener(Event.TRIGGERED, buttonClickHandler);
			_btnPlayAgain.alpha = .75;
			_btnPlayAgain.y = 80;
			_btnPlayAgain.x = 133;
			addChild(_btnPlayAgain);
			
			_btnStopPlaying = new Button(Assets.getAtlas().getTexture("btnStopPlaying"));
			_btnStopPlaying.addEventListener(Event.TRIGGERED, buttonClickHandler);
			_btnStopPlaying.x = (-(_btnStopPlaying.width)) + 123;
			_btnStopPlaying.y = 80;
			_btnStopPlaying.alpha = .75;
			addChild(_btnStopPlaying);
			
			var text:String = "You scored " + this.points + " points! \n\n" + _gameController.checkHowManyPointsNeededForNextVehicle(_gameController.getUserTotalScore());
			_txtScore = new TextField(1024, 250, text, 'frizQuadrataBold', 30, 0xFFFFFF, true);
			_txtScore.x = -(stage.stageWidth* .5);
			_txtScore.y = -165;
			addChild(_txtScore);
		}
		
		private function buttonClickHandler(e:Event=null):void
		{
			if(e.target == _btnPlayAgain){
				_gameController.startNewGame();				
			}else if(e.target == _btnStopPlaying){
				_mainController.setActiveView(Views.WELCOME);
			}
		}		
	}
}