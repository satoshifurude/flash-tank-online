package 
{
    import starling.display.*;
	import starling.events.*;
	import starling.text.TextField;

    public class LoadingScene extends Sprite
    {
		private var mTitle:TextField;
		private var mNextScene:int;
        public function LoadingScene(nextScene:int, isText:Boolean = true)
        {
			if (!isText)
			{
				mTitle = new TextField(800, 300, "Loading", "Verdana", 60, 0xffffff, true);
				mTitle.x = 0;
				mTitle.y = GameDefine.HEIGHT - mTitle.height >> 1;
				addChild(mTitle);
			}
			
			mNextScene = nextScene;
			ResourceManager.getInstance().loadResource(mNextScene);
			ResourceManager.getInstance().addEventListener(ResourceManager.ON_LOAD_COMPLETE, onLoadDone);
        }
		
		private function onLoadDone(e:Event):void
		{
			switch (mNextScene)
			{
				case GameDefine.ID_SPLASH_SCENE:
					
					break;
				case GameDefine.ID_MAIN_SCENE:
					Game.getInstance().addChild(new MainGameScene());
					break;
			}
			
			this.removeFromParent(true);
		}
	}
}