package 
{
    import starling.display.*;
    import starling.textures.*;
	import starling.events.*;
	import starling.core.*;
	import starling.animation.*;
	import flash.geom.Rectangle;

    public class Header extends Sprite
    {
		private var mLayerHeader:Sprite;
		private var mAnimation:MovieClip;
		private var mHp:int;
		private var mSide:int;
		private var mCountTime:Number;
		private var mClipSprite:ClippedSprite;
		private var mHpBar:Image;
		private var mFinishImage:Image;
		
        public function Header(side:int)
        {
			mHp = 100;
			mSide = side;
			var texID:String = side == GameDefine.SIDE_RED ? ResourceDefine.TEX_HEADER_RED : ResourceDefine.TEX_HEADER_BLUE;
			var xmlID:String = side == GameDefine.SIDE_RED ? ResourceDefine.XML_HEADER_RED : ResourceDefine.XML_HEADER_BLUE;
			var sprID:String = side == GameDefine.SIDE_RED ? ResourceDefine.SPR_HEADER_RED : ResourceDefine.SPR_HEADER_BLUE;
			
			var texture:Texture = Texture.fromBitmap(ResourceManager.getInstance().getBitmap(texID));
			var xml:XML = ResourceManager.getInstance().getXML(xmlID);
			var textureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			var frames:Vector.<Texture> = textureAtlas.getTextures(sprID);
            mAnimation = new MovieClip(frames, 20);
			
			mLayerHeader = new Sprite();
			mLayerHeader.pivotX = mAnimation.width >> 1;
			mLayerHeader.pivotY = mAnimation.height >> 1;
			mLayerHeader.addChild(mAnimation);
			addChild(mLayerHeader);
			
			Starling.juggler.add(mAnimation);
			
			mHpBar = ResourceManager.getInstance().getImage(ResourceDefine.TEX_HP_BAR);
			mHpBar.x = -mHpBar.width >> 1;
			mHpBar.y = side == GameDefine.SIDE_RED ? -(height >> 1) - 10: (height >> 1) + 10;
			mClipSprite = new ClippedSprite();
			addChild(mClipSprite);
			mClipSprite.addChild(mHpBar);
			
        }
		
		public function checkCollisionWithBullet(bullet:Bullet):Boolean
		{
			return !(this.x - this.width / 2 > (bullet.x + bullet.width / 2)
					|| this.x + this.width / 2 < bullet.x - bullet.width / 2
					|| this.y - this.height / 2 > bullet.y + bullet.height / 2
					|| this.y + this.height / 2 < bullet.y - bullet.height / 2);
		}
		
		private function dead():void
		{
			var deadCloud:DeadCloud = new DeadCloud(1);
			deadCloud.x = this.x;
			deadCloud.y = this.y;
			this.parent.addChild(deadCloud);
			this.visible = false;
			
			if (Game.getInstance().mMainGame.getPlayer().mSide == mSide)
			{
				mFinishImage = ResourceManager.getInstance().getImage(ResourceDefine.TEX_LOSE);
			}
			else
			{
				mFinishImage = ResourceManager.getInstance().getImage(ResourceDefine.TEX_WIN);
			}
			
			mFinishImage.x = GameDefine.WIDTH - mFinishImage.width >> 1;
			mFinishImage.y = GameDefine.HEIGHT - mFinishImage.height >> 1;
			mFinishImage.alpha = 0;
			Game.getInstance().addChild(mFinishImage);
				
			var tween:Tween = new Tween(mFinishImage, 2);
			tween.fadeTo(1);
			tween.onComplete = onImageDone;
			Starling.juggler.add(tween); 
		}
		
		private function onImageDone():void
		{
			addEventListener(Event.ENTER_FRAME, onFrame);
			mCountTime = 1;
		}
		
		private function onFrame(event:EnterFrameEvent):void
		{
			mCountTime -= event.passedTime;
			if (mCountTime < 0)
			{
				Game.getInstance().removeChild(mFinishImage);
				mFinishImage.dispose();
				removeEventListener(Event.ENTER_FRAME, onFrame);
				removeFromParent(true);
				Game.getInstance().mMainGame.finishGame();
			}
		}
		
		public function damage(bullet:Bullet):void
		{
			Utility.addFlyingHp(this.parent, bullet.getPlayer().mDamage, this.x, this.y);
			mHp -= bullet.getPlayer().mDamage;
			
			var percent:Number = mHp / GameDefine.HEADER_HP;
			trace("percent = " + percent);
			mClipSprite.clipRect = new Rectangle(mHpBar.x, mHpBar.y, mHpBar.width * percent, mHpBar.height);
			if (mHp == 0)
			{
				dead();
			}
		}
		
		override public function get width():Number { return mAnimation.width; }
		override public function get height():Number { return mAnimation.height; }
	}
}