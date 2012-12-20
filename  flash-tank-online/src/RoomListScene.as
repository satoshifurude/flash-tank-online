package 
{
    import starling.display.*;
	import starling.events.*;
	import starling.textures.Texture;
	import starling.core.Starling;

    public class RoomListScene extends Sprite
    {
		private var mBackground:Image;
		private var mBtnCreateRoom:Button;
		private var mBtnGetListRoom:Button;
		private var mBtnExit:Button;
		private var mCreateRoomPopup:CreateRoomPopup;
		private var mListRoom:Vector.<Room>;
		
        public function RoomListScene()
        {
			mListRoom = new Vector.<Room>();
			mBackground = ResourceManager.getInstance().getImage(ResourceDefine.TEX_ROOM_BACKGROUND);
			addChild(mBackground);
			
			mBtnCreateRoom = new Button(ResourceManager.getInstance().getTexture(ResourceDefine.TEX_BTN_CREATE_ROOM), "", ResourceManager.getInstance().getTexture(ResourceDefine.TEX_BTN_CREATE_ROOM));
			mBtnCreateRoom.x = 50;
			mBtnCreateRoom.y = 515;
			mBtnCreateRoom.addEventListener(Event.TRIGGERED, onCreateRoom);
			addChild(mBtnCreateRoom);
			
			mBtnGetListRoom = new Button(ResourceManager.getInstance().getTexture(ResourceDefine.TEX_BTN_REFRESH_1), "", ResourceManager.getInstance().getTexture(ResourceDefine.TEX_BTN_REFRESH_1));
			mBtnGetListRoom.x = 150;
			mBtnGetListRoom.y = 515;
			mBtnGetListRoom.addEventListener(Event.TRIGGERED, onGetListRoom);
			addChild(mBtnGetListRoom);
			
			mBtnExit = new Button(ResourceManager.getInstance().getTexture(ResourceDefine.TEX_BTN_EXIT_1), "", ResourceManager.getInstance().getTexture(ResourceDefine.TEX_BTN_EXIT_1));
			mBtnExit.x = 250;
			mBtnExit.y = 515;
			mBtnExit.addEventListener(Event.TRIGGERED, onExit);
			addChild(mBtnExit);
			
			Game.getInstance().sendGetListRoom();
        }
		
		public function updateListRoom():void
		{
			
		}
		
		private function onCreateRoom(event:Event):void
		{
			if (mCreateRoomPopup != null)
				mCreateRoomPopup = null;
			mCreateRoomPopup = new CreateRoomPopup();
			mCreateRoomPopup.x = GameDefine.WIDTH - mCreateRoomPopup.width >> 1;
			mCreateRoomPopup.y = GameDefine.HEIGHT - mCreateRoomPopup.height >> 1;
			mCreateRoomPopup.calcPosition();
			addChild(mCreateRoomPopup);
		}
		
		private function onGetListRoom(event:Event):void
		{
			Game.getInstance().sendGetListRoom();
		}

		private function onExit(event:Event):void
		{
			close();
			Game.getInstance().addChild(new LoadingScene(GameDefine.ID_MENU_SCENE));
		}
		
		public function close():void
		{
			if (mCreateRoomPopup != null)
				mCreateRoomPopup.close();
			removeFromParent(true);
		}
		
		public function clearListRoom():void
		{
			while (mListRoom.length > 0)
			{
				var room:Room  = mListRoom.pop();
				room.removeFromParent(true);
				room = null;
			}
		}
		
		public function addRoom(room:Room):void
		{
			mListRoom.push(room);
		}
		
		public function updateRoom():void
		{
			var startX:int = 70;
			var startY:int = 125;
			for (var i:int = 0; i < mListRoom.length; i++)
			{
				addChild(mListRoom[i]);
				mListRoom[i].x = (i % 2 == 0) ? 70 : 430;
				mListRoom[i].y = startY;
				
				startY += (i % 2 == 1) ? 100 : 0;
			}
		}
		
		private function cmpIncrease(roomA:Room, roomB:Room):int
		{
			return 0;
		}
	}
}