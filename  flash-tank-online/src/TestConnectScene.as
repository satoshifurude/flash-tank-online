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
				
			Security.loadPolicyFile("xmlsocket://192.168.1.3:5554");
			Game.getInstance().mSocket = new CSockConnection("192.168.1.3", 5555);
			Game.getInstance().mSocket.Connect();
        }
		
		public function disconnect():void
		{
			mTitle.text = "Cannot connect to server!!!";
		}
	}
}	