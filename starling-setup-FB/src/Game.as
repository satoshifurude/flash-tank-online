package
{
//	import flash.events.Event;
	
	import flash.utils.ByteArray;
	
	import starling.display.Button;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		public function Game()
		{	
			
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE,onAddedToStage);
		}
		private function onAddedToStage (event : Event) : void
		{
			trace("Starling framework init");
			var menuScene:MenuScene = new MenuScene ();
			this.addChild(menuScene);		
		}
		private function handleDisConnect(num:int,event:Event):void
		{
			
		}
		private function handleMessage( msg : ByteArray) : void 
		{
		}
		
	}
}