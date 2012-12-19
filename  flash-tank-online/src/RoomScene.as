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
		private var mRoomID:int;
		
		private var mListUser:Vector.<UserRoom>;
		
        public function RoomScene(id:int, roomName:String, password:String)
        {	
			mListUser = new Vector.<UserRoom>();
			mRoomID = id;
			mBackground = ResourceManager.getInstance().getImage(ResourceDefine.TEX_ROOM_BACKGROUND);
			addChild(mBackground);
			
			mBtnStart = new Button(ResourceManager.getInstance().getTexture(ResourceDefine.TEX_BTN_START_1), "", ResourceManager.getInstance().getTexture(ResourceDefine.TEX_BTN_START_1));
			mBtnStart.x = 230;
			mBtnStart.y = 500;
			mBtnStart.addEventListener(Event.TRIGGERED, onStart);
			addChild(mBtnStart);
			
			mBtnExit = new Button(ResourceManager.getInstance().getTexture(ResourceDefine.TEX_BTN_EXIT_1), "", ResourceManager.getInstance().getTexture(ResourceDefine.TEX_BTN_EXIT_1));
			mBtnExit.x = 530;
			mBtnExit.y = 493;
			mBtnExit.addEventListener(Event.TRIGGERED, onExit);
			addChild(mBtnExit);
        }
		
		private function onStart(event:Event):void
		{
			
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
		}
		
		public function updateUser():void
		{
			var startX:int = 70;
			var startY:int = 125;
			for (var i:int = 0; i < mListUser.length; i++)
			{
				addChild(mListUser[i]);
				mListUser[i].x = (i % 2 == 0) ? 70 : 430;
				mListUser[i].y = startY;
				
				startY += (i % 2 == 1) ? 50 : 0;
			}
		}
	}
}