package 
{
	import starling.textures.*;
	import starling.display.*;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
    public class MapTiled extends Sprite
    {
		private var mMapLayerUnder:Sprite;
		private var mMapLayerAbove:Sprite;
		private var mPlayerLayer:Sprite;
	
		private var mArrTiled:Vector.<uint>;
		private var mArrPlayerPosition:Vector.<Point>
		private var mArrHeaderPosition:Vector.<Point>
		
		private var mWidth:int;
		private var mHeight:int;
		private var mWidthInPixel:int;
		private var mHeightInPixel:int;
		
		public function MapTiled()
        {
			mArrTiled = new Vector.<uint>();
			mArrPlayerPosition = new Vector.<Point>();
			mArrHeaderPosition = new Vector.<Point>();
			mMapLayerUnder = new Sprite();
			mMapLayerAbove = new Sprite();
			mPlayerLayer = new Sprite();
			
			addChild(mMapLayerUnder);
			addChild(mPlayerLayer);
			addChild(mMapLayerAbove);
			
			loadMapFromImage(ResourceDefine.TEX_LEVEL_DEMO);
			generateObject();
			mMapLayerUnder.flatten();
			mMapLayerAbove.flatten();
			
			// addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		// private function onFrame(event:EnterFrameEvent):void
		// {
			// mPlayer.update(event.passedTime);
			// checkCollisionPlayer(mPlayer);
			
			// for (var i:int = 0; i < BulletManager.getInstance().getArrBullet().length; i++)
			// {
				// if (BulletManager.getInstance().getArrBullet()[i].isActive())
				// {
					// BulletManager.getInstance().getArrBullet()[i].update(event.passedTime);
					// checkCollisionPlayer(BulletManager.getInstance().getArrBullet()[i]);
				// }
			// }  			
			// calcCamera();
		// }
		
		private function loadMapFromImage(name:String):void
		{
			var value:uint;
			var bmd:BitmapData = ResourceManager.getInstance().getBitmapData(name);
			mWidth = bmd.width;
			mHeight = bmd.height;
			mWidthInPixel = mWidth * GameDefine.CELL_SIZE;
			mHeightInPixel = mHeight * GameDefine.CELL_SIZE;
			
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
			var xml:XML = ResourceManager.getInstance().getXML(ResourceDefine.XML_BLOCK);
			var textureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			
			for (var y:int = 0; y < mHeight; y++)
			{
				for (var x:int = 0; x < mWidth; x++)
				{
					if (x % 9 == 0 && y % 9 == 0)
					{
						texture = textureAtlas.getTexture("block_background");
						addTile(texture, x, y, mMapLayerUnder);
					}
					
					texture = null;
					switch (mArrTiled[y * mWidth + x])
					{
						case GameDefine.COLOR_BRICK:
							texture = textureAtlas.getTexture("brick");
							addTile(texture, x, y, mMapLayerUnder);
							break;
						case GameDefine.COLOR_METAL:
							texture = textureAtlas.getTexture("rock");
							addTile(texture, x, y, mMapLayerUnder);
							break;
						case GameDefine.COLOR_WATER:
							texture = textureAtlas.getTexture("water");
							addTile(texture, x, y, mMapLayerUnder);
							break;
						case GameDefine.COLOR_TREE:
							texture = textureAtlas.getTexture("cloud");
							addTile(texture, x, y, mMapLayerAbove);
							break;
						case GameDefine.COLOR_HEADER:
							if (mArrTiled[(y - 1) * mWidth + x - 1] == GameDefine.COLOR_HEADER)
							{
								mArrHeaderPosition.push(new Point(x * GameDefine.CELL_SIZE, y * GameDefine.CELL_SIZE));
							}
							break;
						case GameDefine.COLOR_TANK:
							mArrPlayerPosition.push(new Point(x * GameDefine.CELL_SIZE, y * GameDefine.CELL_SIZE));
							break;
						default:
							continue;
					}
				}
			}
		}
		
		private function addTile(texture:Texture, x:int, y:int, layer:Sprite):void
		{
			if (texture == null) return;
			var img:Image = new Image(texture);
			img.x = x * GameDefine.CELL_SIZE;
			img.y = y * GameDefine.CELL_SIZE;
			img.name = "" + (y * mWidth + x);
			layer.addChild(img);
		}
		
		public function checkCollisionPlayer(obj:DisplayObject):void
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
						case GameDefine.COLOR_WATER:
							if (obj is Tank)
							{
								(Tank)(obj).setPositionCollideWithBlock(x, y);
							}
							break;
						case GameDefine.COLOR_BRICK:
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
						case GameDefine.COLOR_METAL:
							if (obj is Tank)
							{
								(Tank)(obj).setPositionCollideWithBlock(x, y);
							}
							else if (obj is Bullet)
							{
								(Bullet)(obj).explode();
							}
							return;
							break;
						case GameDefine.COLOR_HEADER:
							if (obj is Tank)
							{
								(Tank)(obj).setPositionCollideWithBlock(x, y);
							}
							else if (obj is Bullet)
							{
								for (var i:int = 0; i < 2; i++)
								{
									if (Game.getInstance().mMainGame.mArrHeader[i].checkCollisionWithBullet((Bullet)(obj)))
									{
										Game.getInstance().mMainGame.mArrHeader[i].damage((Bullet)(obj));
										(Bullet)(obj).explode();
										return;
									}
								}
							}
							return;
							break;
						default:
							continue;
					}
				}
			}
		}
		
		public function calcCamera(x:Number, y:Number):void
		{
			var cameraTop:Number = x - GameDefine.CAMERA_PLAYER_DEFAULT_Y;
			var cameraLeft:Number = y - GameDefine.CAMERA_PLAYER_DEFAULT_X;
			
			if (cameraTop < 0) 
				cameraTop = 0;
			else if (cameraTop + GameDefine.HEIGHT > mHeightInPixel)
				cameraTop = mHeightInPixel - GameDefine.HEIGHT;
				
			if (cameraLeft < 0) 
				cameraLeft = 0;
			else if (cameraLeft + GameDefine.WIDTH > mWidthInPixel)
				cameraLeft = mWidthInPixel - GameDefine.WIDTH;
				
			this.x = - cameraLeft;
			this.y = - cameraTop;
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
		
		public function addBullet(bullet:Bullet):void
		{
			mPlayerLayer.addChild(bullet);
		}
		
		public function addPlayer(player:Tank):void
		{
			mPlayerLayer.addChild(player);
		}
		
		public function addHeader(header:Header):void
		{
			mPlayerLayer.addChild(header);
		}
		
		public function getListPosition():Vector.<Point>
		{
			return mArrPlayerPosition;
		}
		
		public function getListPositionHeader():Vector.<Point>
		{
			return mArrHeaderPosition;
		}
    }
}