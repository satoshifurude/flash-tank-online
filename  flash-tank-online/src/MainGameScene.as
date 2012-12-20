package 
{
	import starling.core.Starling;
    import starling.display.*;
    import starling.textures.*;
	import starling.events.*;

    public class MainGameScene extends Sprite
    {
		public static var mInstance:MainGameScene;
        public var mMapTiled:MapTiled;
		public var mUserInfo:UserInfo;
		public var mArrPlayer:Vector.<Tank>;
		public var mArrHeader:Vector.<Header>;
		public var mNumberMainPlayer:int;
		
        public function MainGameScene()
        {
			mInstance = this;
			mArrPlayer = new Vector.<Tank>();
			mArrHeader = new Vector.<Header>();
			mMapTiled = new MapTiled();
			addChild(mMapTiled);
        }
		
		public function addPlayer(tank:Tank):void
		{
			mMapTiled.addPlayer(tank);
			mArrPlayer.push(tank);
		}
		
		public function startGame():void
		{
			for (var i:int = 0; i < mArrPlayer.length; i++)
			{
				if (Game.getInstance().mID == mArrPlayer[i].getID())
				{
					mNumberMainPlayer = i;
					break;
				}
			}
			
			for (i = 0; i < 2; i++)
			{
				var header:Header = new Header(i + 1);
				header.x = mMapTiled.getListPositionHeader()[i].x;
				header.y = mMapTiled.getListPositionHeader()[i].y;
				mMapTiled.addHeader(header);
				mArrHeader.push(header);
			}
			
			mUserInfo = new UserInfo(mArrPlayer[mNumberMainPlayer]);
			mUserInfo.x = GameDefine.WIDTH - mUserInfo.width;
			mUserInfo.y = 0;
			addChild(mUserInfo);
			
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			addEventListener(Event.ENTER_FRAME, onFrame);
			addEventListener(Event.ADDED_TO_STAGE, onStartScene);
		}
		
		private function onStartScene(event:Event):void
		{
			Game.getInstance().sendPlayerState();
		}
		
		private function onFrame(event:EnterFrameEvent):void
		{
			var i:int;
			var j:int;

			getPlayer().update(event.passedTime);
			for (i = 0; i < mArrPlayer.length; i++)
			{
				if (mArrPlayer[i] != getPlayer()) mArrPlayer[i].updateOther(event.passedTime);
				mMapTiled.checkCollisionPlayer(mArrPlayer[i]);
			}
			
			for (i = 0; i < BulletManager.getInstance().getArrBullet().length; i++)
			{
				if (BulletManager.getInstance().getArrBullet()[i].isActive())
				{
					BulletManager.getInstance().getArrBullet()[i].update(event.passedTime);
					mMapTiled.checkCollisionPlayer(BulletManager.getInstance().getArrBullet()[i]);
				}
			}
			
			for (i = 0; i < mArrPlayer.length; i++)
			{
				if (mArrPlayer[i].visible == false) continue;
				
				for (j = 0; j < BulletManager.getInstance().getArrBullet().length; j++)
				{
					if (BulletManager.getInstance().getArrBullet()[j].isActive() 
						&& BulletManager.getInstance().getArrBullet()[j].getPlayer() != mArrPlayer[i])
					{
						if (mArrPlayer[i].checkCollisionWithBullet(BulletManager.getInstance().getArrBullet()[j]))
						{
							mArrPlayer[i].damage(BulletManager.getInstance().getArrBullet()[j]);
							BulletManager.getInstance().getArrBullet()[j].explode();
							mUserInfo.updateInfo();
						}
					}
				}
			}
			
			mMapTiled.calcCamera(getPlayer().y + (getPlayer().height >> 1), getPlayer().x + (getPlayer().width >> 1));
		}
		
		
		public function getPlayer():Tank
		{
			return mArrPlayer[mNumberMainPlayer];
		}
		
		public function getUserWithID(id:int):Tank
		{
			for (var i:int = 0; i < mArrPlayer.length; i++)
			{
				// trace("id = " + id);
				// trace("mArrPlayer[i].getID() = " + mArrPlayer[i].getID());
				
				if (id == mArrPlayer[i].getID())
					return mArrPlayer[i];
			}
			return null;
		}
		
		public function disconnect():void
		{
			
		}
		
		public static function getInstance():MainGameScene
		{
			return mInstance;
		}

		private function onKeyDown(event:KeyboardEvent):void 
		{
			switch (event.keyCode)
			{
				case GameKey.KEY_UP:
					GameKey.m_KEY_UP = true;
					break;
				case GameKey.KEY_DOWN:
					GameKey.m_KEY_DOWN = true;
					break;
				case GameKey.KEY_LEFT:
					GameKey.m_KEY_LEFT = true;
					break;
				case GameKey.KEY_RIGHT:
					GameKey.m_KEY_RIGHT = true;
					break;
				case GameKey.KEY_SPACE:
					GameKey.m_KEY_SPACE = true;
					break;
				default:
					break;
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void 
		{
			switch (event.keyCode)
			{
				case GameKey.KEY_UP:
					GameKey.m_KEY_UP = false;
					break;
				case GameKey.KEY_DOWN:
					GameKey.m_KEY_DOWN = false;
					break;
				case GameKey.KEY_LEFT:
					GameKey.m_KEY_LEFT = false;
					break;
				case GameKey.KEY_RIGHT:
					GameKey.m_KEY_RIGHT = false;
					break;
				case GameKey.KEY_SPACE:
					GameKey.m_KEY_SPACE = false;
					break;
				default:
					break;
			}
		}
		
		public function finishGame():void
		{
			removeEventListener(Event.ENTER_FRAME, onFrame);
			removeEventListener(Event.ADDED_TO_STAGE, onStartScene);
			removeFromParent(true);
			Game.getInstance().mRoomScene.visible = true;
		}
	}
}