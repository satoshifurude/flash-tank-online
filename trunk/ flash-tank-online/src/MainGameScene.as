package 
{
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
        }

		private function onTouch(event:TouchEvent):void 
		{
			
		}
	}
}