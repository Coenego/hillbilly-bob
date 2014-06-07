package be.devine.gap.dysentery.views.game
{
	import be.devine.gap.dysentery.constants.Views;
	import be.devine.gap.dysentery.controllers.MainController;
	import be.devine.gap.dysentery.events.NavigationEvent;
	import be.devine.gap.dysentery.views.game.states.InGame;
	import be.devine.gap.dysentery.views.game.states.Welcome;
	
	import com.citrusengine.core.StarlingCitrusEngine;
	import com.citrusengine.core.StarlingState;
	
	import flash.events.Event;
	
	public class Game extends StarlingCitrusEngine
	{
		// Properties
		private var _mainController:MainController;
		
		private var _stateToBeReplaced:StarlingState;
		
		// Constructor
		public function Game()
		{			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);	
		}
		
		// Methods
		private function addedToStageHandler(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			// Starling
			this.setUpStarling(false, 1);
			
			// Sound
			sound.addSound("theme","assets/sounds/duellingbanjos.mp3");
			sound.addSound("hit_ground","assets/sounds/hit_ground.mp3");			
			sound.addSound("hit_can","assets/sounds/hit_can.mp3");			
			sound.addSound("hit_car","assets/sounds/hit_car.mp3");			
			sound.addSound("tractor","assets/sounds/tractor.mp3");			
			sound.addSound("yeehaw","assets/sounds/yeehaw.mp3");			
			sound.addSound("whip","assets/sounds/whip.mp3");			
			sound.addSound("cow","assets/sounds/cow.mp3");
			
			// Controller
			_mainController = MainController.getInstance();		
			_mainController.addEventListener(NavigationEvent.VIEW_CHANGE, viewChangedHandler, false, 0, true);
			_mainController.init();
			
			// First state
			this.state = _stateToBeReplaced = new Welcome();
		}
		
		private function viewChangedHandler(e:NavigationEvent):void{
			if(e.view != null){
				_stateToBeReplaced.destroy();
				switch(e.view){
					case Views.WELCOME:
						_stateToBeReplaced = new Welcome();
						break;
					case Views.GAME:
						_stateToBeReplaced = new InGame();
						break;
				}
				this.state = _stateToBeReplaced;
			}
		}
	}
}