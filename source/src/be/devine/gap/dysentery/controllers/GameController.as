package be.devine.gap.dysentery.controllers
{			
	import be.devine.gap.dysentery.constants.Settings;
	import be.devine.gap.dysentery.constants.Views;
	import be.devine.gap.dysentery.events.FacebookEvent;
	import be.devine.gap.dysentery.events.GameEvent;
	import be.devine.gap.dysentery.models.AppModel;
	import be.devine.gap.dysentery.models.UserModel;
	
	import flash.events.EventDispatcher;
	
	public class GameController extends EventDispatcher
	{
		// Properties		
		private static var instance:GameController;
		
		private var _score:uint = 0;
				
		// Instance + Constructor
		public static function getInstance():GameController{
			if(instance == null) instance = new GameController(new Enforcer());
			return instance;
		}
		
		public function GameController(e:Enforcer){
			if(e == null) throw new Error("GameController is a Singleton and cannot be instantiated");
		}
		
		// Methods
		public function init():void
		{
			AppModel.getInstance().initVehicles();
		}
		
		public function updateTemporaryScore(points:uint):void{
			score += points;
		}
		
		public function updateScore(points:Number):void
		{
			// Oude score opslaan
			var _oudeScore:uint = UserModel.getInstance()._currentUser.score;
			
			// Update the score
			score += points;
			UserModel.getInstance()._currentUser.score += score;
			
			var _nieuweScore:uint = UserModel.getInstance()._currentUser.score;
							
			// Facebook message
			createFacebookMessage(_oudeScore, _nieuweScore);
			
			// Check points needed for next vehicle
			checkHowManyPointsNeededForNextVehicle(_nieuweScore);
						
			// Save score && current vehicle to database
			if(UserModel.getInstance()._currentUser.isRegistered){
				UserModel.getInstance().saveScoreToDatabase();			
			}
			
			// Reset score
			resetScore();	
		}
		
		private function createFacebookMessage(_oudeScore:uint, _nieuweScore:uint):void{
			var data:Object = {};
			data.name = "Hillbilly Bob";
			if(_oudeScore < 250 && _nieuweScore >= 250){
				UserModel.getInstance()._currentUser.vehicle = 2;
				if(UserModel.getInstance()._currentUser.isRegistered){
					data.message = String("I scored " + _score + " points and unlocked the Hillbilly Bob pick-up truck!");
					data.link = String("http://student.howest.be/mathieu.decoene/3DEV/GAP/DYSENTERY/?ref=" + UserModel.getInstance()._currentUser.username);
					data.picture = Settings.THUMB_PICKUP;
					data.description = "Join me now and start your Hillbilly Bob roadkill!";					
					dispatchEvent(new FacebookEvent(FacebookEvent.POST_TO_WALL, data));	
				}					
			}else if(_oudeScore < 2000 && _nieuweScore >= 2000){
				UserModel.getInstance()._currentUser.vehicle = 3;
				if(UserModel.getInstance()._currentUser.isRegistered){
					data.message = String("I scored " + _score + " points and unlocked the Hillbilly Bob super pick-up!");
					data.link = String("http://student.howest.be/mathieu.decoene/3DEV/GAP/DYSENTERY/?ref=" + UserModel.getInstance()._currentUser.username);
					data.picture = Settings.THUMB_SUPERPICKUP;
					data.description = "Join me now and start your Hillbilly Bob roadkill!";					
					dispatchEvent(new FacebookEvent(FacebookEvent.POST_TO_WALL, data));	
				}				
			}else if(_oudeScore < 10000 && _nieuweScore >= 10000){
				UserModel.getInstance()._currentUser.vehicle = 4;
				if(UserModel.getInstance()._currentUser.isRegistered){
					data.message = String("I scored " + _score + " points and unlocked the Hillbilly Bob crop duster!");
					data.link = String("http://student.howest.be/mathieu.decoene/3DEV/GAP/DYSENTERY/?ref=" + UserModel.getInstance()._currentUser.username);
					data.picture = Settings.THUMB_SUPERPICKUP;
					data.description = "Join me now and start your Hillbilly Bob roadkill!";					
					dispatchEvent(new FacebookEvent(FacebookEvent.POST_TO_WALL, data));	
				}				
			}	
		}
		
		public function checkHowManyPointsNeededForNextVehicle(_score:uint):String{
			var pointsNeeded:uint = 0;
			var response:String = "Just keep going!";
			if(getUserTotalScore() < 250){
				pointsNeeded = uint(250 - getUserTotalScore());
				response = 'You need ' + uint(pointsNeeded) + ' more ' + pointOrPoints(pointsNeeded) + ' to unlock \nthe Hillbilly Bob pick-up!';
			}else if(getUserTotalScore() >= 250 && getUserTotalScore() < 2000){
				pointsNeeded = uint(2000 - getUserTotalScore());
				response = 'You need ' + uint(pointsNeeded) + ' more ' + pointOrPoints(pointsNeeded) + ' to unlock \nthe Hillbilly Bob super pick-up!';				
			}else if(getUserTotalScore() >= 2000 && getUserTotalScore() < 10000){
				pointsNeeded = uint(10000 - getUserTotalScore());
				response = 'You need ' + uint(pointsNeeded) + ' more ' + pointOrPoints(pointsNeeded) + ' to unlock \nthe Hillbilly Bob super crop duster!';				
			}
			return response;
		}
		
		private function pointOrPoints(_p:uint):String{
			return (_p == 1) ? 'point' : 'points';
		}
		
		public function resetScore():void{
			score = 0;
		}
		
		public function startNewGame():void{
			MainController.getInstance().setActiveView(Views.GAME);
		}
		
		public function getUserTotalScore():uint{
			return UserModel.getInstance()._currentUser.score;
		}
		
		public function currentlyAchievingPoints(points:Number):void{
			dispatchEvent(new GameEvent(GameEvent.ACHIEVING_POINTS, points));
		}

		// Getters & Setters
		public function get score():uint
		{
			return _score;
		}

		public function set score(value:uint):void
		{
			_score = value;
		}
	}
}
internal class Enforcer{}