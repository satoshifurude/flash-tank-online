package 
{
    import starling.display.*;
	import starling.events.*;
	import starling.textures.Texture;
	import starling.core.Starling;

    public class RoomScene extends Sprite
    {
		private var mBackground:Image;
		private var mIconTankRed:Image;
		private var mIconTankBlue:Image;
		
		private var mBtnStart:Button;
		private var mBtnExit:Button;
		private var mBtnChangeSide:Button;
		private var mRoomID:int;
		private var mUserRoom:UserRoom;
		private var mIsOwner:Boolean;
		
		private var mListUser:Vector.<UserRoom>;
		
        public function RoomScene(id:int, roomName:String, password:String)
        {	
			mListUser = new Vector.<UserRoom>();
			mRoomID = id;
			mBackground = ResourceManager.getInstance().getImage(ResourceDefine.TEX_ROOM_BACKGROUND);
			addChild(mBackground);
			
			mBtnStart = new Button(ResourceManager.getInstance().getTexture(ResourceDefine.TEX_BTN_START_1), "", ResourceManager.getInstance().getTexture(ResourceDefine.TEX_BTN_START_1));
			mBtnStart.x = 200;
			mBtnStart.y = 500;
			mBtnStart.addEventListener(Event.TRIGGERED, onStart);
			addChild(mBtnStart);
			
			mBtnChangeSide = new Button(ResourceManager.getInstance().getTexture(ResourceDefine.TEX_BTN_CHANGE_1), "", ResourceManager.getInstance().getTexture(ResourceDefine.TEX_BTN_CHANGE_1));
			mBtnChangeSide.x = 380;
			mBtnChangeSide.y = 500;
			mBtnChangeSide.addEventListener(Event.TRIGGERED, onChangeSide);
			addChild(mBtnChangeSide);
			
			mBtnExit = new Button(ResourceManager.getInstance().getTexture(ResourceDefine.TEX_BTN_EXIT_1), "", ResourceManager.getInstance().getTexture(ResourceDefine.TEX_BTN_EXIT_1));
			mBtnExit.x = 560;
			mBtnExit.y = 493;
			mBtnExit.addEventListener(Event.TRIGGERED, onExit);
			addChild(mBtnExit);
			
			mIconTankBlue = ResourceManager.getInstance().getImage(ResourceDefine.TEX_TANK_BLUE);
			mIconTankBlue.rotation = Math.PI * 3 / 2;
			mIconTankBlue.x = 210;
			mIconTankBlue.y = 90;
			addChild(mIconTankBlue);
			
			mIconTankRed = ResourceManager.getInstance().getImage(ResourceDefine.TEX_TANK_RED);
			mIconTankRed.rotation = Math.PI * 3 / 2;
			mIconTankRed.x = 575;
			mIconTankRed.y = 90;
			addChild(mIconTankRed);
        }
		
		private function onStart(event:Event):void
		{
			if (mIsOwner)
			{
				if (mListUser.length == 1 || mListUser.length == 3)
				{
					// 
					return;
				}
				
				if (!isSideBalance())
				{
					// not balance
					return;
				}
				
				for (var i:int = 0; i < mListUser.length; i++)
				{
					if (!mListUser[i].getReady() && !mListUser[i].isKey())
					{	
						// not ready all
						return;
					}
				}
				
				Game.getInstance().sendStartGame();
			}
			else
			{
				mUserRoom.setReady(!mUserRoom.getReady());
				Game.getInstance().sendReady(mUserRoom.getReady());
			}
		}
		
		private function onChangeSide(event:Event):void
		{
			if (!mUserRoom.getReady())
			{
				Game.getInstance().sendChangeSide(mUserRoom.getSide() == GameDefine.SIDE_BLUE ? GameDefine.SIDE_RED : GameDefine.SIDE_BLUE);
			}
		}
		
		private function onExit(event:Event):void
		{
			Game.getInstance().sendLeaveRoom(mRoomID);
			removeFromParent(true);
			Game.getInstance().addChild(new LoadingScene(GameDefine.ID_ROOM_LIST_SCENE));
		}
		
		public function clearListUser():void
		{
			while (mListUser.length > 0)
			{
				var user:UserRoom  = mListUser.pop();
				user.removeFromParent(true);
				user = null;
			}
		}
		
		public function addUser(user:UserRoom):void
		{
			mListUser.push(user);
			if (user.getID() == Game.getInstance().mID)
				mUserRoom = user;
		}
		
		public function removeUser(userID:int):void
		{
			var user:UserRoom = getUserWithID(userID);
			var index:int = mListUser.indexOf(user);
			user.removeFromParent(true);
			user = null;
			mListUser.splice(index, 1);
		}
		
		public function getUserWithID(userID:int):UserRoom
		{
			for (var i:int = 0; i < mListUser.length; i++)
			{
				if (mListUser[i].getID() == userID)
					return mListUser[i];
			}
			return null;
		}
		
		public function updateUser():void
		{
			var mSideBlue:int = 0
			var mSideRed:int = 0
			
			for (var i:int = 0; i < mListUser.length; i++)
			{
				if (!this.contains(mListUser[i])) 
					this.addChild(mListUser[i]);
				var slotY:int = mListUser[i].getSide() % 4;
				
				if (mListUser[i].getSide() == GameDefine.SIDE_BLUE)
				{
					mListUser[i].x = 70;
					mListUser[i].y = 125 + mSideBlue * 100;
					mSideBlue++;
				}
				else
				{
					mListUser[i].x = 430;
					mListUser[i].y = 125 + mSideRed * 100;
					mSideRed++;
				}
			}
		}
		
		public function setReady(userID:int, bool:Boolean):void
		{
			for (var i:int = 0; i < mListUser.length; i++)
			{
				if (mListUser[i].getID() == userID)
				{
					mListUser[i].setReady(bool);
					return;
				}
			}
		}
		
		public function clearReady():void
		{
			for (var i:int = 0; i < mListUser.length; i++)
			{
				mListUser[i].setReady(false);
			}
		}
		
		public function setUserSide(userID:int, side:int):void
		{
			for (var i:int = 0; i < mListUser.length; i++)
			{
				if (mListUser[i].getID() == userID)
				{
					mListUser[i].setSide(side);
					return;
				}
			}
		}
		
		public function setOwner(bool:Boolean):void
		{
			mIsOwner = bool;
		}
		
		public function isSideBalance():Boolean
		{
			var mSideBlue:int = 0
			var mSideRed:int = 0
			
			for (var i:int = 0; i < mListUser.length; i++)
			{
				if (mListUser[i].getSide() == GameDefine.SIDE_BLUE)
					mSideBlue++;
				else
					mSideRed++;
			}
			
			if (mSideBlue == mSideRed) return true;
			return false;
		}
		
		public function getRoomID():int
		{
			return mRoomID;
		}
	}
}