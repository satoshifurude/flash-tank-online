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
		public var mMainGame:MainGameScene;
		public var mLoginScene:LoginScene;
		public var mID:int;
		
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
		
		public function handleMessage(buffer:ByteArray):void
		{
			var cmd:int = buffer.readShort();
			
			switch (cmd)
			{
				case CommandDefine.CMD_LOGIN_FAIL:
					mLoginScene.loginFail();
					break;
				case CommandDefine.CMD_LOGIN_SUCCESS:
					mLoginScene.loginSuccess();
					break;
				case CommandDefine.CMD_START_GAME_SUCCESS:
					handleStartGame(buffer);
					break;
				case CommandDefine.CMD_UPDATE_GAME:
					handlePlayerState(buffer);
					break;
				case CommandDefine.CMD_FIRE:
					handleFire(buffer);
					break;
			}
		}
		
		private function handleStartGame(buffer:ByteArray):void
		{
			Game.getInstance().addChild(new LoadingScene(GameDefine.ID_MAIN_SCENE));
			
			// mapID
			// num player
			// 
			// loop
			//
			// player name
			// player position
			var numPlayer:int;
			
			trace("Map ID : " + buffer.readShort());
			numPlayer = buffer.readShort();
			trace("Num Player : " + numPlayer);
			
			for (var i:int = 0; i < numPlayer; i++)
			{
				var id:int = buffer.readInt();
				var length:int = buffer.readShort();
				var name:String = buffer.readMultiByte(length, "utf-8");
				var x:int = buffer.readShort();
				var y:int = buffer.readShort();
				
				var tank:Tank = new Tank(id);
				tank.mName = name;
				tank.x = x;
				tank.y = y;
				
				mMainGame.addPlayer(tank);
				
				trace("id = " + id);
			}
			mID = buffer.readInt();
			mMainGame.startGame();
		}
		
		public function handlePlayerState(buffer:ByteArray):void
		{
			var numPlayer:int = buffer.readShort();
			for (var i:int = 0; i < numPlayer; i++)
			{
				var id:int = buffer.readInt();
				var tank:Tank = mMainGame.getUserWithID(id);
				
				
				var direction:int = buffer.readShort();
				var mIsMoving:int = buffer.readShort();
				var x:int = buffer.readInt();
				var y:int = buffer.readInt();
				
				if (tank != mMainGame.getPlayer())
				{
					tank.mDirection = direction;
					tank.mIsMoving = mIsMoving;
					tank.x = x;
					tank.y = y;
				}
			}
		}
		
		public function sendLogin(username:String, password:String):void
		{
			var buffer:ByteArray = new ByteArray();
			buffer.writeShort(CommandDefine.CMD_LOGIN);
			buffer.writeShort(username.length);
			buffer.writeMultiByte(username, "utf-8");
			buffer.writeShort(password.length);
			buffer.writeMultiByte(password, "utf-8");
			
			mSocket.Write(buffer);
		}
		
		public function sendStartGame():void
		{
			var buffer:ByteArray = new ByteArray();
			buffer.writeShort(CommandDefine.CMD_START_GAME);
			buffer.writeShort(1); // num room
			
			mSocket.Write(buffer);
		}
		
		public function sendPlayerState():void
		{
			var buffer:ByteArray = new ByteArray();
			buffer.writeShort(CommandDefine.CMD_UPDATE_GAME);
			buffer.writeShort(mMainGame.getPlayer().getID());
			buffer.writeShort(mMainGame.getPlayer().getDirection());
			buffer.writeShort(mMainGame.getPlayer().mIsMoving);
			buffer.writeInt(mMainGame.getPlayer().x);
			buffer.writeInt(mMainGame.getPlayer().y);
			
			mSocket.Write(buffer);
		}
		
		public function sendFire(bullet:Bullet):void
		{
			var buffer:ByteArray = new ByteArray();
			buffer.writeShort(CommandDefine.CMD_FIRE);
			buffer.writeShort(CommandDefine.CMD_FIRE);
			buffer.writeInt(mMainGame.getPlayer().getID());
			buffer.writeShort(bullet.getDirection());
			buffer.writeInt(bullet.x);
			buffer.writeInt(bullet.y);
			
			mSocket.Write(buffer);
		}
		
		public function handleFire(buffer:ByteArray):void
		{
			var id:int = buffer.readInt();
			var direction:int = buffer.readShort();
			var x:int = buffer.readInt();
			var y:int = buffer.readInt();
			
			if (id != mMainGame.getPlayer().getID())
			{	
				var tank:Tank = mMainGame.getUserWithID(id);
				var bullet:Bullet = BulletManager.getInstance().createBullet(tank);
				bullet.setDirection(direction);
				bullet.x = x;
				bullet.y = y;
				MainGameScene.getInstance().mMapTiled.addBullet(bullet);
			}
		}
	}
}