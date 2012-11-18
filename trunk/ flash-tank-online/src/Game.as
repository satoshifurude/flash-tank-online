package 
{
    import flash.display.Bitmap;
    
    import starling.core.Starling;
    import starling.display.Button;
    import starling.display.Image;
    import starling.display.Sprite;
	import starling.events.*;

    public class Game extends Sprite
    {
        
        public function Game()
        {
			trace("init game");
			ResourceManager.getInstance().loadResource(1);
			ResourceManager.getInstance().addEventListener(ResourceManager.ON_LOAD_COMPLETE, onLoadDone);
        }
		
		private function onLoadDone(e:Event):void
		{
			var image:Image = Image.fromBitmap(ResourceManager.getInstance().getBitmap("ga.png"));
			
			image.x = GameDefine.WIDTH - image.width >> 1;
			image.y = GameDefine.HEIGHT - image.height >> 1;
			addChild(image);
		}
    }
}