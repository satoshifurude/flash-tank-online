package 
{
    import flash.events.*;
	import flash.net.*;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import starling.display.Sprite;
	import starling.text.TextField;

    public class TestConnectScene extends Sprite
    {
		private var mTitle:TextField;
        public function TestConnectScene()
        {
			mTitle = new TextField(800, 300, "Connecting to server...", "Verdana", 40, 0xffffff, true);
			mTitle.x = 0;
			mTitle.y = GameDefine.HEIGHT - mTitle.height >> 1;
			addChild(mTitle);
				
			Security.loadPolicyFile("xmlsocket://127.0.0.1:5554");
			Game.getInstance().mSocket = new CSockConnection("127.0.0.1", 8080);
			Game.getInstance().mSocket.Connect();
        }
	}
}	