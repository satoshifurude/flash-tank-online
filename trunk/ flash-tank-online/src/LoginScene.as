package 
{
    import starling.display.*;
	import starling.events.*;
	import starling.textures.Texture;
	import starling.core.Starling;
	import starling.text.TextField;
	import flash.text.TextFormat;

    public class LoginScene extends Sprite
    {
		private var mBackground:Image;
		private var mLoginInfo:Image;
		private var mBtnLogin:Button;
		private var mAccount:flash.text.TextField;
		private var mPassword:flash.text.TextField;
		private var mNotification:TextField;
		
        public function LoginScene()
        {
			mBackground = ResourceManager.getInstance().getImage(ResourceDefine.TEX_LOGIN_BACKGROUND);
			addChild(mBackground);
			
			mLoginInfo = ResourceManager.getInstance().getImage(ResourceDefine.TEX_LOGIN_INFO);
			mLoginInfo.x = 115;
			mLoginInfo.y = 290;
			addChild(mLoginInfo);
			
			mNotification = new TextField(500, 40, "");
			mNotification.fontSize = 24;
			mNotification.color = 0xff0000;
			mNotification.bold = true;
			mNotification.x = GameDefine.WIDTH - mNotification.width >> 1;
			mNotification.y = 200;
			mNotification.touchable = false;
			addChild(mNotification);
			
			var mFontFormat:TextFormat = new TextFormat();
			mFontFormat.size = 24;
			
			mAccount = new flash.text.TextField();
			mAccount.width  = 280;
			mAccount.height = 100;
			mAccount.x = mLoginInfo.x + 200;
			mAccount.y = mLoginInfo.y + 3;
			mAccount.type = "input";
			mAccount.textColor = 0xfff227;
			mAccount.maxChars = 32;
			mAccount.defaultTextFormat = mFontFormat;
			Starling.current.nativeOverlay.addChild(mAccount);
			
			mPassword = new flash.text.TextField();
			mPassword.width  = 280;
			mPassword.height = 100;
			mPassword.x = mLoginInfo.x + 200;
			mPassword.y = mLoginInfo.y + 108;
			mPassword.type = "input";
			mPassword.displayAsPassword = true;
			mPassword.textColor = 0xfff227;
			mPassword.maxChars = 32;
			mPassword.defaultTextFormat = mFontFormat;
			Starling.current.nativeOverlay.addChild(mPassword);
			
			mBtnLogin = new Button(ResourceManager.getInstance().getTexture(ResourceDefine.TEX_LOGIN_BTN_1), "", ResourceManager.getInstance().getTexture(ResourceDefine.TEX_LOGIN_BTN_2));
			mBtnLogin.x = GameDefine.WIDTH - mBtnLogin.width >> 1;
			mBtnLogin.y = 480;
			mBtnLogin.addEventListener(Event.TRIGGERED, onLogin);
			addChild(mBtnLogin);
        }
		
		private function onLogin(event:Event):void
		{
			mNotification.text = "";
			Game.getInstance().sendLogin(mAccount.text, mPassword.text);
		}
		
		public function loginFail():void
		{
			mNotification.text = "Đăng nhập không thành công!";
			
		}
		
		public function loginSuccess():void
		{
			Starling.current.nativeOverlay.removeChild(mAccount);
			Starling.current.nativeOverlay.removeChild(mPassword);
			removeFromParent(true);
			Game.getInstance().addChild(new LoadingScene(GameDefine.ID_MENU_SCENE));
		}
	}
}