package 
{
    import starling.display.*;
    import starling.textures.*;
	import starling.events.*;
	import starling.core.*;

    public class Explosion extends Sprite
    {
		private var mAnimation:MovieClip;
		private var mActive:Boolean;
		
        public function Explosion()
        {
			var texture:Texture = Texture.fromBitmap(ResourceManager.getInstance().getBitmap(ResourceDefine.TEX_EXPLOSION));
			var xml:XML = ResourceManager.getInstance().getXML(ResourceDefine.XML_EXPLOSION);
			var textureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			var frames:Vector.<Texture> = textureAtlas.getTextures(ResourceDefine.SPR_EXPLOSION);
            mAnimation = new MovieClip(frames, 8);
            
            mAnimation.x = - mAnimation.width >> 2;
            mAnimation.y = - mAnimation.height >> 1;
            addChild(mAnimation);
			
			init();
        }
		
		public function init():void
		{
			mActive = true;
			Starling.juggler.add(mAnimation);
			mAnimation.addEventListener(Event.COMPLETE, onComplete);
		}
		
		private function onComplete(event:Event):void
        {
            mActive = false;
			Starling.juggler.remove(mAnimation);
			removeFromParent();
        }
		
		public function isActive():Boolean
		{
			return mActive;
		}
	}
}