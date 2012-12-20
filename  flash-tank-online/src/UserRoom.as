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
		private var mUserID:int;
		private var mSide:int;
		
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
			mFrameKey.x = 304;
			mFrameKey.y = 1;
			mFrameKey.visible = false;
			addChild(mFrameKey);
			
			mFrameReady = ResourceManager.getInstance().getImage(ResourceDefine.TEX_ICON_READY);
			mFrameReady.x = 304;
			mFrameReady.y = 1;
			mFrameReady.visible = false;
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
        }
		
		public function setKey(bool:Boolean):void
		{
			mFrameKey.visible = bool;
		}
		
		public function isKey():Boolean
		{
			return mFrameKey.visible;
		}
		
		public function setReady(bool:Boolean):void
		{
			mFrameReady.visible = bool;
		}
		
		public function getReady():Boolean
		{
			return mFrameReady.visible;
		}
		
		public function setMyUser(bool:Boolean):void
		{
			mBackground.visible = bool;
		}
		
		public function getID():int
		{
			return mUserID;
		}
		
		public function setSide(side:int):void
		{
			mSide = side;
		}
		
		public function getSide():int
		{
			return mSide;
		}
		
		public function getName():String
		{
			return mUsername.text;
		}
	}
}