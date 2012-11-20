package 
{
	import starling.textures.Texture;
	
    public class GameDefine
    {
        public static var WIDTH:int 	= 800;
		public static var HEIGHT:int	= 600;
		
		public static var RES_DIR:String	= "../res/";
		
		[Embed(source="../res/atlas.xml", mimeType="application/octet-stream")]
        public static const AtlasXml:Class;
    }
}