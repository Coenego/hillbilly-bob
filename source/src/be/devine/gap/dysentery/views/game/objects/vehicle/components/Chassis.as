package be.devine.gap.dysentery.views.game.objects.vehicle.components
{
	import com.citrusengine.objects.Box2DPhysicsObject;
	
	public class Chassis extends Box2DPhysicsObject
	{
		// Properties
		
		// Constructor
		public function Chassis(name:String, params:Object=null)
		{
			super(name, params);
		}
		
		// Methods
		override public function initialize(poolObjectParams:Object=null):void
		{
			super.initialize(poolObjectParams);
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
	}
}