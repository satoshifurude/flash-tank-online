package 
{
    import starling.display.*;
	import starling.events.*;
	import starling.textures.Texture;
	import starling.core.Starling;

    public class TestConnectScene extends Sprite
    {
		private var socket:CSockConnection;
        public function TestConnectScene()
        {
			trace("new TestConnectScene");
			socket = new CSockConnection("10.199.40.103", 555);
			socket.Connect();
        }
	}
}	