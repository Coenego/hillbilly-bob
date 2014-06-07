package be.devine.gap.dysentery.models
{
	import be.devine.gap.dysentery.constants.Settings;
	import be.devine.gap.dysentery.events.UserEvent;
	import be.devine.gap.dysentery.factories.VOFactory;
	
	import com.facebook.graph.Facebook;
	
	import flash.events.EventDispatcher;
	
	public class FacebookModel extends EventDispatcher
	{
		// Properties			
		private static var instance:FacebookModel;
				
		private var _access_token:String = "";		
		
		// Constructor
		public static function getInstance():FacebookModel{
			if(instance == null) instance = new FacebookModel(new Enforcer());
			return instance;
		}
		
		public function FacebookModel(e:Enforcer){
			if(e == null) throw new Error("FacebookModel is a Singleton and cannot be instantiated");
		}
		
		// Methods
		
		//-- [START] facebook init --// 
		
		public function initFacebook():void
		{			
			Facebook.init(Settings.APP_ID, function(response:Object, error:Object):void{				
				if(response != null){
					//trace('[FacebookModel] initFacebook: REEDS AANGEMELD OP FACEBOOK APPLICATIE');
				}else{
					//trace('[FacebookModel] initFacebook: NOG NIET AANGEMELD OP FACEBOOK APPLICATIE');
				}
			});
		}			
		
		//-- [END] facebook init --// 
		
		
		
		//-- [START] login with facebook --// 

		public function loginWithFacebook():void{
			var permissions:Array = ['email','publish_stream'];
			Facebook.login(loginOnFacebookApplicationHandler, {perms:permissions.join(',')});	
		}
		
		private function loginOnFacebookApplicationHandler(success:Object, fail:Object):void
		{			
			if(success){	
				
				_access_token = success.accessToken;					
				var params:Object = null;
				var reqType:String = "GET";				
				Facebook.api("me", function(response:Object, error:Object):void{
					
					if(response != null){														
						
						UserModel.getInstance()._currentUser = VOFactory.createUserVO(response, _access_token);							
						UserModel.getInstance().checkIfUserIsAlreadyInDatabase();
																																				
					}else{
						trace('[FacebookModel] <-- loginOnFacebookApplicationHandler loginReceived fail');
						trace(JSON.stringify(error));
						trace('- - - - - - - - - - - - ->');
					}				
				}, params, reqType);			
			}else{
				trace('[FacebookModel] <-- loginOnFacebookApplicationHandler fail');
				trace(JSON.stringify(fail));
				trace('- - - - - - - - - - - - ->');
			}			
		}
		
		//-- [END] login with facebook --//
		
		
		
		//-- [START] post to wall --// 
			
		public function postToWall(message:Object):void
		{	
			var method:String = "/me/feed/?access_token=" + UserModel.getInstance()._currentUser.accessToken;
			Facebook.api(method, postToWallResponseHandler, message, "POST");			
		}
		
			private function postToWallResponseHandler(response:Object, error:Object):void
			{			
				if(response && response != null){
					trace("[FacebookModel] postToWallResponseHandler success");				
					trace(JSON.stringify(response));				
				}else{
					trace("[FacebookModel] postToWallResponseHandler fail");				
					trace(JSON.stringify(error));				
				}
			}
		
		//-- [END] post to wall --// 
	}
}
internal class Enforcer{};