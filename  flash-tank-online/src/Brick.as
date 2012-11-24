package 
{
    import starling.display.*;
    import starling.textures.*;
	import starling.events.*;

    public class Brick extends Sprite
    {
        public function Brick()
        {
			var texture:Texture = Texture.fromBitmap(ResourceManager.getInstance().getBitmap(ResourceDefine.TEX_BLOCK));
			var xml:XML = ResourceManager.getInstance().getAtlasXML(ResourceDefine.XML_BLOCK);
			var textureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			
			var img:Image = new Image(textureAtlas.getTexture("block_1"));
			addChild(img);
        }
	}
}