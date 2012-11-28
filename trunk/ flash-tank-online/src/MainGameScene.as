package 
{
	import starling.core.Starling;
    import starling.display.*;
    import starling.textures.*;
	import starling.events.*;

    public class MainGameScene extends Sprite
    {
		public static var mInstance:MainGameScene;
        public var mMapTiled:MapTiled;
		
        public function MainGameScene()
        {
			mInstance = this;
			mMapTiled = new MapTiled();
			addChild(mMapTiled);
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        }
		
		public static function getInstance():MainGameScene
		{
			return mInstance;
		}

		private function onKeyDown(event:KeyboardEvent):void 
		{
			switch (event.keyCode)
			{
				case GameKey.KEY_UP:
					GameKey.m_KEY_UP = true;
					break;
				case GameKey.KEY_DOWN:
					GameKey.m_KEY_DOWN = true;
					break;
				case GameKey.KEY_LEFT:
					GameKey.m_KEY_LEFT = true;
					break;
				case GameKey.KEY_RIGHT:
					GameKey.m_KEY_RIGHT = true;
					break;
				case GameKey.KEY_SPACE:
					GameKey.m_KEY_SPACE = true;
					break;
				default:
					break;
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void 
		{
			switch (event.keyCode)
			{
				case GameKey.KEY_UP:
					GameKey.m_KEY_UP = false;
					break;
				case GameKey.KEY_DOWN:
					GameKey.m_KEY_DOWN = false;
					break;
				case GameKey.KEY_LEFT:
					GameKey.m_KEY_LEFT = false;
					break;
				case GameKey.KEY_RIGHT:
					GameKey.m_KEY_RIGHT = false;
					break;
				case GameKey.KEY_SPACE:
					GameKey.m_KEY_SPACE = false;
					break;
				default:
					break;
			}
		}
	}
}