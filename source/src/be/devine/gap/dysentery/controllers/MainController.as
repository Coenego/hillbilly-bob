package be.devine.gap.dysentery.controllers
{			
	import be.devine.gap.dysentery.constants.Views;
	import be.devine.gap.dysentery.data.UserVO;
	import be.devine.gap.dysentery.events.FacebookEvent;
	import be.devine.gap.dysentery.events.NavigationEvent;
	import be.devine.gap.dysentery.events.UserEvent;
	import be.devine.gap.dysentery.models.AppModel;
	import be.devine.gap.dysentery.models.FacebookModel;
	import be.devine.gap.dysentery.models.UserModel;
	
	import com.citrusengine.core.CitrusEngine;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class MainController extends EventDispatcher
	{
		// Properties		
		public static const SHOW_HELP:String = "showHelp";
		public static const HIDE_HELP:String = "hideHelp";
		
		private static var instance:MainController;
		
		private var _ce:CitrusEngine;
				
		private var _gameController:GameController;
		
		private var _appModel:AppModel;
		private var _userModel:UserModel;
		private var _facebookModel:FacebookModel;
		
		public var _soundMuted:Boolean = false;
				
		// Instance + Constructor
		public static function getInstance():MainController{
			if(instance == null) instance = new MainController(new Enforcer());
			return instance;
		}
		
		public function MainController(e:Enforcer){
			if(e == null) throw new Error("MainController is a Singleton and cannot be instantiated");
		}
		
		// Methods
		public function init():void
		{
			_ce = CitrusEngine.getInstance();
			_ce.sound.muteAll(_soundMuted);
			
			_gameController = GameController.getInstance();
			_gameController.addEventListener(FacebookEvent.POST_TO_WALL, postToWall, false, 0, true);
			
			_appModel = AppModel.getInstance();

			_userModel = UserModel.getInstance();
			_userModel.addEventListener(FacebookEvent.POST_TO_WALL, postToWall, false, 0, true);

			_facebookModel = FacebookModel.getInstance();
			_facebookModel.addEventListener(UserEvent.USER_LOGGED_IN, userLoggedInHandler, false, 0, true);
			_facebookModel.addEventListener(UserEvent.USER_LOGGED_OUT, userLoggedOutHandler, false, 0, true);
			_facebookModel.initFacebook();
		}
				
		public function loginWithFacebook():void{
			_facebookModel.loginWithFacebook();
		}
		
		public function playWithoutLogin():void{
			var user:UserVO = new UserVO();
			user.score = 0;
			user.vehicle = 1;
			user.username = "Player" + Math.round(Math.random() * 1000);
			user.isRegistered = false;
			_userModel._currentUser = user;
			setActiveView(Views.GAME);
		}
		
		public function postToWall(e:FacebookEvent):void{
			if(e.type == FacebookEvent.POST_TO_WALL && e.message != null){				
				_facebookModel.postToWall(e.message);				
			}
		}
		
		public function setActiveView(view:String):void{
			dispatchEvent(new NavigationEvent(NavigationEvent.VIEW_CHANGE, view));
		}
		
		public function muteSound():void
		{
			_soundMuted = !_soundMuted;			
			_ce.sound.muteAll(_soundMuted);
			if(!_soundMuted) _ce.sound.playSound("tractor", 2);
		}
		
		public function toggleHelp(toggle:Boolean):void
		{
			dispatchEvent(new Event((toggle) ? SHOW_HELP : HIDE_HELP));
		}

		protected function userLoggedInHandler(event:UserEvent):void{
			dispatchEvent(new NavigationEvent(NavigationEvent.VIEW_CHANGE, Views.GAME));
		}
		
		protected function userLoggedOutHandler(event:UserEvent):void{
			dispatchEvent(new NavigationEvent(NavigationEvent.VIEW_CHANGE, Views.WELCOME));			
		}
	}
}
internal class Enforcer{}