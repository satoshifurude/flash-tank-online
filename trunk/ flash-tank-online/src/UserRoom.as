package 
{
    import starling.display.*;
	import starling.events.*;
	import starling.textures.Texture;
	import starling.core.Starling;
	import starling.text.TextField;

    public class UserRoom extends Sprite
    {
		private var mBackground:Image;
		private var mFrame:Image;
		private var mFrameKey:Image;
		private var mFrameReady:Image;
		private var mUsername:TextField;
		private var mWinRate:TextField;
		private var mIsKey:Boolean = false;
		private var mIsReady:Boolean = false;
		private var mUserID:int;
		
        public function UserRoom(userID:int, name:String)
        {
			mUserID = userID;
			mBackground = ResourceManager.getInstance().getImage(ResourceDefine.TEX_ROOM_FRAME_BG);
			mBackground.visible = false;
			addChild(mBackground);
			
			mFrame = ResourceManager.getInstance().getImage(ResourceDefine.TEX_USER_FRAME);
			mFrame.x = 2;
			mFrame.y = 2;
			addChild(mFrame);
			
			mFrameKey = ResourceManager.getInstance().getImage(ResourceDefine.TEX_ICON_KEY);
			mFrameKey.x = 270;
			mFrameKey.y = 1;
			addChild(mFrameKey);
			
			mFrameReady = ResourceManager.getInstance().getImage(ResourceDefine.TEX_ICON_READY);
			mFrameReady.x = 304;
			mFrameReady.y = 1;
			addChild(mFrameReady);
			
			mUsername = new TextField(275, 25, name, "Verdana", 14, 0xffffff, true);
			mUsername.x = 46;
			mUsername.y = 7;
			mUsername.hAlign = "left";
			mUsername.touchable = false
			addChild(mUsername);
			
			mWinRate = new TextField(275, 25, "", "Verdana", 14, 0xffffff, true);
			mWinRate.x = 46;
			mWinRate.y = 45;
			mWinRate.hAlign = "left";
			mWinRate.touchable = false
			addChild(mWinRate);
			
			updateState();
        }
		
		public function setKey(bool:Boolean):void
		{
			mIsKey = bool;
			updateState();
		}
		
		public function setReady(bool:Boolean):void
		{
			mIsReady = bool;
			updateState();
		}
		
		public function setMyUser(bool:Boolean):void
		{
			mBackground.visible = bool
		}
		
		public function getUserID():int
		{
			return mUserID;
		}
		
		private function updateState():void
		{
			mFrameKey.visible = mIsKey;
			mFrameReady.visible = mIsReady;
		}
	}
}