package 
{
	import starling.textures.Texture;
	
    public class GameDefine
    {
        public static const WIDTH:Number 		= 800;
		public static const HEIGHT:Number		= 600;
		public static const CELL_SIZE:int	= 45;
	
		public static const ID_SPLASH_SCENE:int 	= 1;
		public static const ID_MAIN_SCENE:int		= 2;
		public static const ID_MENU_SCENE:int		= 3;
		public static const ID_TEST_SCENE:int		= 4;
		public static const ID_CONNECT_SCENE:int	= 5;
		public static const ID_LOGIN_SCENE:int		= 6;
		
		public static const COLOR_NONE:int		= 0xFFFFFF;
		public static const COLOR_BRICK:int		= 0xED1C24;
		public static const COLOR_TANK:int		= 0x3F48CC;
		public static const COLOR_METAL:int		= 0x0;
		public static const COLOR_WATER:int		= 0x00A2E8;
		public static const COLOR_TREE:int		= 0x22B14C;
		public static const COLOR_HEADER:int	= 0xA349A4;
		
		//Define tank
		public static const SIDE_RED:int 	= 1;
		public static const SIDE_BLUE:int 	= 2;
		
		
		public static const TANK_SPEED:Number		= 200;
		public static const BULLET_SPEED:Number		= 300;
		public static const MAX_BULLET:Number		= 0.5;
		public static const MAX_RANGE_BULLET:Number	= 700;
		public static const TIME_SEND_STATE:Number	= 0.1;
		
		public static const UP:int		= 1;
		public static const DOWN:int	= 2;
		public static const LEFT:int	= 3;
		public static const RIGHT:int	= 4;
		
		public static const CAMERA_PLAYER_DEFAULT_X:Number	= 400;
		public static const CAMERA_PLAYER_DEFAULT_Y:Number	= 400;
		
		public static const EVENT_CONNECT_SUCCESS:String	= "EVENT_CONNECT_SUCCESS";
    }
}