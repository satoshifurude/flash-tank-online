package 
{
	import starling.core.Starling;
    import starling.display.*;
    import starling.textures.*;
	import starling.events.*;

    public class MainGameScene extends Sprite
    {
        private var mMapTiled:MapTiled;
        public function MainGameScene()
        {
			mMapTiled = new MapTiled();
			addChild(mMapTiled);
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
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
				default:
					break;
			}
		}
	}
}