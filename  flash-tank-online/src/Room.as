package 
{
    import starling.display.*;
	import starling.events.*;
	import starling.textures.Texture;
	import starling.core.Starling;
	import starling.text.TextField;

    public class Room extends Sprite
    {
		private var mBackground:Image;
		private var mFrame:Image;
		private var mOwner:TextField;
		private var mRoomName:TextField;
		private var mNumPlayer:TextField;
		private var mRoomID:int;
		
        public function Room(id:int, roomName:String, owner:String, numPlayer:int)
        {
			mRoomID = id;
			mBackground = ResourceManager.getInstance().getImage(ResourceDefine.TEX_ROOM_FRAME_BG);
			mBackground.visible = false;
			addChild(mBackground);
			
			mFrame = ResourceManager.getInstance().getImage(ResourceDefine.TEX_ROOM_FRAME);
			mFrame.x = 2;
			mFrame.y = 2;
			addChild(mFrame);
			
			mOwner = new TextField(275, 25, owner, "Verdana", 14, 0xffffff, true);
			mOwner.x = 46;
			mOwner.y = 7;
			mOwner.hAlign = "left";
			mOwner.touchable = false
			addChild(mOwner);
			
			mRoomName = new TextField(275, 25, id + ". " + roomName, "Verdana", 14, 0xffffff, true);
			mRoomName.x = 46;
			mRoomName.y = 45;
			mRoomName.hAlign = "left";
			mRoomName.touchable = false
			addChild(mRoomName);
			
			mNumPlayer = new TextField(275, 25, numPlayer + "/4", "Verdana", 14, 0xffffff, true);
			mNumPlayer.x = 46;
			mNumPlayer.y = 45;
			mNumPlayer.hAlign = "right";
			mNumPlayer.touchable = false
			addChild(mNumPlayer);
			
			addEventListener(TouchEvent.TOUCH, onTouch);
        }
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(mFrame);
			if (touch == null)
			{
				mBackground.visible = false;
			}
			else
			{
				mBackground.visible = true;
				if (touch.phase == TouchPhase.ENDED)
				{
					Game.getInstance().sendJoinRoom(mRoomID);
				}
			}
		}
		
		public function setPlaying(bool:Boolean):void
		{
			if (bool)
			{
				this.alpha = 0.5;
				this.touchable = false;
			}
			else
			{
				this.alpha = 1.0;
				this.touchable = true;
			}
		}
	}
}