package 
{
	import starling.textures.*;
	import starling.display.*;
	import flash.display.BitmapData;
	
    public class MapTiled extends Sprite
    {
		private var mArrTiled:Vector.<uint>;
		private var mWidth:int;
		private var mHeight:int;
		
		public function MapTiled()
        {
			mArrTiled = new Vector.<uint>();
			loadMapFromImage(ResourceDefine.TEX_LEVEL_DEMO);
			generateObject();
			this.flatten();
		}
		
		private function loadMapFromImage(name:String):void
		{
			var value:uint;
			var bmd:BitmapData = ResourceManager.getInstance().getBitmapData(name);
			mWidth = bmd.width;
			mHeight = bmd.height;
			for (var y:int = 0; y < mHeight; y++)
			{
				for (var x:int = 0; x < mWidth; x++)
				{
					value = bmd.getPixel(x, y);
					mArrTiled.push(value);
				}
			}
		}
		
		private function generateObject():void
		{
			var texture:Texture = Texture.fromBitmap(ResourceManager.getInstance().getBitmap(ResourceDefine.TEX_BLOCK));
			var xml:XML = ResourceManager.getInstance().getAtlasXML(ResourceDefine.XML_BLOCK);
			var textureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			var img:Image;
			
			for (var y:int = 0; y < mHeight; y++)
			{
				for (var x:int = 0; x < mWidth; x++)
				{
					trace("x = " + x + ", y = " + y + ", value = " + mArrTiled[y * mWidth + x]);
					switch (mArrTiled[y * mWidth + x])
					{
						case GameDefine.COLOR_BRICK:
							// texture = textureAtlas.getTexture("block_1");
							var brick:Brick = new Brick();
							brick.x = x * GameDefine.CELL_SIZE;
							brick.y = y * GameDefine.CELL_SIZE;
							addChild(brick);
							break;
						case GameDefine.COLOR_STONE:
							// texture = textureAtlas.getTexture("block_2");
							break;
						default:
							continue;
					}
					
					// img = new Image(texture);
					// img.x = x * GameDefine.CELL_SIZE;
					// img.y = y * GameDefine.CELL_SIZE;
					// addChild(img);
				}
			}
		}
    }
}