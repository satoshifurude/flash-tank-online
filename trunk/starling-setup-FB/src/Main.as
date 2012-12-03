package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import starling.core.Starling;
	[SWF(width="800",height="600", frameRate="60",backgroundColor="#000000")]
	public class Main extends Sprite
	{
		private var mStarling:Starling;
		public function Main()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.BOTTOM;
			
			mStarling = new Starling(Game,stage);
			mStarling.start();
		}
	}
}