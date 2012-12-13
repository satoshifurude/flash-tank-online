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
			sendLogin("Nguyen Tan Loc");
		}
		
		public function handleMessage(message:ByteArray):void
		{
			
		}
		
		private function sendLogin(name:String):void
		{
			var buffer:ByteArray = new ByteArray();
			buffer.writeShort(CommandDefine.CMD_LOGIN);
			buffer.writeShort(name.length);
			buffer.writeMultiByte(name, "utf-8");
			
			mSocket.Write(buffer);
		}
	}
}