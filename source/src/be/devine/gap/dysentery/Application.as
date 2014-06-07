package be.devine.gap.dysentery
{
	import be.devine.gap.dysentery.views.game.Game;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Application extends Sprite
	{
		// Properties
		private var _game:Game;
		
		// Constructor
		public function Application()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
		}
		
		private function addedToStageHandler(e:Event):void
		{
			_game = new Game();
			addChild(_game);	
		}
	}
}