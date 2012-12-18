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
		
		[Embed(source="../res/head_red.xml", mimeType="application/octet-stream")]
        public static const XMLHeaderRed:Class;
		
		[Embed(source="../res/head_blue.xml", mimeType="application/octet-stream")]
        public static const XMLHeaderBlue:Class;
		
		[Embed(source="../res/particle_menu.pex", mimeType="application/octet-stream")]
        public static const ParticleMenu:Class;
		
		public static const RES_DIR:String	= "http://127.0.0.1/res/";
		
		public static const TEX_BLOCK:String 		= "block.png";
		public static const XML_BLOCK:String 		= "XMLBlock";
		
		public static const TEX_EXPLOSION:String	= "explosion.png";
		public static const XML_EXPLOSION:String 	= "XMLExplosion";
		public static const SPR_EXPLOSION:String 	= "explosion";
		
		public static const TEX_BULLET_1:String		= "bullet_1.png";
		public static const XML_BULLET_1:String 	= "XMLBullet1";
		public static const SPR_BULLET_1:String 	= "bullet";
		
		public static const TEX_HEADER_RED:String	= "head_red.png";
		public static const XML_HEADER_RED:String 	= "XMLHeaderRed";
		public static const SPR_HEADER_RED:String 	= "head";
		
		public static const TEX_HEADER_BLUE:String	= "head_blue.png";
		public static const XML_HEADER_BLUE:String 	= "XMLHeaderBlue";
		public static const SPR_HEADER_BLUE:String 	= "head";
		
		public static const TEX_LOGO_SPLASH:String 	= "logo_splash.png";
		
		// MENU
		public static const TEX_MENU_BACKGROUND:String 		= "menu_background.png";
		public static const TEX_LOGIN_BACKGROUND:String 	= "login_background.png";
		public static const TEX_LOGIN_INFO:String 			= "login_info.png";
		public static const TEX_LOGIN_BTN_1:String 			= "login_btn_1.png";
		public static const TEX_LOGIN_BTN_2:String 			= "login_btn_2.png";
		public static const TEX_BTN_PLAY_UP:String 			= "btn_play_up.png";
		public static const TEX_BTN_PLAY_DOWN:String 		= "btn_play_down.png";
		public static const TEX_PARTICLE_MENU:String 		= "particle_menu.png";
		
		public static const XML_PARTICLE_MENU:String 	= "ParticleMenu";
		
		public static const TEX_LEVEL_DEMO:String = "level_1.png";
    }
}