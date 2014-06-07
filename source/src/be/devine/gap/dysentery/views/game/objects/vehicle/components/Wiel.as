package be.devine.gap.dysentery.views.game.objects.vehicle.components{
	
	import com.citrusengine.objects.Box2DPhysicsObject;
	
	import flash.ui.Keyboard;
	
	public class Wiel extends Box2DPhysicsObject
	{			
		// Properties
		private var torque:uint = 0;
		private var acceptsTorque:Boolean = false;
				
		// Constructor
		public function Wiel(name:String, _torque:uint, _acceptsTorque:Boolean, params:Object = null)
		{
			super(name, params);		
			this.torque = _torque;
			this.acceptsTorque = _acceptsTorque;
		}
		
		override public function initialize(poolObjectParams:Object=null):void
		{
			super.initialize(poolObjectParams);	
		}

		// Methods
		override public function destroy():void
		{			
			super.destroy();
		}
		
		public function brake():void
		{
			_body.ApplyTorque(-(torque * 2500));
		}
		
		override protected function defineBody():void
		{
			super.defineBody();	
		}
		
		override protected function createBody():void
		{
			super.createBody();			
		}
		
		override protected function createShape():void
		{
			super.createShape();
		}
		
		override protected function createFixture():void
		{
			super.createFixture();
		}
				
		override protected function defineFixture():void
		{
			super.defineFixture();			
		}
						
		override public function update(timeDelta:Number):void
		{
			if(acceptsTorque){
				if(_ce.input.isDown(Keyboard.RIGHT)){
					_body.ApplyTorque(this.torque);
				}else if(_ce.input.isDown(Keyboard.LEFT)){
					_body.ApplyTorque((this.torque) * -1);
				}				
			}
		}
	}
}