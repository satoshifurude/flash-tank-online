package 
{
    import starling.display.*;
    import starling.textures.*;
	import starling.events.*;

    public class Tank extends Sprite
    {
		private var mLastPositionX:Number;
		private var mLastPositionY:Number;
		private var mDirection:int;
		private var mSpeed:int;
		private var mHp:int;
		private var mImage:Image;
		private var mLayerTank:Sprite;
		private var mNumCurrentBullet:Number;
		
        public function Tank()
        {
			mNumCurrentBullet = 0;
			mSpeed = GameDefine.TANK_SPEED;
			mLayerTank = new Sprite();
			
			var texture:Texture = Texture.fromBitmap(ResourceManager.getInstance().getBitmap(ResourceDefine.TEX_BLOCK));
			var xml:XML = ResourceManager.getInstance().getAtlasXML(ResourceDefine.XML_BLOCK);
			var textureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			
			mImage = new Image(textureAtlas.getTexture("block_3"));
			mLayerTank.addChild(mImage);
			
			addChild(mLayerTank);
			mLayerTank.pivotX = mImage.width >> 1;
			mLayerTank.pivotY = mImage.height >> 1;
			mLayerTank.x = mImage.width >> 1;
			mLayerTank.y = mImage.height >> 1;
			
			mDirection = GameDefine.UP;
			updateDirection();
        }
		
		public function fire():void
		{
			mNumCurrentBullet = 0;
			
			var bullet:Bullet = BulletManager.getInstance().createBullet(this);
			bullet.x = x + (width - bullet.width >> 1);
			bullet.y = y + (height - bullet.height >> 1);
			MainGameScene.getInstance().mMapTiled.addBullet(bullet);
		}
		
		public function update(time:Number):void
		{
			mLastPositionX = this.x;
			mLastPositionY = this.y;
			
			mNumCurrentBullet += time;
			
			var newDirection:int = mDirection;
			
			if (GameKey.m_KEY_UP == true)
			{
				this.y -= mSpeed * time;
				newDirection = GameDefine.UP;
			}
			else if (GameKey.m_KEY_DOWN)
			{
				this.y += mSpeed * time;
				newDirection = GameDefine.DOWN;
			}
			else if (GameKey.m_KEY_LEFT)
			{
				this.x -= mSpeed * time;
				newDirection = GameDefine.LEFT;
			}
			else if (GameKey.m_KEY_RIGHT)
			{
				this.x += mSpeed * time;
				newDirection = GameDefine.RIGHT;
			}
			
			if (mDirection != newDirection)
			{
				mDirection = newDirection;
				updateDirection();
			}
			
			// check if fire
			if (GameKey.m_KEY_SPACE && mNumCurrentBullet >= GameDefine.MAX_BULLET)
			{
				fire();
			}
		}
		
		public function setLastPosition():void
		{	
			this.x = mLastPositionX;
			this.y = mLastPositionY;
		}
		
		public function setPositionCollideWithBlock(blockX:int, blockY:int):void
		{
			switch (mDirection)
			{
				case GameDefine.UP:
					this.y = (blockY + 1)* GameDefine.CELL_SIZE;
					break;
				case GameDefine.DOWN:
					this.y = (blockY - 1) * GameDefine.CELL_SIZE;
					break;
				case GameDefine.LEFT:
					this.x = (blockX + 1) * GameDefine.CELL_SIZE;
					break;
				case GameDefine.RIGHT:
					this.x = (blockX - 1) * GameDefine.CELL_SIZE;
					break;
			}
		}
		
		private function updateDirection():void
		{
			switch (mDirection)
			{
				case GameDefine.UP:
					mLayerTank.rotation = 0;
					break;
				case GameDefine.DOWN:
					mLayerTank.rotation = Math.PI / 2;
					break;
				case GameDefine.LEFT:
					mLayerTank.rotation = Math.PI / 4;
					break;
				case GameDefine.RIGHT:
					mLayerTank.rotation = Math.PI * 3 / 4;
					break;
			}
		}
		
		public function getDirection():int
		{
			return mDirection;
		}
	
		override public function get width():Number { return mImage.width; }
		override public function get height():Number { return mImage.height; }
	}
}