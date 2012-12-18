package 
{
    import starling.display.*;
	import starling.events.*;
	import starling.text.TextField;

    public class LoadingScene extends Sprite
    {
		private var mTitle:TextField;
		private var mNextScene:int = 0;
        public function LoadingScene(nextScene:int, isText:Boolean = true)
        {
			if (isText)
			{
				// mTitle = new TextField(800, 300, "Loading", "Verdana", 60, 0xffffff, true);
				// mTitle.x = 0;
				// mTitle.y = GameDefine.HEIGHT - mTitle.height >> 1;
				// addChild(mTitle);
			}
			
			mNextScene = nextScene;
			trace("mNextScene111 = " + mNextScene);
			ResourceManager.getInstance().addEventListener(ResourceManager.ON_LOAD_COMPLETE, onLoadDone);
			ResourceManager.getInstance().loadResource(mNextScene);
        }
		
		private function onLoadDone(e:Event):void
		{
			trace("mNextScene = " + mNextScene);
			switch (mNextScene)
			{
				case GameDefine.ID_SPLASH_SCENE:
					Game.getInstance().addChild(new SplashScene());
					break;
				case GameDefine.ID_MAIN_SCENE:
					Game.getInstance().mMainGame = new MainGameScene();
					Game.getInstance().addChild(Game.getInstance().mMainGame);
					break;
				case GameDefine.ID_MENU_SCENE:
					Game.getInstance().addChild(new MenuScene());
					break;
				case GameDefine.ID_TEST_SCENE:
					Game.getInstance().addChild(new TestScene());
					break;
				case GameDefine.ID_CONNECT_SCENE:
					Game.getInstance().mConnectScene = new TestConnectScene();
					Game.getInstance().addChild(Game.getInstance().mConnectScene);
					break;
				case GameDefine.ID_LOGIN_SCENE:
					Game.getInstance().mLoginScene = new LoginScene();
					Game.getInstance().addChild(Game.getInstance().mLoginScene);
					break;
			}
			
			ResourceManager.getInstance().removeEventListener(ResourceManager.ON_LOAD_COMPLETE, onLoadDone);
			this.removeFromParent(true);
		}
	}
}