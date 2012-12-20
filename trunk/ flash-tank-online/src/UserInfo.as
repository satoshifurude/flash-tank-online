package 
{
    import starling.display.*;
	import starling.events.*;
	import starling.textures.Texture;
	import starling.core.Starling;
	import starling.text.TextField;

    public class UserInfo extends Sprite
    {
		private var mBackground:Image;
		private var mHp:TextField;
		private var mAttack:TextField;
		private var mSpeed:TextField;
		private var mPlayer:Tank;
		
        public function UserInfo(tank:Tank)
        {
			mBackground = ResourceManager.getInstance().getImage(ResourceDefine.TEX_USER_INFO);
			addChild(mBackground);
			
			mHp = new TextField(100, 22, "", "Verdana", 18, 0xffffff, true);
			mHp.x = 40;
			mHp.y = 14;
			mHp.hAlign = "left";
			addChild(mHp);
			
			mAttack = new TextField(100, 22, "", "Verdana", 18, 0xffffff, true);
			mAttack.x = 40;
			mAttack.y = 53;
			mAttack.hAlign = "left";
			addChild(mAttack);
			
			mSpeed = new TextField(100, 22, "", "Verdana", 18, 0xffffff, true);
			mSpeed.x = 40;
			mSpeed.y = 89;
			mSpeed.hAlign = "left";
			addChild(mSpeed);
			
			mPlayer = tank;
			updateInfo();
        }
		
		public function updateInfo():void
		{
			mHp.text = "" + mPlayer.mHp;
			mAttack.text = "" + mPlayer.mDamage;
			mSpeed.text = "" + mPlayer.mSpeed;
		}
		
		override public function get width():Number { return mBackground.width; }
		override public function get height():Number { return mBackground.height; }
	}
}