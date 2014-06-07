package be.devine.gap.dysentery.models
{
	import be.devine.gap.dysentery.constants.Settings;
	import be.devine.gap.dysentery.constants.Views;
	import be.devine.gap.dysentery.controllers.MainController;
	import be.devine.gap.dysentery.data.UserVO;
	import be.devine.gap.dysentery.events.FacebookEvent;
	
	import flash.events.EventDispatcher;
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	public class UserModel extends EventDispatcher
	{
		// Properties
		private static var instance:UserModel;
		
		private var _netConnection:NetConnection;
		
		public var _currentUser:UserVO = null;
		
		// Constructor
		public static function getInstance():UserModel{
			if(instance == null) instance = new UserModel(new Enforcer());
			return instance;
		}
		
		public function UserModel(e:Enforcer){
			if(e == null) throw new Error("UserModel is a Singleton and cannot be instantiated");
		}
			
		// Methods
		
		//-- [START] check if user is already in datbase --// 
		
		public function checkIfUserIsAlreadyInDatabase():void
		{
			trace('[UserModel] checkIfUserIsAlreadyInDatabase');
			var data:Object = {};
			data.email = UserModel.getInstance()._currentUser.email;
			_netConnection = new NetConnection();
			_netConnection.connect(Settings.GATEWAY);
			_netConnection.call("Dysentery.checkIfUserAlreadyExists", new Responder(onCheckUserInDatabaseResponse,onCheckUserInDatabaseFault), data);
		}
		
			private function onCheckUserInDatabaseResponse(response:Object):void
			{	
				// 3.1 USER ZIT AL IN DATABASE
				if(response.success == true){
					
					// => Game kan starten
					trace('[UserModel] onCheckUserInDatabaseResponse : user zit REEDS in database');
					getUserDataFromDatabase();
					
					// 3.2 USER ZIT NOG NIET IN DATABASE					
				}else if(response.success == false){
					
					// => Steek currentUser in database
					trace('[UserModel] onCheckUserInDatabaseResponse : user zit NOG NIET in database');					
					putUserIntoDatabase();					
				}				
			}
			
			private function onCheckUserInDatabaseFault(error:Object):void
			{
				trace('[UserModel] onCheckUserInDatabaseFault');
				if(error && error != null){
					trace(JSON.stringify(error));									
				}
			}
		
		//-- [END] check if user is already in datbase --// 
		
		
		//-- [START] put user into datbase --// 
		
		private function putUserIntoDatabase():void
		{
			trace('[UserModel] putUserIntoDatabase');
			var data:Object = {};
			data.email = UserModel.getInstance()._currentUser.email;		
			data.first_name = UserModel.getInstance()._currentUser.first_name;
			data.last_name = UserModel.getInstance()._currentUser.last_name;
			_netConnection = new NetConnection();
			_netConnection.connect(Settings.GATEWAY);
			_netConnection.call("Dysentery.putUserIntoDatabase", new Responder(onPutUserIntoDatabaseSuccess,onPutUserIntoDatabaseFault), data);
		}
		
			private function onPutUserIntoDatabaseSuccess(response:Object):void
			{
				trace('[UserModel] onPutUserIntoDatabaseReponse: ' + JSON.stringify(response));				
				var data:Object = {};
				data.name = "Hillbilly Bob";
				data.message = "I started playing Hillbilly Bob!";
				data.link = String("http://student.howest.be/mathieu.decoene/3DEV/GAP/DYSENTERY/?ref=" + UserModel.getInstance()._currentUser.username);
				data.picture = Settings.THUMB_TRACTOR;
				data.description = "Join me now and start your Hillbilly Bob roadkill!";					
				dispatchEvent(new FacebookEvent(FacebookEvent.POST_TO_WALL, data));	
				
				MainController.getInstance().setActiveView(Views.GAME);
			}
			
			private function onPutUserIntoDatabaseFault(fault:Object):void
			{
				trace('[UserModel] onPutUserIntoDatabaseFault: ' + JSON.stringify(fault));
			}
		
		//-- [END] put user into datbase --// 
		
		
		//-- [START] get userdata from database --// 
		
		private function getUserDataFromDatabase():void
		{
			trace('[UserModel] getUserDataFromDatabase');
			var data:Object = {};
			data.email = UserModel.getInstance()._currentUser.email;
			_netConnection = new NetConnection();	
			_netConnection.connect(Settings.GATEWAY);
			_netConnection.call('Dysentery.getUserDataFromDatabase', new Responder(onGetUserDataFromDatabaseSuccess, onGetUserDataFromDatabaseFault), data);
		}	
		
			private function onGetUserDataFromDatabaseSuccess(response:Object):void
			{
				trace('[UserModel] getUserDataFromDatabaseSuccess: ' + JSON.stringify(response));				
				if(response != null){
					UserModel.getInstance()._currentUser.score = response.data.score;
					UserModel.getInstance()._currentUser.vehicle = response.data.vehicle;
				}			
				MainController.getInstance().setActiveView(Views.GAME);
			}
			
			private function onGetUserDataFromDatabaseFault(fault:Object):void
			{
				trace('[UserModel] getUserDataFromDatabaseFault: ' + JSON.stringify(fault));	
			}
		
		//-- [END] get userdata from database --//
			
				
		//-- [START] save score to database --// 
			
		public function saveScoreToDatabase():void
		{
			trace('[UserModel] saveScoreToDatabase');
			var data:Object = {};
			data.email = UserModel.getInstance()._currentUser.email;
			data.vehicle = UserModel.getInstance()._currentUser.vehicle;
			data.score = UserModel.getInstance()._currentUser.score;
			_netConnection = new NetConnection();
			_netConnection.connect(Settings.GATEWAY);
			_netConnection.call('Dysentery.saveScoreToDatabase', new Responder(onSaveScoreToDatabaseSucces, onSaveScoreToDatabaseFault), data);
		}
		
			private function onSaveScoreToDatabaseSucces(response:Object):void
			{
				trace('[UserModel] onSaveScoreToDabaseSucces: ' + JSON.stringify(response));
				trace('currentuser: ' + JSON.stringify(UserModel.getInstance()._currentUser));
			}
			
			private function onSaveScoreToDatabaseFault(fault:Object):void
			{
				trace('[UserModel] onSaveScoreToDatabaseFault: ' + JSON.stringify(fault));
			}
			
		//-- [END] save score to database --// 
	}
}

internal class Enforcer{}