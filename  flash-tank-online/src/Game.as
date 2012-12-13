package 
{
    import flash.display.Bitmap;
    
    import starling.display.*;
    import starling.textures.*;
	import starling.events.*;
	import flash.utils.*;

    public class Game extends Sprite
    {
        public static var mInstance:Game;
		public var mSocket:CSockConnection;
		
        public function Game()
        {
			mInstance = this;
			addChild(new LoadingScene(GameDefine.ID_CONNECT_SCENE, false));
        }
		
		public static function getInstance():Game
		{
			return mInstance;
		}
		
		public function connectSuccess():void
		{
			this.removeChildren(0, -1, true);
			addChild(new LoadingScene(GameDefine.ID_SPLASH_SCENE, false));
		}
		
		var i:int = 0;
		public function sendTestMessage():void
		{
			var buffer:ByteArray = new ByteArray();
			buffer.writeInt(i);
			mSocket.Write(buffer);
			i++;
		}
		
		public function handleMessage(message:ByteArray):void
		{
			
		}
	}
}