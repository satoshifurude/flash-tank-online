package 
{
    import starling.display.*;
    import starling.textures.*;
	import starling.events.*;

    public class Bullet extends Sprite
    {
		private var mLayerBullet:Sprite;
		private var mQuad:Quad;
		private var mPlayer:Tank;
		private var mSpeed:int;
		private var mDirection:int;
		public var mActive:Boolean;
		
        public function Bullet(player:Tank)
        {
			mSpeed = GameDefine.BULLET_SPEED;
			mPlayer = player;
			mDirection = mPlayer.getDirection();
			trace("mDirection = " + mDirection);

			mQuad = new Quad(10, 10, 0xffffffff);
			addChild(mQuad);
			mActive = true;
        }
		
		public function update(time:Number):void
		{
			
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
			mActive = false;
			// mPlayer.reduceBullet();
			removeFromParent(true);
		}
		
		override public function get width():Number { return mQuad.width; }
		override public function get height():Number { return mQuad.height; }
	}
}