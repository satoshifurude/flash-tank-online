package 
{
	import starling.textures.*;
	import starling.display.*;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import flash.display.BitmapData;
	import flash.display.Bitmap;

    public class TestScene extends Sprite
    {
		private var mBitmapData:BitmapData;
		private var mKernel:Vector.<Number>;
		
        public function TestScene()
        {
			var bmdOrigin:BitmapData = ResourceManager.getInstance().getBitmapData("atlas.png");
			
			mKernel = createKernel(1.5, 1, 1);
			mBitmapData = new BitmapData(bmdOrigin.width, bmdOrigin.height, true, 0x0);
			applyGaussianBlur(bmdOrigin, mBitmapData, mKernel, 1, 1);
			
			var img:Image = Image.fromBitmap(new Bitmap(mBitmapData));
			addChild(img);
        }
		
		private function createKernel(epsilon:Number, kWidth:int, kHeight:int):Vector.<Number>
		{
			var A:Number;
			var B:Number;
			var kTemp:Number;
			var K:Vector.<Number> = new Vector.<Number>();
			
			A = 1 / (2 * Math.PI * Math.pow(epsilon, 2));
			B = 1 / (2 * Math.pow(epsilon, 2));
			
			for (var y:int = -kHeight; y <= kHeight; y++)
			{
				for (var x:int = -kWidth; x <= kWidth; x++)
				{
					kTemp = A * Math.pow(Math.E, -(x * x + y * y) * B);
					K.push(kTemp);
				}
			}
			
			var size:int = K.length;
			var sum:Number = 0;
			var i:int;
			for (i = 0; i < size; i++)
			{
				sum += K[i];
			}
			
			for (i = 0; i < size; i++)
			{
				K[i] = K[i] / sum;
				trace("K = " + K[i]);
			}
			
			return K;
		}
		
		private function applyGaussianBlur(origin:BitmapData, outData:BitmapData, kernel:Vector.<Number>, kWidth:int, kHeight:int):void
		{
			
			
			var newPixel:uint;
			var pixel:uint = 0;
			var x:int;
			var y:int;
			for (var yB:int = 0; yB < origin.height; yB++)
			{
				for (var xB:int = 0; xB < origin.width; xB++)
				{
					for (var yK:int = -kHeight; yK <= kHeight; yK++)
					{
						for (var xK:int = -kWidth; xK <= kWidth; xK++)
						{
							x = xB + xK;
							if (x < 0) x = 0;
							else if (x >= origin.width) x = origin.width - 1;
							
							y = yB + yK;
							if (y < 0) y = 0;
							else if (y >= origin.height) y = origin.height - 1;
							
							pixel = origin.getPixel32(x, y);
							newPixel += (pixel * kernel[(yK + kHeight) * kWidth + (xK + kWidth)]);
						}
					}
					
					outData.setPixel32(xB, yB, newPixel);
					newPixel = 1;
				}
			}
		}
	}
}