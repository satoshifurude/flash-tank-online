package 
{
	import starling.textures.Texture;
	
    public class GameKey
    {
		// Define key
		public static const KEY_UP:uint 	= 38;
		public static const KEY_DOWN:uint	= 40;
		public static const KEY_LEFT:uint	= 37;
		public static const KEY_RIGHT:uint	= 39;
		public static const KEY_SPACE:uint	= 32;
		public static const KEY_NUM1:uint	= 49;
		public static const KEY_NUM2:uint	= 50;

		public static var m_KEY_UP:Boolean;
		public static var m_KEY_DOWN:Boolean;
		public static var m_KEY_LEFT:Boolean;
		public static var m_KEY_RIGHT:Boolean;
		public static var m_KEY_SPACE:Boolean;
		
		public static function clearKey():void
		{
			m_KEY_UP = false;
			m_KEY_DOWN = false;
			m_KEY_LEFT = false;
			m_KEY_DOWN = false;
		}
    }
}