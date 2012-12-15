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
		
		public function handleMessage(buffer:ByteArray):void
		{
			var cmd:int = buffer.readShort();
			
			switch (cmd)
			{
				case CommandDefine.CMD_LOGIN_SUCCESS:
					
					break;
				case CommandDefine.CMD_START_GAME_SUCCESS:
					handleStartGame(buffer);
					break;
			}
		}
		
		private function handleStartGame(buffer:ByteArray):void
		{
			// mapID
			// num player
			// ID player (stt)
			// 
			// loop
			//
			// player name
			// player position
			var numPlayer:int;
			var IDMainPlayer:int;
			
			trace("Map ID : " + buffer.readShort());
			numPlayer = buffer.readShort();
			trace("Num Player : " + numPlayer);
			IDMainPlayer = buffer.readShort();
			trace("IDMainPlayer : " + IDMainPlayer);
			
			for (var i:int = 0; i < numPlayer; i++)
			{
				var length:int = buffer.readShort();
				var name:String = buffer.readMultiByte(length, "utf-8");
				var x:int = buffer.readShort();
				var y:int = buffer.readShort();
				
				trace("Player name : " + name);
			}
		}
		
		private function sendLogin(name:String):void
		{
			var buffer:ByteArray = new ByteArray();
			buffer.writeShort(CommandDefine.CMD_LOGIN);
			buffer.writeShort(name.length);
			buffer.writeMultiByte(name, "utf-8");
			
			mSocket.Write(buffer);
		}
		
		private function sendStartGame():void
		{
			var buffer:ByteArray = new ByteArray();
			buffer.writeShort(CommandDefine.CMD_START_GAME);
			buffer.writeShort(1); // num room
			
			mSocket.Write(buffer);
		}
	}
}