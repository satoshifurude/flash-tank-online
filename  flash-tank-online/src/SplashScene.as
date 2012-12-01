package 
{
    import starling.display.*;
	import starling.events.*;
	import starling.text.TextField;

    public class SplashScene extends Sprite
    {
		private var mLogo:Image;
		private var mSign:int = 1;
		private var mSpeed:Number = 0.5;
		
        public function SplashScene()
        {
			mLogo = ResourceManager.getInstance().getImage(ResourceDefine.TEX_LOGO_SPLASH);
			mLogo.x = GameDefine.WIDTH - mLogo.width >> 1;
			mLogo.y = GameDefine.HEIGHT - mLogo.height >> 1;
			addChild(mLogo);
			
			mLogo.alpha = 0;
			addEventListener(Event.ENTER_FRAME, onFrame);
        }
		
		private function onFrame(event:EnterFrameEvent):void
		{
			mLogo.alpha += mSpeed * mSign * event.passedTime;
			if (mLogo.alpha >= 1.0)
			{
				mLogo.alpha = 1.0;
				mSign = -1;
			}
			else if (mLogo.alpha <= 0)
			{
				removeEventListener(Event.ENTER_FRAME, onFrame);
				removeFromParent(true);
				Game.getInstance().addChild(new LoadingScene(GameDefine.ID_MAIN_SCENE));
			}
		}
	}
}