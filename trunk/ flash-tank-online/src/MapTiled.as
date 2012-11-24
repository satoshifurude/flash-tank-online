package 
{
	import starling.textures.*;
	import starling.display.*;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import flash.display.BitmapData;
	
    public class MapTiled extends Sprite
    {
		private var mMapLayerUnder:Sprite;
		private var mMapLayerAbove:Sprite;
		private var mPlayerLayer:Sprite;
	
		private var mArrTiled:Vector.<uint>;
		private var mPlayer:Tank;
		private var mWidth:int;
		private var mHeight:int;
		
		public function MapTiled()
        {
			mArrTiled = new Vector.<uint>();
			mMapLayerUnder = new Sprite;
			mMapLayerAbove = new Sprite;
			mPlayerLayer = new Sprite;
			
			addChild(mMapLayerUnder);
			addChild(mPlayerLayer);
			addChild(mMapLayerAbove);
			
			loadMapFromImage(ResourceDefine.TEX_LEVEL_DEMO);
			generateObject();
			mMapLayerUnder.flatten();
			mMapLayerAbove.flatten();
			
			addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(event:EnterFrameEvent):void
		{
			mPlayer.move(event.passedTime);
			checkCollisionPlayer();
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
					// trace("x = " + x + ", y = " + y + ", value = " + mArrTiled[y * mWidth + x]);
					texture = null;
					switch (mArrTiled[y * mWidth + x])
					{
						case GameDefine.COLOR_BRICK:
							texture = textureAtlas.getTexture("block_1");
							// var brick:Brick = new Brick();
							// brick.x = x * GameDefine.CELL_SIZE;
							// brick.y = y * GameDefine.CELL_SIZE;
							// brick.flatten();
							// addChild(brick);
							break;
						case GameDefine.COLOR_STONE:
							texture = textureAtlas.getTexture("block_2");
							break;
						case GameDefine.COLOR_TANK:
							mPlayer = new Tank();
							mPlayer.x = x * GameDefine.CELL_SIZE;
							mPlayer.y = y * GameDefine.CELL_SIZE;
							mPlayerLayer.addChild(mPlayer);
							break;
						default:
							continue;
					}
					
					if (texture == null) continue;
					img = new Image(texture);
					img.x = x * GameDefine.CELL_SIZE;
					img.y = y * GameDefine.CELL_SIZE;
					mMapLayerUnder.addChild(img);
				}
			}
		}
		
		private function checkCollisionPlayer():void
		{	
			var top:int = (mPlayer.y) / GameDefine.CELL_SIZE;
			var bottom:int = (mPlayer.y - 1 + mPlayer.getHeight()) / GameDefine.CELL_SIZE;
			var left:int = (mPlayer.x) / GameDefine.CELL_SIZE;
			var right:int = (mPlayer.x - 1 + mPlayer.getWidth()) / GameDefine.CELL_SIZE;
			
			for (var y:int = top; y <= bottom; y++)
			{
				for (var x:int = left; x <= right; x++)
				{
					switch (mArrTiled[y * mWidth + x])
					{
						case GameDefine.COLOR_BRICK:
						case GameDefine.COLOR_STONE:
							mPlayer.setPositionCollideWithBlock(x, y);
							return;
						case GameDefine.COLOR_TANK:
							
							break;
						default:
							continue;
					}
				}
			}
		}
		
		public function getPlayer():Tank
		{
			return mPlayer;
		}
    }
}