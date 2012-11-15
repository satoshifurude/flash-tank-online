package 
{
	
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.LoaderInfo;
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.events.Event;
	import flash.events.IOErrorEvent;;
	
    public class ResourceManager
    {
        private var mArrBitmap:Vector.<Bitmap>;
		private static var mInstance:ResourceManager = null;
		
		public function ResourceManager() {}
		
		public static function getInstance():ResourceManager
		{
			if (mInstance == null)
				mInstance = new ResourceManager();
			
			return mInstance;
		}
		
		public function loadResource(IDScene:int):void
		{
			
		}
		
		
		
		private function loadImageURL(mAvatarUrl:String, onComplete:Function):void
		{
			mOnLoadImageComplete = onComplete;
			var request:URLRequest = new URLRequest(mAvatarUrl);
			var loaderCtx:LoaderContext = new LoaderContext(true);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onLoadAvatarComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadAvatarError);
			loader.load(request, loaderCtx);
		}
		
		private function onLoadAvatarError(event:IOErrorEvent):void 
		{
		}
		
		private function onLoadAvatarComplete(event:Event):void
		{
			var loader:Loader = Loader(event.target.loader);
			var bitmap:Bitmap = Bitmap(loader.content);
			// var texture:Texture = Texture.fromBitmap(bitmap);
		}
        
    }
}