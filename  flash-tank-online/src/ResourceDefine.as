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
		
		// [Embed(source="particleFirework.pex", mimeType="application/octet-stream")]
		[Embed(source="../res/particle_menu.pex", mimeType="application/octet-stream")]
        public static const ParticleMenu:Class;
		
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
		
		// MENU
		public static const TEX_MENU_BACKGROUND:String 	= "menu_background.png";
		public static const TEX_BTN_PLAY_UP:String 		= "btn_play_up.png";
		public static const TEX_BTN_PLAY_DOWN:String 	= "btn_play_down.png";
		public static const TEX_PARTICLE_MENU:String 	= "particle_menu.png";
		
		public static const XML_PARTICLE_MENU:String 	= "ParticleMenu";
		
		public static const TEX_LEVEL_DEMO:String = "level_demo.png";
    }
}