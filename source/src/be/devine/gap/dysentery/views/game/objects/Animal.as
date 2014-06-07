package be.devine.gap.dysentery.views.game.objects
{
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import be.devine.gap.dysentery.controllers.GameController;
	import be.devine.gap.dysentery.controllers.MainController;
	import be.devine.gap.dysentery.views.game.objects.vehicle.components.Chassis;
	
	import com.citrusengine.objects.Box2DPhysicsObject;
	import com.citrusengine.objects.platformer.box2d.Platform;
	import com.citrusengine.physics.box2d.Box2DUtils;
	
	import org.osflash.signals.Signal;

	public class Animal extends Box2DPhysicsObject
	{
		// Properties		
		private var _mainController:MainController;
		private var _gameController:GameController;
		
		public var onContact:Signal;
		public var onFinishedFlying:Signal;
		
		private var _isMoving:Boolean = false;
		
		// Constructor
		public function Animal(name:String, params:Object=null)
		{
			super(name, params);	
			
			// Controllers
			_mainController = MainController.getInstance();
			_gameController = GameController.getInstance();
			
			// Signals
			onContact = new Signal();
			onFinishedFlying = new Signal(uint);
		}		 
		
		// Methods
		override public function initialize(poolObjectParams:Object=null):void{
			super.initialize(poolObjectParams);			
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			
			_fixtureDef.density = 4;
			_fixtureDef.friction = .1;
			_fixtureDef.restitution = .25;
		}
		
		override public function handleBeginContact(contact:b2Contact):void{		
			if(Box2DUtils.CollisionGetOther(this, contact) is Chassis){
				_isMoving = true;
				onContact.dispatch();
				if(!_mainController._soundMuted) _ce.sound.playSound("cow",5,1);
			}else if(_isMoving && (Box2DUtils.CollisionGetOther(this, contact) is Platform)){			
				if(!_mainController._soundMuted) _ce.sound.playSound("hit_ground",(uint(super.body.GetLinearVelocity().y)/4),1);
			}
		}
		
		override public function update(timeDelta:Number):void{
			super.update(timeDelta);
			if(_isMoving && (super.body.GetLinearVelocity().x == 0)){
				onFinishedFlying.dispatch(Math.ceil(super.body.GetPosition().x));
				_isMoving = false;				
			}else if(_isMoving){
				_gameController.currentlyAchievingPoints(Math.ceil(super.body.GetPosition().x));
			}
		}
	}
}