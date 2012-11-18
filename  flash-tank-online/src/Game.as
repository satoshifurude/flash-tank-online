package 
{
    import flash.ui.Keyboard;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    
    import starling.core.Starling;
    import starling.display.Button;
    import starling.display.Quad;
    import starling.display.Sprite;

    public class Game extends Sprite
    {
        
        public function Game()
        {
			trace("create quad 400 x 300");
			var mQuad:Quad = new Quad(400, 300);
			mQuad.x = GameDefine.WIDTH >> 1;
			mQuad.y = GameDefine.HEIGHT >> 1;
			mQuad.color = 0xffffff;
			addChild(mQuad);
        }
    }
}