package be.devine.gap.dysentery.models
{
	import be.devine.gap.dysentery.Assets;
	import be.devine.gap.dysentery.constants.Settings;
	import be.devine.gap.dysentery.factories.VOFactory;
	
	import flash.events.EventDispatcher;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	
	public class AppModel extends EventDispatcher
	{
		// Properties		
		private static var instance:AppModel;
		
		private var _netConnection:NetConnection;
		
		public var _vehicles:Dictionary;
		
		// Constructor
		public static function getInstance():AppModel{
			if(instance == null) instance = new AppModel(new Enforcer());
			return instance;
		}
		
		public function AppModel(e:Enforcer){
			if(e == null) throw new Error("AppModel is a Singleton and cannot be instantiated");
		}
		
		// Methods
					
		//-- [START] get highscores from database --// 
		
		public function getHighScoresFromDatabase():void{
			trace('[AppModel] getHighScoresFromDatabase');
			var data:Object = {};
			data.limit = 5;
			_netConnection = new NetConnection();
			_netConnection.connect(Settings.GATEWAY);
			_netConnection.call('Dysentery.getHighScores', new Responder(onGetHighScoresFromDatabaseSuccess, onGetHighScoresFromDatabaseFault), data);
		}
		
			private function onGetHighScoresFromDatabaseSuccess(response:Object):void{
				trace('[AppModel] onGetHighScoresFromDatabaseSuccess: ');			
				if(response.success && response.users != null){
					trace(JSON.stringify(response.users));						
				}else{
					trace(response.error);					
				}
			}
			
			private function onGetHighScoresFromDatabaseFault(fault:Object):void{
				trace('[AppModel] onGetHighScoresFromDatabaseFault');
				trace(JSON.stringify(fault));
			}
		
		//-- [END] get highscores from database --// 
			
		
		//-- [START] init vehicles --// 
		
		public function initVehicles():void
		{
			_vehicles = new Dictionary();
			_vehicles['tractor'] = VOFactory.createVehicleVO(1,3,3,0,240,22,new Image(Assets.getAtlas().getTexture('tractor/voorwiel')),70,31,new Image(Assets.getAtlas().getTexture('tractor/achterwiel')),155,230,30,new Image(Assets.getAtlas().getTexture('tractor/chassis')));
			_vehicles['pickup'] = VOFactory.createVehicleVO(2,7.5,10,750,261,30,new Image(Assets.getAtlas().getTexture('pickup/wiel')),70,30,new Image(Assets.getAtlas().getTexture('pickup/wiel')),147,350,30,new Image(Assets.getAtlas().getTexture('pickup/chassis')));
			_vehicles['superpickup'] = VOFactory.createVehicleVO(3,10,25,750,261,30,new Image(Assets.getAtlas().getTexture('pickup/wiel')),70,30,new Image(Assets.getAtlas().getTexture('pickup/wiel')),147,350,30,new Image(Assets.getAtlas().getTexture('superpickup/chassis')));
			_vehicles['cropduster'] = VOFactory.createVehicleVO(4,20,50,750,261,30,new Image(Assets.getAtlas().getTexture('pickup/wiel')),70,30,new Image(Assets.getAtlas().getTexture('pickup/wiel')),147,350,30,new Image(Assets.getAtlas().getTexture('pickup/chassis')));
		}
			
		//-- [END] init vehicles --// 

	}
}
internal class Enforcer{};