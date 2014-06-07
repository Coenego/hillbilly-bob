package be.devine.gap.dysentery.views.game.objects
{
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import be.devine.gap.dysentery.controllers.MainController;
	
	import com.citrusengine.objects.platformer.box2d.Coin;
	import com.citrusengine.physics.box2d.Box2DUtils;
	import com.citrusengine.physics.box2d.IBox2DPhysicsObject;
	
	import org.osflash.signals.Signal;
	
	public class Can extends Coin
	{
		// Properties
		private var _mainController:MainController;
		
		public var onCanTaken:Signal;
		
		private var points:Number;
		
		// Constructor
		public function Can(name:String, _points:Number, params:Object=null)
		{
			super(name, params);
			this.points = _points;
			
			// Controllers
			_mainController = MainController.getInstance();
			
			// Signals
			onCanTaken = new Signal(Number);
		}
		
		// Methods
		override public function initialize(poolObjectParams:Object=null):void{
			super.initialize(poolObjectParams);	
		}
		
		override public function handleBeginContact(contact:b2Contact):void{			
			super.handleBeginContact(contact);			
			var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);		
			if (_collectorClass && collider is _collectorClass){
				if(!_mainController._soundMuted) _ce.sound.playSound("hit_can",5,1);
				onCanTaken.dispatch(points);
				kill = true;
			}
		}
				
		override public function update(timeDelta:Number):void{
			super.update(timeDelta);
		}
	}
}