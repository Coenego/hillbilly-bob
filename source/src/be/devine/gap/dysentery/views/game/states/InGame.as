package be.devine.gap.dysentery.views.game.states
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	
	import be.devine.gap.dysentery.Assets;
	import be.devine.gap.dysentery.constants.GameConstants;
	import be.devine.gap.dysentery.controllers.GameController;
	import be.devine.gap.dysentery.controllers.MainController;
	import be.devine.gap.dysentery.data.VehicleVO;
	import be.devine.gap.dysentery.models.AppModel;
	import be.devine.gap.dysentery.models.UserModel;
	import be.devine.gap.dysentery.views.game.components.TopBar;
	import be.devine.gap.dysentery.views.game.components.background.GameBackground;
	import be.devine.gap.dysentery.views.game.objects.Animal;
	import be.devine.gap.dysentery.views.game.objects.Can;
	import be.devine.gap.dysentery.views.game.objects.vehicle.components.Chassis;
	import be.devine.gap.dysentery.views.game.objects.vehicle.components.Wiel;
	import be.devine.gap.dysentery.views.game.popup.GameComplete;
	import be.devine.gap.dysentery.views.game.popup.HowTo;
	
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.StarlingState;
	import com.citrusengine.math.MathVector;
	import com.citrusengine.objects.Box2DPhysicsObject;
	import com.citrusengine.objects.platformer.box2d.Platform;
	import com.citrusengine.physics.box2d.Box2D;
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import starling.display.Image;
	
	public class InGame extends StarlingState
	{
		// Properties	
		private var _ce:CitrusEngine;
		private var _box2D:Box2D;

		private var _mainController:MainController;
		private var _gameController:GameController;
		
		private var _appModel:AppModel;
		private var _userModel:UserModel;
		
		private var _gameComplete:GameComplete;
		private var _howTo:HowTo;
		
		private var _topBar:TopBar;
		
		private var _myBackground:GameBackground;
		
		private var _vehicle:Vector.<Box2DPhysicsObject>;
		private var _vehicleObject:VehicleVO;

		private var _voorwiel:Wiel;
		private var _achterwiel:Wiel;
		private var _chassis:Chassis;

		private var _chassisImage:Image;
		private var _voorwielImage:Image;
		private var _achterwielImage:Image;
				
		private var _animal:Animal;
		private var _can:Can;
						
		private var maxWidth:uint = 20480;
		private var totalWidth:uint = 0;
		private var platformWidth:uint = 1024;
		
		private var _prevAnimalPosX:uint = 0;
				
		// Constructor
		public function InGame()
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
			
			// Models
			_appModel = AppModel.getInstance();
			_userModel = UserModel.getInstance();
			
			// Citrus Engine
			_ce = CitrusEngine.getInstance();
			_ce.sound.stopSound("theme");
			if(!_mainController._soundMuted) _ce.sound.playSound("tractor", 2);
			
			// Create vehicle object			
			switch(_userModel._currentUser.vehicle){
				case 1:
					_vehicleObject = _appModel._vehicles['tractor'];
					break;
				case 2:
					_vehicleObject = _appModel._vehicles['pickup'];
					break;
				case 3:
					_vehicleObject = _appModel._vehicles['superpickup'];
					break;
				case 4:
					_vehicleObject = _appModel._vehicles['cropduster'];
					break;
			}
			
			// Draw elements on screen
			drawScreen();	
			
			// Help
			_mainController.addEventListener(MainController.SHOW_HELP, showHelp, false, 0, true);
			_mainController.addEventListener(MainController.HIDE_HELP, hideHelp, false, 0, true);
		}
		
		override public function destroy():void
		{
			super.destroy();			
			removeComponentsFromStage();
		}
		
		private function drawScreen():void
		{						
			// Box2D
			_box2D = new Box2D("box2D");					
			_box2D.world.SetGravity(new b2Vec2(0.0, 9.81));
			_box2D.visible = false;
			add(_box2D);
			
			// Background
			_myBackground = new GameBackground();
			addChild(_myBackground);
			_myBackground.parent.setChildIndex(_myBackground,0);
			
			// Topbar
			_topBar = new TopBar();
			_topBar.y = -300;
			addChild(_topBar);
			TweenLite.to(_topBar, .3, {y: 0, ease: Sine.easeOut});
			
			// Yeehaw
			if(!_mainController._soundMuted) _ce.sound.playSound("yeehaw",.5,1);
											
			createWalls();			
			createVehicle();
			createAnimal();
																
			var _counter:Number = (platformWidth + 56);
			while(_counter < maxWidth){
				createCan(_counter);
				_counter += 80;
			}
			
			while(totalWidth < maxWidth){
				createPlatform();
				totalWidth += platformWidth;
			}
								
			view.setupCamera(_voorwiel, new MathVector(stage.stageWidth * .5, stage.stageHeight), new Rectangle(0,0, stage.stageWidth, stage.stageHeight), new MathVector(1, 1));				
		}
		
		private function createPlatform():void
		{
			var groundImage:Image = new Image(Assets.getAtlas().getTexture('game/grass_front'));
			addChild(groundImage);
			
			var ground:Platform = new Platform("ground",{x: (totalWidth + (platformWidth * .5)), y: stage.stageHeight - 50, width: platformWidth, view: groundImage});
			add(ground);	
		}
		
		private function createWalls():void
		{
			var _startWall:Platform = new Platform("startWall",{x: -5, y: stage.stageHeight - (stage.stageHeight*.5), width: 10, height: stage.stageHeight});			
			var _endWall:Platform = new Platform("endWall",{x: maxWidth + 5, y: stage.stageHeight - (stage.stageHeight*.5), width: 10, height: stage.stageHeight});

			add(_startWall);
			add(_endWall);
		}
		
		private function createVehicle():void
		{						
			// Visual components			
			_chassisImage = _vehicleObject.chassisImage;
			_voorwielImage = _vehicleObject.voorwielImage;
			_achterwielImage = _vehicleObject.achterwielImage;
			
			addChild(_chassisImage);
			addChild(_voorwielImage);						
			addChild(_achterwielImage);
							
			// Box2D Components
			_chassis = new Chassis('chassis', {x: _vehicleObject.chassisPosX, y: stage.stageHeight - 350, width: _vehicleObject.chassisWidth, height: _vehicleObject.chassisHeight, view: _chassisImage});			
			_achterwiel = new Wiel('achterwiel', _vehicleObject.torqueSpeed, true, {x: _vehicleObject.achterwielPosX, y: stage.stageHeight - 350, radius: _vehicleObject.achterwielRadius, view: _achterwielImage});	
			_voorwiel = new Wiel('voorwiel', _vehicleObject.torqueSpeed, true, {x: _vehicleObject.voorwielPosX, y: stage.stageHeight - 350, radius: _vehicleObject.voorwielRadius, view: _voorwielImage});
			
			add(_chassis);
			add(_voorwiel);
			add(_achterwiel);
		
			// Joints
			var _voorwielJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();	
			var _voorwielBody:b2Body = _voorwiel.getBody();
			_voorwielJointDef.Initialize(_voorwiel.getBody(), _chassis.getBody(), new b2Vec2(_voorwielBody.GetWorldCenter().x + (1/GameConstants.WORLD_DIMENSIONS), _voorwielBody.GetWorldCenter().y));			
			var _voorwielJoint:b2RevoluteJoint = _box2D.world.CreateJoint(_voorwielJointDef) as b2RevoluteJoint;	
			
			var _achterwielJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();	
			var _achterwielBody:b2Body = _achterwiel.getBody();
			_achterwielJointDef.Initialize(_achterwiel.getBody(), _chassis.getBody(), new b2Vec2(_achterwielBody.GetWorldCenter().x - (1/GameConstants.WORLD_DIMENSIONS), _achterwielBody.GetWorldCenter().y));			
			var _achterwielJoint:b2RevoluteJoint = _box2D.world.CreateJoint(_achterwielJointDef) as b2RevoluteJoint;
			
			// Vehicle
			_vehicle = new Vector.<Box2DPhysicsObject>;
			_vehicle[0] = _voorwiel;
			_vehicle[1] = _achterwiel;
			_vehicle[2] = _chassis;									
		}
		
		private function createAnimal():void
		{
			// Visual component
			var cowImage:Image = new Image(Assets.getAtlas().getTexture('game/cow'));
			addChild(cowImage);
			
			// Box2D component
			_animal = new Animal('animal', {x: 32 * GameConstants.WORLD_DIMENSIONS, y: stage.stageHeight - 100, height: 42, width: 60, view: cowImage});
			_animal.onFinishedFlying.add(handleFinishedFlying);
			_animal.onContact.add(handleAnimalHit);
			add(_animal);			
		}
		
		private function createCan(_counter:Number):void
		{
			// Visual component
			var canImage:Image = new Image(Assets.getAtlas().getTexture('game/can'));
			addChild(canImage);
			
			// Box2D component
			_can = new Can('coin', 3, {x: _counter, y: stage.stageHeight - 120, collectorClass: Animal, view: canImage});
			_can.onCanTaken.add(handleCanTaken);
			add(_can);				
		}
						
		private function handleAnimalHit():void
		{
			if(!_mainController._soundMuted) _ce.sound.playSound("hit_car",5,1);
			
			// Wheels -> brake
			_voorwiel.brake();
			_achterwiel.brake();
			
			// Impulse
			_animal.body.ApplyImpulse(new b2Vec2((_chassis.body.GetLinearVelocity().x) * (_vehicleObject.factor + (UserModel.getInstance()._currentUser.score/175)),((_chassis.body.GetLinearVelocity().x * .1)) * -1), new b2Vec2(10,10));
			
			// Camera
			view.setupCamera(_animal, new MathVector(stage.stageWidth * .5, stage.stageHeight + 10), new Rectangle(0,0, (maxWidth * 2), 5000), new MathVector(.5, .5));
		
			for each(var component:Box2DPhysicsObject in _vehicle) component.destroy();
		}

		private function handleCanTaken(points:Number):void
		{
			_gameController.updateTemporaryScore(points);	
		}
		
		private function handleFinishedFlying(distance:uint):void
		{
			// Update Score
			_gameController.updateScore(distance);	

			// Show score
			var timer:Timer = new Timer(250,1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void
			{	
				_ce.sound.stopSound("tractor");
				if(!_mainController._soundMuted) _ce.sound.playSound("theme");
				
				_gameComplete = new GameComplete(distance);
				_gameComplete.x = (stage.stageWidth * .5) - (_gameComplete.width * .5);
				_gameComplete.y = (stage.stageHeight * .5) - (_gameComplete.height * .5);
				_gameComplete.alpha = 0;
				addChild(_gameComplete);	
				
				TweenLite.to(_gameComplete, .5, {alpha: 1});
				
				removeComponentsFromStage();
			});
			timer.start();				
		}
			
		override public function update(timeDelta:Number):void
		{			
			super.update(timeDelta);
						
			// Animate background
			_myBackground.speed = Math.floor((_animal.x - _prevAnimalPosX))
			_prevAnimalPosX = _animal.x;	
		}
		
		private function removeComponentsFromStage():void
		{
			if(_chassis) remove(_chassis);
			if(_voorwiel) remove(_voorwiel);
			if(_achterwiel) remove(_achterwiel);
			
			if(_chassisImage) removeChild(_chassisImage);
			if(_voorwielImage) removeChild(_voorwielImage);
			if(_achterwielImage) removeChild(_achterwielImage);
		}
		
		private function showHelp(e:Event):void
		{
			_howTo = new HowTo();
			_howTo.x = 512 - (_howTo.width * .5);
			_howTo.y = 384 - (_howTo.height * .5);
			_howTo.alpha = 0;
			addChild(_howTo);
			
			TweenLite.to(_howTo, .5, {alpha: 1});
		}
		
		private function hideHelp(e:Event):void
		{
			TweenLite.to(_howTo, .5, {alpha: 0, onComplete: onTweenComplete});
		}
		
		private function onTweenComplete(e:Event=null):void
		{
			if(_howTo && _howTo != null){
				removeChild(_howTo);
			}	
		}
	}
}