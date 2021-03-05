import openfl.geom.Point;
import openfl.utils.ByteArray;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;

class AutoExportCutImage {
	public static function createCutImage(bitmapData:BitmapData):CutImage {
		var left:Int = 0;
		var top:Int = 0;
		var right:Int = 0;
		var bottom:Int = 0;
		// 左侧计算
		while (true) {
			if (!isAlpha(bitmapData.getPixels(new Rectangle(left, 0, 1, bitmapData.height)))) {
				break;
			}
			left++;
		}
		// 右侧计算
		while (true) {
			if (!isAlpha(bitmapData.getPixels(new Rectangle(bitmapData.width - right, 0, 1, bitmapData.height)))) {
				break;
			}
			right++;
		}
		// 上侧计算
		while (true) {
			if (!isAlpha(bitmapData.getPixels(new Rectangle(0, top, bitmapData.width, 1)))) {
				break;
			}
			top++;
		}
		// 下侧计算
		while (true) {
			if (!isAlpha(bitmapData.getPixels(new Rectangle(0, bitmapData.height - bottom, bitmapData.width, 1)))) {
				break;
			}
			bottom++;
		}
        // trace("切割处理", left, top, right, bottom);
        if(left == 0 && top == 0 && right <= 1 && bottom <= 1)
            return null;
        //可切割，生成新的位图
        var newBitmapData:BitmapData = new BitmapData(bitmapData.width - left - right,bitmapData.height - top - bottom,true,0);
        newBitmapData.copyPixels(bitmapData,new Rectangle(left,top,newBitmapData.width,newBitmapData.height),new Point());
		return new CutImage(newBitmapData,left,top,bitmapData.width,bitmapData.height);
	}

	public static function isAlpha(array:ByteArray):Bool {
		for (i in 0...array.length) {
			if (array[i] != 0)
				return false;
		}
		return true;
	}
}

class CutImage {
	public var bitmapData:BitmapData;

	public var rect:Rectangle;

	public function new(bitmapData:BitmapData, frameX:Int, frameY:Int, frameWidth:Int, frameHeight:Int) {
		this.bitmapData = bitmapData;
		this.rect = new Rectangle(frameX, frameY, frameWidth, frameHeight);
	}
}
