package 
{
    import starling.display.*;
    import starling.textures.*;
	import starling.events.*;
	import starling.core.*;

    public class Header extends Sprite
    {
		private var mLayerHeader:Sprite;
		private var mAnimation:MovieClip;
		private var mHP:int;
		
        public function Header(side:int)
        {
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
        }
		
		override public function get width():Number { return mAnimation.width; }
		override public function get height():Number { return mAnimation.height; }
	}
}