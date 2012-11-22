package 
{
	import starling.textures.Texture;
	
    public class ResourceDefine
    {
		[Embed(source="../res/block.xml", mimeType="application/octet-stream")]
        public static const XMLBlock:Class;
		
		public static const RES_DIR:String	= "../res/";
		
		public static const TEX_BLOCK:String = "block.png";
		public static const XML_BLOCK:String = "XMLBlock";
		
		public static const TEX_LEVEL_DEMO:String = "level_demo.png";
    }
}