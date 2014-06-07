package be.devine.gap.dysentery.factories
{
	import be.devine.gap.dysentery.data.UserVO;
	import be.devine.gap.dysentery.data.VehicleVO;
	
	import starling.display.Image;

	public class VOFactory
	{
		public static function createUserVO(userData:Object, accessToken:String):UserVO
		{
			var user:UserVO = new UserVO();
			user.username = userData.username;
			user.first_name = userData.first_name;
			user.last_name = userData.last_name;
			user.email = userData.email;
			user.accessToken = accessToken;
			return user;
		}
		
		public static function createRankingUser(first_name:String, last_name:String, score:uint):Object
		{
			var user:Object = {};
			user.first_name = first_name;
			user.last_name = last_name;
			user.score = score;
			return user;
		}
		
		public static function createVehicleVO(_id:uint, _factor:Number, _torqueSpeed:uint, _pointsNeeded:uint, _voorwielPosX:uint, _voorwielRadius:uint, _voorwielImage:Image, _achterwielPosX:uint, _achterwielRadius:uint, _achterwielImage:Image, _chassisPosX:uint, _chassisWidth: uint, _chassisHeight:uint, _chassisImage:Image):VehicleVO
		{
			var vehicle:VehicleVO = new VehicleVO();
			
			vehicle.id = _id;
			vehicle.factor = _factor;
			vehicle.torqueSpeed = _torqueSpeed;
			vehicle.pointsNeeded = _pointsNeeded;
			
			vehicle.voorwielPosX = _voorwielPosX;
			vehicle.voorwielRadius = _voorwielRadius;
			vehicle.voorwielImage = _voorwielImage;
			
			vehicle.achterwielPosX = _achterwielPosX;
			vehicle.achterwielRadius = _achterwielRadius;
			vehicle.achterwielImage = _achterwielImage;
			
			vehicle.chassisPosX = _chassisPosX;
			vehicle.chassisWidth = _chassisWidth;
			vehicle.chassisHeight = _chassisHeight;
			vehicle.chassisImage = _chassisImage;
			
			return vehicle;
		}
	}
}