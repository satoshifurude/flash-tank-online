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
			var sizeW:int = 3;
			var sizeH:int = 3;
			mKernel = createKernel(2.5, sizeW, sizeH);
			mBitmapData = new BitmapData(bmdOrigin.width, bmdOrigin.height, true, 0x0);
			applyGaussianBlur(bmdOrigin, mBitmapData, mKernel, sizeW, sizeH);
			
			var img:Image = Image.fromBitmap(new Bitmap(mBitmapData));
			img.x = 30;
			img.y = 30;
			addChild(img);
			img = Image.fromBitmap(new Bitmap(bmdOrigin));
			img.x = 30 + img.width + 10;
			img.y = 30;
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
			var nr:uint;
			var ng:uint;
			var nb:uint;
			var pixel:uint = 0;
			var x:int;
			var y:int;
			var numOfRow:int = kWidth * 2 + 1;
			for (var yB:int = 0; yB < origin.height; yB++)
			{
				for (var xB:int = 0; xB < origin.width; xB++)
				{
					newPixel = 0;
					nr = 0;
					ng = 0;
					nb = 0;
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
							
							nr += (((pixel >> 16) & 0xff) * kernel[(yK + kHeight) * numOfRow + (xK + kWidth)]);
							ng += (((pixel >> 8) & 0xff) * kernel[(yK + kHeight) * numOfRow + (xK + kWidth)]);
							nb += ((pixel & 0xff) * kernel[(yK + kHeight) * numOfRow + (xK + kWidth)]);
						}
					}
					
					newPixel = (0xff000000 | (nr << 16)) | (ng << 8) | nb;
					outData.setPixel32(xB, yB, newPixel);
				}
			}
			
			trace("done!");
		}
	}
}