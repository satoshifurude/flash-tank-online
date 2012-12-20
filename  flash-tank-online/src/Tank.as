package 
{
    import starling.display.*;
    import starling.textures.*;
	import starling.events.*;

    public class Tank extends Sprite
    {
		public var mLastPositionX:Number;
		public var mLastPositionY:Number;
		public var mDirection:int;
		public var mSpeed:int;
		public var mHp:int;
		public var mDamage:int;
		public var mImage:Image;
		public var mLayerTank:Sprite;
		public var mNumCurrentBullet:Number;
		public var mName:String;
		public var mID:int;
		public var mIsMoving:int;
		public var mSide:int;
		
        public function Tank(id:int = 0, side:int = GameDefine.SIDE_BLUE)
        {
			mNumCurrentBullet = 0;
			mSpeed = GameDefine.TANK_SPEED;
			mID = id;
			mSide = side;
			mHp = 100;
			mDamage = 10;
			mLayerTank = new Sprite();
			
			mImage = new Image(ResourceManager.getInstance().getTexture(side == GameDefine.SIDE_BLUE ? ResourceDefine.TEX_TANK_BLUE : ResourceDefine.TEX_TANK_RED));
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
			switch (mDirection)
			{
				case GameDefine.UP:
					bullet.y -= (height >> 1);
					break;				
				case GameDefine.DOWN:
					bullet.y += (height >> 1);
					break;
				case GameDefine.LEFT:
					bullet.x -= (width >> 1);
					break;
				case GameDefine.RIGHT:
					bullet.x += (width >> 1);
					break;
			}
			MainGameScene.getInstance().mMapTiled.addBullet(bullet);
			Game.getInstance().sendFire(bullet);
		}
		
		public function update(time:Number):void
		{
			mNumCurrentBullet += time;
			
			var newDirection:int = mDirection;
			var newMoving:int = 0;
			var isChange:Boolean = false;
			
			if (GameKey.m_KEY_UP == true)
			{
				this.y -= mSpeed * time;
				newDirection = GameDefine.UP;
				newMoving = 1;
			}
			else if (GameKey.m_KEY_DOWN)
			{
				this.y += mSpeed * time;
				newDirection = GameDefine.DOWN;
				newMoving = 1;
			}
			else if (GameKey.m_KEY_LEFT)
			{
				this.x -= mSpeed * time;
				newDirection = GameDefine.LEFT;
				newMoving = 1;
			}
			else if (GameKey.m_KEY_RIGHT)
			{
				this.x += mSpeed * time;
				newDirection = GameDefine.RIGHT;
				newMoving = 1;
			}
			
			if (mDirection != newDirection)
			{
				mDirection = newDirection;
				updateDirection();
				isChange = true;
			}
			
			if (mIsMoving != newMoving) 
			{
				mIsMoving = newMoving;
				isChange = true;
			}
			
			// check if fire
			if (GameKey.m_KEY_SPACE && mNumCurrentBullet >= GameDefine.MAX_BULLET)
			{
				fire();
			}
			
			if (isChange)
			{
				Game.getInstance().sendPlayerState();
			}
		}
		
		public function updateOther(time:Number):void
		{
			updateDirection();
			
			if (mIsMoving == 1)
			{
				switch (mDirection)
				{
					case GameDefine.UP:
						this.y -= mSpeed * time;
						break;				
					case GameDefine.DOWN:
						this.y += mSpeed * time;
						break;
					case GameDefine.LEFT:
						this.x -= mSpeed * time;
						break;
					case GameDefine.RIGHT:
						this.x += mSpeed * time;
						break;
				}
			}
		}
		
		public function setLastPosition():void
		{	
			// this.x = mLastPositionX;
			// this.y = mLastPositionY;
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
				case GameDefine.DOWN:
					mLayerTank.rotation = Math.PI / 2;;
					break;
				case GameDefine.UP:
					mLayerTank.rotation = Math.PI * 3 / 2;
					break;
				case GameDefine.RIGHT:
					mLayerTank.rotation = 0;
					break;
				case GameDefine.LEFT:
					mLayerTank.rotation = Math.PI;
					break;
			}
		}
		
		public function getDirection():int
		{
			return mDirection;
		}
		
		public function getID():int
		{
			return mID;
		}
		
		public function checkCollisionWithBullet(bullet:Bullet):Boolean
		{
			return !(this.x > (bullet.x + bullet.width / 2)
					|| this.x + this.width / 2 < bullet.x
					|| this.y > bullet.y + bullet.height / 2
					|| this.y + this.height / 2 < bullet.y);
		}
		
		private function dead():void
		{
			
		}
		
		public function damage(bullet:Bullet):void
		{
			mHp -= bullet.getPlayer().mDamage;
			trace("Hp = " + mHp);
			if (mHp <= 0)
			{
				dead();
			}
		}
	
		override public function get width():Number { return mImage.width; }
		override public function get height():Number { return mImage.height; }
	}
}