package 
{
    import starling.display.*;
    import starling.textures.*;
	import starling.events.*;
	import starling.core.*;

    public class Bullet extends Sprite
    {
		private var mLayerBullet:Sprite;
		private var mAnimation:MovieClip;
		private var mPlayer:Tank;
		
		private var mLastPosition:Number;
		private var mSpeed:int;
		private var mDirection:int;
		private var mActive:Boolean;
		
        public function Bullet(player:Tank)
        {
			var texture:Texture = Texture.fromBitmap(ResourceManager.getInstance().getBitmap(ResourceDefine.TEX_BULLET_1));
			var xml:XML = ResourceManager.getInstance().getXML(ResourceDefine.XML_BULLET_1);
			var textureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			var frames:Vector.<Texture> = textureAtlas.getTextures(ResourceDefine.SPR_BULLET_1);
            mAnimation = new MovieClip(frames, 8);
			
			mLayerBullet = new Sprite();
			mLayerBullet.pivotX = mAnimation.width >> 1;
			mLayerBullet.pivotY = mAnimation.height >> 1;
			mLayerBullet.x = mAnimation.width >> 1;
			mLayerBullet.y = mAnimation.height >> 1;
			mLayerBullet.addChild(mAnimation);
			addChild(mLayerBullet);
			
			init(player);
        }
		
		public function init(player:Tank):void
		{
			mActive = true;
			mSpeed = GameDefine.BULLET_SPEED;
			mPlayer = player;
			mDirection = mPlayer.getDirection();
			
			switch (mDirection)
			{
				case GameDefine.UP:
					mLastPosition = mPlayer.y;
					mLayerBullet.rotation = Math.PI / 2;
					break;
				case GameDefine.DOWN:
					mLastPosition = mPlayer.y;
					mLayerBullet.rotation = Math.PI * 3 / 2;
					break;
				case GameDefine.LEFT:
					mLastPosition = mPlayer.x;
					mLayerBullet.rotation = 0;
					break;
				case GameDefine.RIGHT:
					mLastPosition = mPlayer.x;
					mLayerBullet.rotation = Math.PI;
					break;
			}
				
			Starling.juggler.add(mAnimation);
		}
		
		public function update(time:Number):void
		{
			if (mDirection == GameDefine.UP || mDirection == GameDefine.DOWN)
			{
				if (Math.abs(this.y - mLastPosition) > GameDefine.MAX_RANGE_BULLET)
					explode();
			}
			else
			{
				if (Math.abs(this.x - mLastPosition) > GameDefine.MAX_RANGE_BULLET)
					explode();
			}
			
			if (mDirection == GameDefine.UP)
			{
				this.y -= mSpeed * time;
			}
			else if (mDirection == GameDefine.DOWN)
			{
				this.y += mSpeed * time;
			}
			else if (mDirection == GameDefine.LEFT)
			{
				this.x -= mSpeed * time;
			}
			else if (mDirection == GameDefine.RIGHT)
			{
				this.x += mSpeed * time;
			}
		}
		
		public function explode():void
		{
			var explosion:Explosion = ExplosionManager.getInstance().createExplosion();
			explosion.x = this.x;
			explosion.y = this.y;
			this.parent.addChild(explosion);
			Starling.juggler.remove(mAnimation);
			
			mActive = false;
			mPlayer = null;
			removeFromParent();
		}
		
		public function isActive():Boolean
		{
			return mActive;
		}
		
		override public function get width():Number { return mAnimation.width; }
		override public function get height():Number { return mAnimation.height; }
	}
}