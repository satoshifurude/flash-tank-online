package 
{
    import flash.display.Bitmap;
    
    import starling.display.*;
    import starling.textures.*;
	import starling.events.*;

    public class Game extends Sprite
    {
        
        public function Game()
        {
			trace("init game");
			ResourceManager.getInstance().loadResource(1);
			ResourceManager.getInstance().addEventListener(ResourceManager.ON_LOAD_COMPLETE, onLoadDone);
        }
		private var mImg:Image;
		private function onLoadDone(e:Event):void
		{
			var image:Image = Image.fromBitmap(ResourceManager.getInstance().getBitmap("atlas.png"));
			
			image.x = 0;
			image.y = GameDefine.HEIGHT - image.height >> 1;
			addChild(image);
			
			var texture:Texture = Texture.fromBitmap(ResourceManager.getInstance().getBitmap("atlas.png"));
			var xml:XML = ResourceManager.getInstance().getAtlasXML("atlas.xml");
			var textureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			texture = textureAtlas.getTexture("flight_13");
			
			mImg = new Image(texture);
			mImg.x = GameDefine.WIDTH - (mImg.width >> 1);
			mImg.y = GameDefine.HEIGHT - mImg.height >> 1;
			mImg.addEventListener(TouchEvent.TOUCH , onTouch);
			addChild(mImg);
		}
		
		private function onTouch(event:TouchEvent):void {
			var touch:Touch = event.getTouch(this);									
			if (touch == null) 
			{
				return;
			}
			

			if (touch.phase == TouchPhase.BEGAN) 
			{
				
			}
			else if (touch.phase == TouchPhase.MOVED)
			{
				mImg.x += (touch.globalX - touch.previousGlobalX);
				mImg.y += (touch.globalY - touch.previousGlobalY);
			}
		}
	}
}