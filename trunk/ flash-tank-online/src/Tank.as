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
		
        public function Tank()
        {
			mSpeed = GameDefine.TANK_SPEED;
			
			var texture:Texture = Texture.fromBitmap(ResourceManager.getInstance().getBitmap(ResourceDefine.TEX_BLOCK));
			var xml:XML = ResourceManager.getInstance().getAtlasXML(ResourceDefine.XML_BLOCK);
			var textureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			
			mImage = new Image(textureAtlas.getTexture("block_3"));
			addChild(mImage);
			
			// addEventListener(Event.ENTER_FRAME, onFrame);
        }
		
		public function fire():void
		{
			
		}
		
		public function move(time:Number):void
		{
			mLastPositionX = this.x;
			mLastPositionY = this.y;
			
			if (GameKey.m_KEY_UP == true)
			{
				this.y -= mSpeed * time;
				mDirection = GameDefine.UP;
			}
			else if (GameKey.m_KEY_DOWN)
			{
				this.y += mSpeed * time;
				mDirection = GameDefine.DOWN;
			}
			else if (GameKey.m_KEY_LEFT)
			{
				this.x -= mSpeed * time;
				mDirection = GameDefine.LEFT;
			}
			else if (GameKey.m_KEY_RIGHT)
			{
				this.x += mSpeed * time;
				mDirection = GameDefine.RIGHT;
			}
		}
		
		private function onFrame(event:EnterFrameEvent):void
		{
			move(event.passedTime);
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

		public function getWidth():Number
		{
			return mImage.width;
		}
		
		public function getHeight():Number
		{
			return mImage.height;
		}
	}
}