package 
{
    import starling.display.*;
    import starling.textures.*;
	import starling.events.*;

    public class ExplosionManager
    {
		private var mArrExplosion:Vector.<Explosion>;
		private static var mInstance:ExplosionManager = null;
		
        public function ExplosionManager()
        {
			mArrExplosion = new Vector.<Explosion>();
        }
		
		public static function getInstance():ExplosionManager
		{
			if (mInstance == null)
			{
				mInstance = new ExplosionManager();
			}
			
			return mInstance;
		}
		
		public function createExplosion():Explosion
		{
			for (var i:int = 0; i < mArrExplosion.length; i++)
			{
				if (mArrExplosion[i].isActive() == false)
				{
					mArrExplosion[i].init();
					return mArrExplosion[i];
				}
			}
			
			var explosion:Explosion = new Explosion();
			mArrExplosion.push(explosion);
			return explosion;
		}
		
		public function getArrExplosion():Vector.<Explosion>
		{
			return mArrExplosion;
		}
	}
}