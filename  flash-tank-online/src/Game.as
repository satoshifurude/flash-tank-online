package 
{
    import flash.display.Bitmap;
    
    import starling.display.*;
    import starling.textures.*;
	import starling.events.*;

    public class Game extends Sprite
    {
        public static var mInstance:Game;
        public function Game()
        {	
			mInstance = this;
			addChild(new LoadingScene(GameDefine.ID_SPLASH_SCENE, false));
        }
		
		public static function getInstance():Game
		{
			return mInstance;
		}
	}
}