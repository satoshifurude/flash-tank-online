package 
{
	
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.LoaderInfo;
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import starling.events.EventDispatcher;
	
    public class ResourceManager extends EventDispatcher
    {
		public static var ON_LOAD_COMPLETE:String = "ON_LOAD_COMPLETE";
	
		private var mArrResources:Dictionary;
		private var mNumImages:int;
		private var mCurrentLoadDone:int;
		private static var mInstance:ResourceManager = null;
		
		
		public function ResourceManager() 
		{
			mArrResources = new Dictionary();
		}
		
		public static function getInstance():ResourceManager
		{
			if (mInstance == null)
			{
				mInstance = new ResourceManager();
			}
			
			return mInstance;
		}
		
		public function loadResource(IDScene:int):void
		{
			loadSplashScene();
		}
		
		private function clearResources():void
		{
			for (var i:int = 0, size:int = mArrBitmap.length; i < size; i++)
			{
				var bitmap:Bitmap = mArrBitmap.pop();
				bitmap.bitmapData.dispose();
				bitmap = null;
			}
			mCurrentLoadDone = 0;
		}
		
		private function loadSplashScene():void
		{
			trace("loadSplashScene");
			mNumImages = 1;
			loadURL("ga.png");
		}
		
		public function getBitmap(name:String):Bitmap
		{
			if (mArrResources[name] is Bitmap)
				return mArrResources[name];
			else
				return null;
		}
		
		private function loadURL(mAvatarUrl:String):void
		{
			var request:URLRequest = new URLRequest(GameDefine.RES_DIR + mAvatarUrl);
			var loaderCtx:LoaderContext = new LoaderContext(true);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onLoadAvatarComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadAvatarError);
			loader.load(request, loaderCtx);
		}
		
		private function onLoadAvatarError(event:IOErrorEvent):void 
		{
			trace("on load fail : " + event.toString());
		}
		
		private function onLoadAvatarComplete(event:Event):void
		{
			var loader:Loader = Loader(event.target.loader);
			var url:String = loader.contentLoaderInfo.url;
			var index:int = url.lastIndexOf("/");
			url = url.slice(index + 1);

			mArrResources[url] = loader.content;
			mCurrentLoadDone++;
			trace("mCurrentLoadDone = " + mCurrentLoadDone);
			
			if (mCurrentLoadDone == mNumImages)
			{
				dispatchEvent(new starling.events.Event(ON_LOAD_COMPLETE));
			}
			
		}
        
    }
}