package
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;

	public class Assets
	{
		[Embed(source="../assets/graphics/bgLayer1.jpg")]
		private static const LayerBG:Class;
		
		[Embed(source="../assets/graphics/bgWelcome.jpg")]
		private static const WelcomeBG : Class;
		
//		[Embed(sourct="../assets/graphics/myGlyphs.png")];
//		private static const BgWelcome : Class;
		
//		[Embed(sourct="../assets/graphics/mySpritesheet.png")];
//		private static const BgWelcome : Class;
		
		[Embed(source="../assets/graphics/welcome_aboutButton.png")]
		private static const WelcomAboutBtn : Class;
		
		[Embed(source="../assets/graphics/welcome_hero.png")]
		private static const WelcomHero : Class;
		
		[Embed(source="../assets/graphics/welcome_playButton.png")]
		private static const WelcomePlayBtn : Class;
		
		[Embed(source="../assets/graphics/welcome_title.png")]
		private static const WelcomeTittle : Class;
		
		private static var gameTexture: Dictionary = new Dictionary();
//		private static vr
		public static function getTexture(name : String):Texture
		{
			if(gameTexture[name]==undefined)
			{
				var  bitmap:Bitmap = new Assets[name]();
				gameTexture[name] = Texture.fromBitmap(bitmap);
			}
			
			return gameTexture[name];
		}
		
	}
}