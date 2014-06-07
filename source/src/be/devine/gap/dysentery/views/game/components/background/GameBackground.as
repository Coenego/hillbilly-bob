package be.devine.gap.dysentery.views.game.components.background
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GameBackground extends Sprite
	{
		// Properties
		private var background:GameBackgroundLayer;
		private var grass:GameBackgroundLayer;
		private var paaltjes:GameBackgroundLayer;
		private var mill:GameBackgroundLayer;
		private var cows:GameBackgroundLayer;
		
		private var _speed:Number = 0;
		
		// Constructor
		public function GameBackground()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		// Methods
		private function addedToStageHandler(e:Event):void
		{			
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			background = new GameBackgroundLayer(1,0);
			background.parallax = 0.05;
			addChild(background);
			
			cows = new GameBackgroundLayer(5,0);
			cows.parallax = 0.75;
			addChild(cows);			
			
			mill = new GameBackgroundLayer(4,0);
			mill.parallax = 0.1;
			addChild(mill);
			
			paaltjes = new GameBackgroundLayer(3,0);
			paaltjes.parallax = 0.75;
			addChild(paaltjes);
			
			grass = new GameBackgroundLayer(2,0);
			grass.parallax = 1;
			addChild(grass);		
											
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(e:Event):void
		{
			background.x -= Math.ceil(_speed * background.parallax);
			if(background.x <= -stage.stageWidth) background.x = 0;

			grass.x -= Math.ceil(_speed * grass.parallax);
			if(grass.x <= -stage.stageWidth) grass.x = 0;
					
			paaltjes.x -= Math.ceil(_speed * paaltjes.parallax);
			if(paaltjes.x <= -stage.stageWidth) paaltjes.x = 0;
			
			mill.x -= Math.ceil(_speed * mill.parallax);
			if(mill.x <= -stage.stageWidth) mill.x = 0;
			
			cows.x -= Math.ceil(_speed * cows.parallax);
			if(cows.x <= -stage.stageWidth) cows.x = 0;
		}

		// Getters & Setters
		public function get speed():Number
		{
			return _speed;
		}

		public function set speed(value:Number):void
		{
			_speed = value;
		}
	}
}