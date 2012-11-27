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
		private var mArrBullet:Vector.<Bullet>
		
		private var mWidth:int;
		private var mHeight:int;
		
		public function MapTiled()
        {
			mArrTiled = new Vector.<uint>();
			mArrBullet = new Vector.<Bullet>();
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
			mPlayer.update(event.passedTime);
			checkCollisionPlayer(mPlayer);
			
			for (var i:int = 0; i < mArrBullet.length; i++)
			{
				if (mArrBullet[i].mActive)
				{
					mArrBullet[i].update(event.passedTime);
					checkCollisionPlayer(mArrBullet[i]);
				}
			}
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
					texture = null;
					switch (mArrTiled[y * mWidth + x])
					{
						case GameDefine.COLOR_BRICK:
							texture = textureAtlas.getTexture("block_1");
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
					img.name = "" + (y * mWidth + x);
					mMapLayerUnder.addChild(img);
				}
			}
		}
		
		private function checkCollisionPlayer(obj:DisplayObject):void
		{
			var top:int = (obj.y) / GameDefine.CELL_SIZE;
			var bottom:int = (obj.y - 1 + obj.height) / GameDefine.CELL_SIZE;
			var left:int = (obj.x) / GameDefine.CELL_SIZE;
			var right:int = (obj.x - 1 + obj.width) / GameDefine.CELL_SIZE;
			
			if (top < 0 || bottom >= mHeight || left < 0 || right >= mWidth)
			{
				if (obj is Bullet)
				{
					(Bullet)(obj).explode();
				}
				return;
			}
			
			for (var y:int = top; y <= bottom; y++)
			{
				for (var x:int = left; x <= right; x++)
				{
					switch (mArrTiled[y * mWidth + x])
					{
						case GameDefine.COLOR_BRICK:
						case GameDefine.COLOR_STONE:
							if (obj is Tank)
							{
								(Tank)(obj).setPositionCollideWithBlock(x, y);
							}
							else if (obj is Bullet)
							{
								(Bullet)(obj).explode();
								removeBlock(x, y);
							}
							return;
							break;
						case GameDefine.COLOR_TANK:
							
							break;
						default:
							continue;
					}
				}
			}
		}
		
		public function removeBlock(x:int, y:int):void
		{
			var str:String = "" + (y * mWidth + x);
			var dis:DisplayObject = mMapLayerUnder.getChildByName(str);
			if (dis == null) return;
			dis.removeFromParent(true);
			mArrTiled[y * mWidth + x] = GameDefine.COLOR_NONE;
			
			mMapLayerUnder.flatten();
		}
		
		public function removeBullet(bullet:Bullet):void
		{
			var index:int = mArrBullet.indexOf(bullet);
			if (index != -1) mArrBullet[index]  = null;
		}
		
		public function getPlayer():Tank
		{
			return mPlayer;
		}
		
		public function addBullet(bullet:Bullet):void
		{
			mArrBullet.push(bullet);
			mPlayerLayer.addChild(bullet);
		}
    }
}