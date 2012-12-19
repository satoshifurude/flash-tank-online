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
		public var mConnectScene:TestConnectScene;
		public var mRoomListScene:RoomListScene;
		public var mRoomScene:RoomScene;
		public var mID:int;
		public var mName:String;
		
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
					handleLoginSuccess(buffer);
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
				case CommandDefine.CMD_CREATE_ROOM_SUCCESS:
					handleCreateRoomSuccess(buffer);
					break;
				case CommandDefine.CMD_GET_LIST_ROOM:
					handleGetListRoom(buffer);
					break;
				case CommandDefine.CMD_JOIN_ROOM_SUCCESS:
					handleJoinRoom(buffer);
					break;
			}
		}
		
		private function handleJoinRoom(buffer:ByteArray):void
		{	
			mRoomListScene.close();
			mRoomListScene = null;
			mRoomScene = new RoomScene(roomID, roomName, "");
			addChild(new LoadingScene(GameDefine.ID_ROOM_SCENE));
			
			var roomNameLength:int;
			var roomName:String;
			var numPlayer:int;
			var roomID:int;
			var ownerID:int;
			var cmd:int = buffer.readShort();
			
			if (cmd == CommandDefine.CMD_JOIN_ROOM_NEWBIE)
			{
				roomID = buffer.readShort();
				ownerID = buffer.readInt();
				roomNameLength = buffer.readShort();
				roomName = buffer.readMultiByte(roomNameLength, "utf-8");
				numPlayer = buffer.readShort();
				for (var i:int = 0; i < numPlayer; i++)
				{
					var userID:int = buffer.readInt();
					var length:int = buffer.readShort();
					var name:String = buffer.readMultiByte(length, "utf-8");
					
					var user:UserRoom = new UserRoom(userID, mName);
					if (ownerID == userID) user.setKey(true);
					else if (mID == userID) user.setMyUser(true);
					mRoomScene.addUser(user);
					
				}
			}
			else
			{
				
			}
			
			mRoomScene.updateUser();
		}
		
		public function sendJoinRoom(roomID:int):void
		{
			var buffer:ByteArray = new ByteArray();
			buffer.writeShort(CommandDefine.CMD_JOIN_ROOM);
			buffer.writeShort(roomID);
			
			mSocket.Write(buffer);
		}
		
		public function sendLeaveRoom(roomID:int):void
		{
			var buffer:ByteArray = new ByteArray();
			buffer.writeShort(CommandDefine.CMD_LEAVE_ROOM);
			buffer.writeShort(roomID);
			
			mSocket.Write(buffer);
		}
		
		private function handleGetListRoom(buffer:ByteArray):void
		{
			if (mRoomListScene == null) return;
			mRoomListScene.clearListRoom();
			
			var numRoom:int = buffer.readShort();
			for (var i:int = 0; i < numRoom; i++)
			{
				var id:int = buffer.readInt();
				var roomNameLength:int = buffer.readShort();
				var roomName:String = buffer.readMultiByte(roomNameLength, "utf-8");
				var ownerLength:int = buffer.readShort();
				var ownerName:String = buffer.readMultiByte(ownerLength, "utf-8");
				var room:Room = new Room(id, roomName, ownerName);
				mRoomListScene.addRoom(room);
			}
			
			mRoomListScene.updateRoom();
		}
		
		public function sendGetListRoom():void
		{
			var buffer:ByteArray = new ByteArray();
			buffer.writeShort(CommandDefine.CMD_GET_LIST_ROOM);
			
			mSocket.Write(buffer);
		}
		
		public function handleLoginSuccess(buffer:ByteArray):void
		{
			mID = buffer.readInt();
			var length:int = buffer.readShort();
			mName = buffer.readMultiByte(length, "utf-8");
		}
		
		private function handleCreateRoomSuccess(buffer:ByteArray):void
		{
			var roomID:int = buffer.readShort();
			var roomNameLength:int = buffer.readShort();
			var roomName:String = buffer.readMultiByte(roomNameLength, "utf-8");
			var passwordLength:int = buffer.readShort();
			var password:String = buffer.readMultiByte(passwordLength, "utf-8");
			
			mRoomListScene.close();
			mRoomListScene = null;
			mRoomScene = new RoomScene(roomID, roomName, password);
			addChild(new LoadingScene(GameDefine.ID_ROOM_SCENE));
			
			var user:UserRoom = new UserRoom(mID, mName);
			user.setKey(true);
			mRoomScene.addUser(user);
			mRoomScene.updateUser();
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
		
		public function sendCreateRoom(name:String, password:String):void
		{
			var buffer:ByteArray = new ByteArray();
			buffer.writeShort(CommandDefine.CMD_CREATE_ROOM);
			buffer.writeShort(name.length);
			buffer.writeMultiByte(name, "utf-8");
			buffer.writeShort(password.length);
			buffer.writeMultiByte(password, "utf-8");
			
			mSocket.Write(buffer);
		}
	}
}