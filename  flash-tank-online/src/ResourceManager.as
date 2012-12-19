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
	import starling.display.Image;
	import starling.textures.Texture;
	
    public class ResourceManager extends EventDispatcher
    {
		public static var ON_LOAD_COMPLETE:String = "ON_LOAD_COMPLETE";
	
		private var mArrResources:Dictionary;
		private var mNumImages:int;
		private var mCurrentLoadDone:int;
		private static var mInstance:ResourceManager = null;
		
		public function ResourceManager() 
		{
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
			
			switch (IDScene)
			{
				case GameDefine.ID_SPLASH_SCENE:
					clearResources();
					loadSplashScene();
					break;
				// case GameDefine.ID_MAIN_SCENE:
					// loadMainScene();
					// break;
				// case GameDefine.ID_TEST_SCENE:
					// loadSplashScene();
					// break;
				// case GameDefine.ID_MENU_SCENE:
					// loadMenuScene();
					// break;
				default:
					dispatchEvent(new starling.events.Event(ON_LOAD_COMPLETE));
					break;
			}
		}
		
		private function clearResources():void
		{
			for each (var obj:Object in mArrResources)
			{
				if (obj is Bitmap)
					obj.bitmapData.dispose();
				obj = null;
			}
			mCurrentLoadDone = 0;
			mArrResources = new Dictionary();
		}
		
		private function loadSplashScene():void
		{
			mNumImages = 32;
			//1
			loadURL(ResourceDefine.TEX_LOGO_SPLASH);
			
			//4 
			loadURL(ResourceDefine.TEX_LOGIN_BACKGROUND);
			loadURL(ResourceDefine.TEX_LOGIN_INFO);
			loadURL(ResourceDefine.TEX_LOGIN_BTN_1);
			loadURL(ResourceDefine.TEX_LOGIN_BTN_2);
			
			// 4
			loadURL(ResourceDefine.TEX_MENU_BACKGROUND);
			loadURL(ResourceDefine.TEX_BTN_PLAY_UP);
			loadURL(ResourceDefine.TEX_BTN_PLAY_DOWN);
			loadURL(ResourceDefine.TEX_PARTICLE_MENU);
			
			// 14
			loadURL(ResourceDefine.TEX_ROOM_BACKGROUND);
			loadURL(ResourceDefine.TEX_BTN_CREATE_ROOM);
			loadURL(ResourceDefine.TEX_BTN_ACCEPT_1);
			loadURL(ResourceDefine.TEX_BTN_ACCEPT_2);
			loadURL(ResourceDefine.TEX_BTN_CANCEL_1);
			loadURL(ResourceDefine.TEX_BTN_CANCEL_2);
			loadURL(ResourceDefine.TEX_CREATE_ROOM);
			loadURL(ResourceDefine.TEX_ROOM_FRAME);
			loadURL(ResourceDefine.TEX_ROOM_FRAME_BG);
			loadURL(ResourceDefine.TEX_USER_FRAME);
			loadURL(ResourceDefine.TEX_BTN_EXIT_1);
			loadURL(ResourceDefine.TEX_BTN_START_1);
			loadURL(ResourceDefine.TEX_BTN_REFRESH_1);
			loadURL(ResourceDefine.TEX_ICON_READY);
			loadURL(ResourceDefine.TEX_ICON_KEY);
			
			// 8
			loadURL(ResourceDefine.TEX_LEVEL_DEMO);
			loadURL(ResourceDefine.TEX_BLOCK);
			loadURL(ResourceDefine.TEX_EXPLOSION);
			loadURL(ResourceDefine.TEX_BULLET_1);
			loadURL(ResourceDefine.TEX_HEADER_RED);
			loadURL(ResourceDefine.TEX_HEADER_BLUE);
			loadURL(ResourceDefine.TEX_TANK_BLUE);
			loadURL(ResourceDefine.TEX_TANK_RED);
		}
		
		private function loadMainScene():void
		{
			mNumImages = 4;
			loadURL(ResourceDefine.TEX_LEVEL_DEMO);
			loadURL(ResourceDefine.TEX_BLOCK);
			loadURL(ResourceDefine.TEX_EXPLOSION);
			loadURL(ResourceDefine.TEX_BULLET_1);
		}
		
		private function loadMenuScene():void
		{
			mNumImages = 8;
			loadURL(ResourceDefine.TEX_MENU_BACKGROUND);
			loadURL(ResourceDefine.TEX_BTN_PLAY_UP);
			loadURL(ResourceDefine.TEX_BTN_PLAY_DOWN);
			loadURL(ResourceDefine.TEX_PARTICLE_MENU);
			
			loadURL(ResourceDefine.TEX_LEVEL_DEMO);
			loadURL(ResourceDefine.TEX_BLOCK);
			loadURL(ResourceDefine.TEX_EXPLOSION);
			loadURL(ResourceDefine.TEX_BULLET_1);
		}
		
		public function getTexture(name:String):Texture
		{
			var texture:Texture = Texture.fromBitmap(getBitmap(name));
			return texture;
		}
		
		public function getImage(name:String):Image
		{
			var texture:Texture = Texture.fromBitmap(getBitmap(name));
			var image:Image = new Image(texture);
			return image;
		}
		
		public function getBitmap(name:String):Bitmap
		{
			if (mArrResources[name] is Bitmap)
				return mArrResources[name];
			else
				return null;
		}
		
		public function getBitmapData(name:String):BitmapData
		{
			if (mArrResources[name] is Bitmap)
				return mArrResources[name].bitmapData;
			else
				return null;
		}
		
		public function getXML(name:String):XML
		{
			return new XML(new ResourceDefine[name]);
		}
		
		private function loadURL(mAvatarUrl:String):void
		{
			var request:URLRequest = new URLRequest(ResourceDefine.RES_DIR + mAvatarUrl);
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
			trace("mCurrentLoadDone = " + mCurrentLoadDone + ", url = " + url);
			
			if (mCurrentLoadDone == mNumImages)
			{
				dispatchEvent(new starling.events.Event(ON_LOAD_COMPLETE));
			}
			
		}
		
        
		
    }
}