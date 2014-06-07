package be.devine.gap.dysentery.data
{
	import starling.display.Image;

	public class VehicleVO extends Object
	{
		public var id:uint;
		public var factor:uint;
		public var torqueSpeed:uint;
		public var pointsNeeded:uint;
		
		public var voorwielPosX:uint;
		public var voorwielRadius:uint;
		public var voorwielImage:Image;
		
		public var achterwielPosX:uint;
		public var achterwielRadius:uint;
		public var achterwielImage:Image;

		public var chassisPosX:uint;
		public var chassisWidth:uint;
		public var chassisHeight:uint;
		public var chassisImage:Image;
	}
}