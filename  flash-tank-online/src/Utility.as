package 
{
    import starling.display.*;
	import starling.events.*;
	import starling.textures.Texture;
	import starling.core.*;
	import starling.text.TextField;
	import starling.animation.*;
	

    public class Utility extends Sprite
    {
		public static function addFlyingHp(parent:DisplayObjectContainer, hp:int, xCenter:int, yCenter:int):void
		{
			var text:TextField = new TextField(200, 300, "-" + hp, "Verdana", 20, 0xff0000, true);
			text.x = xCenter - (text.width >> 1);
			text.y = yCenter - (text.height >> 1);
			parent.addChild(text);
			
			var tween:Tween = new Tween(text, 2);
			tween.moveTo(text.x, text.y - 100);
			tween.onComplete = onFlyingHpDone;
			tween.onCompleteArgs = [text];
			Starling.juggler.add(tween); 
		}
		
		private static function onFlyingHpDone(text:TextField):void
		{
			text.removeFromParent(true);
		}
	}
}