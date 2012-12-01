package 
{
	import starling.textures.Texture;
	
    public class ResourceDefine
    {
		[Embed(source="../res/block.xml", mimeType="application/octet-stream")]
        public static const XMLBlock:Class;
		
		[Embed(source="../res/explosion.xml", mimeType="application/octet-stream")]
        public static const XMLExplosion:Class;
		
		[Embed(source="../res/bullet_1.xml", mimeType="application/octet-stream")]
        public static const XMLBullet1:Class;
		
		public static const RES_DIR:String	= "../res/";
		
		public static const TEX_BLOCK:String 		= "block.png";
		public static const XML_BLOCK:String 		= "XMLBlock";
		
		public static const TEX_EXPLOSION:String	= "explosion.png";
		public static const XML_EXPLOSION:String 	= "XMLExplosion";
		public static const SPR_EXPLOSION:String 	= "explosion";
		
		public static const TEX_BULLET_1:String		= "bullet_1.png";
		public static const XML_BULLET_1:String 	= "XMLBullet1";
		public static const SPR_BULLET_1:String 	= "bullet";
		
		public static const TEX_LOGO_SPLASH:String 	= "logo_splash.png";
		
		public static const TEX_LEVEL_DEMO:String = "level_demo.png";
    }
}