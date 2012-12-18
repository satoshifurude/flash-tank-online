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
		private var mPlayer:Tank;
		public var mArrPlayer:Vector.<Tank>;
		public var mNumberMainPlayer:int;
		
		private var mTimeSendState:Number;
		
        public function MainGameScene()
        {
			mInstance = this;
			mArrPlayer = new Vector.<Tank>();
			mMapTiled = new MapTiled();
			addChild(mMapTiled);
			
			mTimeSendState = GameDefine.TIME_SEND_STATE;
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
			
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(event:EnterFrameEvent):void
		{
			var i:int;

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
				for (var j:int = 0; j < BulletManager.getInstance().getArrBullet().length; j++)
				{
					if (BulletManager.getInstance().getArrBullet()[j].isActive() 
						&& BulletManager.getInstance().getArrBullet()[j].getPlayer() != mArrPlayer[i])
					{
						if (mArrPlayer[i].checkCollisionWithBullet(BulletManager.getInstance().getArrBullet()[j]))
						{
							// mArrPlayer[i].explosion();
							BulletManager.getInstance().getArrBullet()[j].explode();
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
	}
}