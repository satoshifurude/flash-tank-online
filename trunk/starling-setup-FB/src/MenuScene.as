package
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import flashx.textLayout.events.UpdateCompleteEvent;
	
	import network.CSockConnection;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class MenuScene extends Sprite
	{	
		private var socket : CSockConnection ;
		private var welcomeBG : Image;
		private var welcomeHero : Image;
		private var welcomeTittle : Image;
		private var aboutBtn : Button;
		private var playBtn : Button;
		public function MenuScene()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE,onAddToState);
		}
		public function onAddToState(event : Event) :void
		{
			drawSceen();
		}
		public function drawSceen ():void
		{
			welcomeBG = new Image (Assets.getTexture("WelcomeBG"));
			welcomeHero = new Image (Assets.getTexture("WelcomHero"));
			welcomeTittle = new Image (Assets.getTexture("WelcomeTittle"));
			aboutBtn = new Button(Assets.getTexture("WelcomAboutBtn"));
			playBtn = new Button(Assets.getTexture("WelcomePlayBtn"));
			
			welcomeHero.x = 34;
			welcomeHero.y = 80;
			welcomeTittle.x  = 440;
			welcomeTittle.y = 20;
			playBtn.x = 500;
			playBtn.y = 260;
			aboutBtn.x = 410;
			aboutBtn.y = 380;
			
			this.addChild(welcomeBG);
			this.addChild(welcomeTittle);
			this.addChild(welcomeHero); 
			this.addChild(playBtn);
			this.addChild(aboutBtn);
			
			playBtn.addEventListener(Event.TRIGGERED,onClickPlay);
			aboutBtn.addEventListener(Event.TRIGGERED,onClickAbout);
			
			this.addEventListener(starling.events.Event.ENTER_FRAME,onEnterFrame);
			trace("hello log");
		}
		private function onEnterFrame(event : Event):void
		{
			var curDate: Date = new Date();		
			welcomeHero.y = 80+ (Math.cos(curDate.getTime()*0.002+1)*25);
			playBtn.y = 260+ (Math.cos(curDate.getTime()*0.002)*15);
			aboutBtn.y = 380+(Math.cos(curDate.getTime()*0.002)*15);
		}
		private function onClickPlay(event:Event):void{
			
			socket = new CSockConnection("192.168.0.9",555);
			var b:ByteArray = new ByteArray();
			b.endian = Endian.BIG_ENDIAN;
			b.clear();
			b.writeInt(123);			
			socket.Write(b);
		}
		private function onClickAbout(event:Event):void{
			var b:ByteArray = new ByteArray();
			b.clear();
			b.writeInt(123);
			socket.Write(b);
		}
	}
}