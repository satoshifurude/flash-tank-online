package 
{
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.geom.Rectangle;
    
    import starling.core.Starling;
    
    [SWF(width="800", height="1000", frameRate="60", backgroundColor="#000000")]
    public class main extends Sprite
    {
        private var mStarling:Starling;
        
        public function main()
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
             
            mStarling = new Starling(Game, stage);
            mStarling.simulateMultitouch = true;
            mStarling.enableErrorChecking = false;
			mStarling.showStats = true;
            mStarling.start();
            
            // this event is dispatched when stage3D is set up
            mStarling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
        }
        
        private function onContextCreated(event:Event):void
        {
            // set framerate to 30 in software mode
            
            if (Starling.context.driverInfo.toLowerCase().indexOf("software") != -1)
                Starling.current.nativeStage.frameRate = 30;
        }
    }
}