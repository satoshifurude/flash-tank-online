package 
{
	import starling.textures.Texture;
	
    public class CommandDefine
    {
		public static const CMD_LOGIN:int      		= 1;
		public static const CMD_LOGIN_FAIL:int      = 10;
		public static const CMD_LOGIN_SUCCESS:int   = 11;
		public static const CMD_CREATE_ROOM:int   	= 2;
		public static const CMD_JOIN_ROOM:int     	= 3;
		public static const CMD_READY:int         	= 4;
		public static const CMD_START_GAME:int    	= 5;
		public static const CMD_START_GAME_SUCCESS:int    	= 51;
		public static const CMD_UPDATE_GAME:int    	= 21;
		public static const CMD_FIRE:int    	= 22;
		public static const CMD_INPUT:int         	= 6;
		public static const CMD_QUIT_GAME:int     	= 7;
		public static const CMD_DISCONNECT:int    	= 8;
		
		public static const INPUT_LEFT:int        	= 1;
		public static const INPUT_RIGHT:int       	= 2;
		public static const INPUT_UP:int          	= 3;
		public static const INPUT_DOWN:int        	= 4;
		public static const INPUT_FIRE:int        	= 5;
		public static const INPUT_SPECIAL_1:int   	= 6;
		public static const INPUT_SPECIAL_2:int   	= 7;
		public static const INPUT_SPECIAL_3:int   	= 8;
		public static const INPUT_SPECIAL_4:int   	= 9;
		public static const INPUT_SPECIAL_5:int   	= 10;
	}
}