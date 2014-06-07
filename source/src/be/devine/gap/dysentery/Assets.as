package be.devine.gap.dysentery
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets
	{
		private static var gameBitmaps:Dictionary = new Dictionary();
		
		private static var gameTextures:Dictionary = new Dictionary();
		private static var gameTextureAtlas:TextureAtlas;
		
		// Game Texture Atlas
		[Embed(source="../../../../assets/graphics/spritesheet.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGame:Class;
		
		[Embed(source="../../../../assets/graphics/spritesheet.png")]
		public static const AtlasTextureGame:Class;
		
		// Large Files		
		[Embed(source="../../../../assets/graphics/bgWelcome.png")]
		public static const BgWelcome:Class;

		[Embed(source="../../../../assets/graphics/bgGame.png")]
		public static const BgGame:Class;
		
		[Embed(source="../../../../assets/graphics/bgGameCows.png")]
		public static const BgGameCows:Class;
		
		[Embed(source="../../../../assets/graphics/bgGameMill.png")]
		public static const BgGameMill:Class;
		
		[Embed(source="../../../../assets/graphics/bgGameGrass.png")]
		public static const BgGameGrass:Class;
		
		[Embed(source="../../../../assets/graphics/bgGamePaaltjes.png")]
		public static const BgGamePaaltjes:Class;
		
		[Embed(source="../../../../assets/graphics/bgGameComplete.png")]
		public static const BGGameComplete:Class;
		
		[Embed(source="../../../../assets/graphics/bgGameHelp.png")]
		public static const BGGameHelp:Class;
		
		// Fonts
		[Embed(source="../../../../assets/fonts/FrizQuadrataStd-Bold.otf", fontFamily="frizQuadrataBold", embedAsCFF="false")]
		public static var FrizQuadrataBold:Class;

		[Embed(source="../../../../assets/fonts/FrizQuadrataStd.otf", fontFamily="frizQuadrata", embedAsCFF="false")]
		public static var FrizQuadrata:Class;
		
		// Methods
		public static function getTexture(name:String):Texture
		{
			if (gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name];
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			
			return gameTextures[name];
		}
		
		public static function getAtlas():TextureAtlas
		{
			if(gameTextureAtlas == null){
				var texture:Texture = getTexture("AtlasTextureGame");
				var xml:XML = new XML(new AtlasXmlGame());
				gameTextureAtlas = new TextureAtlas(texture,xml);
			}
			return gameTextureAtlas;
		}
	}
}