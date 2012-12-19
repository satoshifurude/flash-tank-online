package 
{
    import starling.display.*;
	import starling.events.*;
	import starling.textures.Texture;
	import starling.core.Starling;
	import starling.text.TextField;
	import flash.text.TextFormat;

    public class CreateRoomPopup extends Sprite
    {
		private var mBackground:Image;
		private var mRoomName:flash.text.TextField;
		private var mPassword:flash.text.TextField;
		private var mBtnAccept:Button;
		private var mBtnCancel:Button;
		
        public function CreateRoomPopup()
        {
			mBackground = ResourceManager.getInstance().getImage(ResourceDefine.TEX_CREATE_ROOM);
			addChild(mBackground);
			
			var mFontFormat:TextFormat = new TextFormat();
			mFontFormat.size = 20;
			
			mRoomName = new flash.text.TextField();
			mRoomName.width  = 240;
			mRoomName.height = 30;
			mRoomName.x = x + 207;
			mRoomName.y = y + 75;
			mRoomName.type = "input";
			mRoomName.textColor = 0x1a64ec;
			mRoomName.maxChars = 100;
			mRoomName.defaultTextFormat = mFontFormat;
			Starling.current.nativeOverlay.addChild(mRoomName);
			
			mPassword = new flash.text.TextField();
			mPassword.width  = 240;
			mPassword.height = 30;
			mPassword.x = x + 207;
			mPassword.y = y + 140;
			mPassword.type = "input";
			mPassword.displayAsPassword = true;
			mPassword.textColor = 0x1a64ec;
			mPassword.maxChars = 10;
			mPassword.defaultTextFormat = mFontFormat;
			Starling.current.nativeOverlay.addChild(mPassword);
			
			mBtnAccept = new Button(ResourceManager.getInstance().getTexture(ResourceDefine.TEX_BTN_ACCEPT_1), "", ResourceManager.getInstance().getTexture(ResourceDefine.TEX_BTN_ACCEPT_2));
			mBtnAccept.x = 109;
			mBtnAccept.y = 191;
			mBtnAccept.addEventListener(Event.TRIGGERED, onAccept);
			addChild(mBtnAccept);
			
			mBtnCancel = new Button(ResourceManager.getInstance().getTexture(ResourceDefine.TEX_BTN_CANCEL_1), "", ResourceManager.getInstance().getTexture(ResourceDefine.TEX_BTN_CANCEL_2));
			mBtnCancel.x = 362;
			mBtnCancel.y = 191;
			mBtnCancel.addEventListener(Event.TRIGGERED, onCancel);
			addChild(mBtnCancel);
        }
		
		private function onAccept(event:Event):void
		{
			// check condition & send create room to server
			Game.getInstance().sendCreateRoom(mRoomName.text, mPassword.text);
		}
		
		private function onCancel(event:Event):void
		{
			close();
		}
		
		public function close():void
		{
			Starling.current.nativeOverlay.removeChild(mRoomName);
			Starling.current.nativeOverlay.removeChild(mPassword);
			removeFromParent(true);
		}
		
		public function calcPosition():void
		{
			mRoomName.x = x + 207;
			mRoomName.y = y + 75;
			mPassword.x = x + 207;
			mPassword.y = y + 140;
		}
	}
}