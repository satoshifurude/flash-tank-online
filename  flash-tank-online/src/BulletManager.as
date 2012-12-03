package 
{
    import starling.display.*;
    import starling.textures.*;
	import starling.events.*;

    public class BulletManager
    {
		private var mArrBullet:Vector.<Bullet>;
		private static var mInstance:BulletManager = null;
		
        public function BulletManager()
        {
			mArrBullet = new Vector.<Bullet>();
        }
		
		public static function getInstance():BulletManager
		{
			if (mInstance == null)
			{
				mInstance = new BulletManager();
			}
			
			return mInstance;
		}
		
		public function createBullet(player:Tank):Bullet
		{
			for (var i:int = 0; i < mArrBullet.length; i++)
			{
				if (mArrBullet[i].isActive() == false)
				{
					mArrBullet[i].init(player);
					return mArrBullet[i];
				}
			}			
			var bullet:Bullet = new Bullet(player);
			mArrBullet.push(bullet);
			return bullet;
		}
		
		public function getArrBullet():Vector.<Bullet>
		{
			return mArrBullet;
		}
	}
}