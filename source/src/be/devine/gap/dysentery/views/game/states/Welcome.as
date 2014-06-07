package be.devine.gap.dysentery.views.game.states
{
	import be.devine.gap.dysentery.Assets;
	import be.devine.gap.dysentery.controllers.GameController;
	import be.devine.gap.dysentery.controllers.MainController;
	import be.devine.gap.dysentery.views.game.popup.HowTo;
	
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.StarlingState;
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	
	public class Welcome extends StarlingState
	{
		// Properties
		private var _ce:CitrusEngine;
		
		private var _mainController:MainController;
		private var _gameController:GameController;
		
		private var _bg:Image;
		
		private var _howTo:HowTo;
		
		private var _btnHowTo:Button;
		private var _btnWithFacebook:Button;
		private var _btnWithoutFacebook:Button;
						
		// Constructor
		public function Welcome()
		{
			super();			
		}
		
		// Methods
		override public function initialize():void
		{			
			super.initialize();	
			
			// Controllers
			_mainController = MainController.getInstance();
			_gameController = GameController.getInstance();
			_gameController.init();
			
			// Citrus Engine
			_ce = CitrusEngine.getInstance();
			_ce.sound.stopSound('theme');
			if(!_mainController._soundMuted) _ce.sound.playSound('theme');
							
			// Graphics	
			drawScreen();
			
			// Help
			_mainController.addEventListener(MainController.SHOW_HELP, showHelp, false, 0, true);
			_mainController.addEventListener(MainController.HIDE_HELP, hideHelp, false, 0, true);
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			removeChild(_bg);
			
			_btnWithFacebook.removeEventListener(starling.events.Event.TRIGGERED, buttonTriggerHandler);			
			removeChild(_btnWithFacebook);
			
			_btnWithoutFacebook.removeEventListener(starling.events.Event.TRIGGERED, buttonTriggerHandler);
			removeChild(_btnWithoutFacebook);
		}
		
		private function drawScreen():void
		{
			_bg = new Image(Assets.getTexture('BgWelcome'));
			addChild(_bg);
			
			_btnHowTo = new Button(Assets.getAtlas().getTexture('btnHowTo'));
			_btnHowTo.addEventListener(starling.events.Event.TRIGGERED, buttonTriggerHandler);
			_btnHowTo.y = 22;
			_btnHowTo.x = 950;
			addChild(_btnHowTo);
			
			_btnWithFacebook = new Button(Assets.getAtlas().getTexture("btnWithFacebook"));
			_btnWithFacebook.addEventListener(starling.events.Event.TRIGGERED, buttonTriggerHandler);
			_btnWithFacebook.alpha = 0;
			_btnWithFacebook.x = 714;
			_btnWithFacebook.y = 460;
			addChild(_btnWithFacebook);
			
			_btnWithoutFacebook = new Button(Assets.getAtlas().getTexture("btnWithoutFacebook"));
			_btnWithoutFacebook.addEventListener(starling.events.Event.TRIGGERED, buttonTriggerHandler);
			_btnWithoutFacebook.alpha = 0;
			_btnWithoutFacebook.x = 609;
			_btnWithoutFacebook.y = 575;
			addChild(_btnWithoutFacebook);
			
			TweenLite.to(_btnWithFacebook, .25, {alpha:  1, delay: .2});
			TweenLite.to(_btnWithoutFacebook, .25, {alpha: 1, delay: .3});
		}
		
		private function buttonTriggerHandler(e:starling.events.Event):void
		{
			if(!_mainController._soundMuted) _ce.sound.playSound("whip",3,1);
			switch(e.target){
				case _btnHowTo:
					_mainController.toggleHelp(true);
					break;
				case _btnWithFacebook:
					_mainController.loginWithFacebook();
					break;
				case _btnWithoutFacebook:
					_mainController.playWithoutLogin();
					break;
			}
		}
		
		private function showHelp(e:flash.events.Event):void
		{
			_howTo = new HowTo();
			_howTo.x = 512 - (_howTo.width * .5);
			_howTo.y = 384 - (_howTo.height * .5);
			_howTo.alpha = 0;
			addChild(_howTo);
			
			TweenLite.to(_howTo, .5, {alpha: 1});
		}
		
		private function hideHelp(e:flash.events.Event):void
		{
			TweenLite.to(_howTo, .5, {alpha: 0, onComplete: onTweenComplete});
		}
		
		private function onTweenComplete(e:flash.events.Event=null):void
		{
			if(_howTo && _howTo != null){
				removeChild(_howTo);
			}	
		}
	}
}