package 
{
    import starling.display.*;
	import starling.events.*;
	import starling.textures.Texture;
	import starling.core.Starling;

    public class MenuScene extends Sprite
    {
		private var mParticle:PDParticleSystem;
		private var mBackground:Image;
		private var mBtnPlay:Button;
		
        public function MenuScene()
        {
			initBackground();
			initParticle();
			initButton();
        }
		
		private function initBackground():void
		{
			mBackground = ResourceManager.getInstance().getImage(ResourceDefine.TEX_MENU_BACKGROUND);
			addChild(mBackground);
		}
		
		private function initParticle():void
		{
			var psConfig:XML = XML(ResourceManager.getInstance().getXML(ResourceDefine.XML_PARTICLE_MENU));
			var psTexture:Texture = ResourceManager.getInstance().getTexture(ResourceDefine.TEX_PARTICLE_MENU);
			mParticle = new PDParticleSystem(psConfig, psTexture);
			mParticle.emitterX = GameDefine.WIDTH >> 1;
			mParticle.emitterY = GameDefine.HEIGHT >> 1;
			addChild(mParticle);
			Starling.juggler.add(mParticle);
			
			mParticle.start();
		}
		
		private function initButton():void
		{
			mBtnPlay = new Button(ResourceManager.getInstance().getTexture(ResourceDefine.TEX_BTN_PLAY_UP), "", ResourceManager.getInstance().getTexture(ResourceDefine.TEX_BTN_PLAY_DOWN));
			mBtnPlay.x = GameDefine.WIDTH - mBtnPlay.width >> 1;
			mBtnPlay.y = 200;
			mBtnPlay.addEventListener(Event.TRIGGERED, onPlay);
			addChild(mBtnPlay);
		}
		
		private function onPlay(event:Event):void
		{
			removeFromParent(true);
			Game.getInstance().addChild(new LoadingScene(GameDefine.ID_MAIN_SCENE));
		}
	}
}