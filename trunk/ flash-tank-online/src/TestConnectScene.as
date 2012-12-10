package 
{
    import starling.display.*;
	import starling.events.*;
	import starling.textures.Texture;
	import starling.core.Starling;
	import flash.net.*;
	import flash.system.Security;

    public class TestConnectScene extends Sprite
    {
		private var socket:CSockConnection;
        public function TestConnectScene()
        {
			trace("new TestConnectScene");
			Security.loadPolicyFile("xmlsocket://10.199.40.103:5554");
			socket = new CSockConnection("10.199.40.103", 5555);
			socket.Connect();
        }
	}
}	