package be.devine.gap.dysentery.views.game.components.background
{	
	import be.devine.gap.dysentery.Assets;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GameBackgroundLayer extends Sprite
	{
		// Properties
		private var img1:Image;
		private var img2:Image;

		private var _posY:uint;
		private var _layer:int;
		
		private var _parallax:Number;
		
		// Constructor
		
		// Methods
		public function GameBackgroundLayer(layer:int, posY:uint)
		{
			super();
			this._posY = posY;
			this._layer = layer;
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			if(_layer == 1){
				img1 = new Image(Assets.getTexture("BgGame"));		
				img2 = new Image(Assets.getTexture("BgGame"));	
				img1.y = _posY;
				img2.y = _posY;
			}else if(_layer == 2){
				img1 = new Image(Assets.getTexture("BgGameGrass"));		
				img2 = new Image(Assets.getTexture("BgGameGrass"));	
				img1.y = _posY;
				img2.y = _posY;		
			}else if(_layer == 3){
				img1 = new Image(Assets.getTexture("BgGamePaaltjes"));		
				img2 = new Image(Assets.getTexture("BgGamePaaltjes"));	
				img1.y = _posY;
				img2.y = _posY;		
			}else if(_layer == 4){
				img1 = new Image(Assets.getTexture("BgGameMill"));		
				img2 = new Image(Assets.getTexture("BgGameMill"));	
				img1.y = _posY;
				img2.y = _posY;		
			}else if(_layer == 5){
				img1 = new Image(Assets.getTexture("BgGameCows"));		
				img2 = new Image(Assets.getTexture("BgGameCows"));	
				img1.y = _posY;
				img2.y = _posY;		
			}
			
			img1.x = 0;		
			img2.x = stage.stageWidth;
			
			this.addChild(img1);
			this.addChild(img2);
		}

		// Getters & Setters
		public function get parallax():Number
		{
			return _parallax;
		}

		public function set parallax(value:Number):void
		{
			_parallax = value;
		}
	}
}