package 
{
    import starling.display.*;
    import starling.textures.*;
	import starling.events.*;
	import starling.core.*;
	import starling.animation.*;
	import flash.geom.Rectangle;

    public class DeadCloud extends Sprite
    {
		private var mLayerHeader:Sprite;
		private var mAnimation:MovieClip;
		public var mOnComplete:Function;
		
        public function DeadCloud(scale:Number)
        {
			var texture:Texture = Texture.fromBitmap(ResourceManager.getInstance().getBitmap(ResourceDefine.TEX_DEAD_CLOUD));
			var xml:XML = ResourceManager.getInstance().getXML(ResourceDefine.XML_DEAD_CLOUD);
			var textureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			var frames:Vector.<Texture> = textureAtlas.getTextures(ResourceDefine.SPR_DEAD_CLOUD);
			
            mAnimation = new MovieClip(frames, 10);
			mAnimation.loop = false;
			mAnimation.addEventListener(Event.COMPLETE, onComplete);
			mAnimation.scaleX = mAnimation.scaleY = scale;
			
			mLayerHeader = new Sprite();
			mLayerHeader.pivotX = mAnimation.width >> 1;
			mLayerHeader.pivotY = mAnimation.height >> 1;
			mLayerHeader.addChild(mAnimation);
			addChild(mLayerHeader);
			
			Starling.juggler.add(mAnimation);
        }
		
		private function onComplete(event:Event):void
		{
			if (mOnComplete != null)
				mOnComplete.apply(null, null);
			mAnimation.removeEventListener(Event.COMPLETE, onComplete);
			this.removeFromParent(true);
		}
	}
}