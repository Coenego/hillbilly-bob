package be.devine.gap.dysentery.views.game.components
{
	import be.devine.gap.dysentery.Assets;
	import be.devine.gap.dysentery.controllers.GameController;
	import be.devine.gap.dysentery.controllers.MainController;
	import be.devine.gap.dysentery.events.GameEvent;
	
	import com.citrusengine.core.CitrusEngine;
	
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class TopBar extends Sprite
	{
		// Properties
		private var _ce:CitrusEngine;
		
		private var _mainController:MainController;
		private var _gameController:GameController;
		
		private var _bgImage:Image;
		
		private var _btnHowTo:Button;
		private var _btnMute:Button;
		
		private var _currentScore:TextField;
				
		// Constructor
		public function TopBar()
		{
			super();
			
			_ce = CitrusEngine.getInstance();
			
			_mainController = MainController.getInstance();
			
			_gameController = GameController.getInstance();
			_gameController.addEventListener(GameEvent.ACHIEVING_POINTS, updateScoreHandler, false, 0, true);
						
			drawScreen();
		}
		
		// Methods
		private function drawScreen():void
		{
			_bgImage = new Image(Assets.getAtlas().getTexture('game/topbar'));	
			addChild(_bgImage);	
			
			_btnHowTo = new Button(Assets.getAtlas().getTexture('btnHowTo'));
			_btnHowTo.addEventListener(Event.TRIGGERED, buttonClickedHandler);
			_btnHowTo.y = 22;
			_btnHowTo.x = 22;
			addChild(_btnHowTo);
			
			_btnMute = new Button(Assets.getAtlas().getTexture('btnMute'));
			_btnMute.addEventListener(Event.TRIGGERED, buttonClickedHandler);
			_btnMute.x = 82;
			_btnMute.y = 22;
			addChild(_btnMute);		
			
			_currentScore = new TextField(300, 50, '0', 'frizQuadrataBold', 50, 0xFFFFFF, true);
			_currentScore.hAlign = 'right';
			_currentScore.alpha = .8;
			_currentScore.x = 700;
			_currentScore.y = 25;
			addChild(_currentScore);
			
			doBlendMode();
		}
		
		private function buttonClickedHandler(e:Event):void
		{
			trace('[TopBar] buttonClickedHandler');
			switch(e.target){
				case _btnHowTo:
					_mainController.toggleHelp(true);
					break;
				case _btnMute:
					_mainController.muteSound();
					doBlendMode();
					break;
			}
		}
		
		private function updateScoreHandler(e:GameEvent):void{
			_currentScore.text = String(e.points);
		}
		
		private function doBlendMode():void{
			_btnMute.blendMode = (_mainController._soundMuted) ? BlendMode.MULTIPLY : BlendMode.NORMAL;
		}
	}
}