import openfl.geom.Matrix;
import haxe.crypto.Base64;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;

/**
 * 自动生成出九宫格图
 */
class AutoExportSlice9 {
	public static function createSlice9(bitmap:BitmapData):Slice9 {
		trace("扫描九宫格");
		var lastXLen:String = null;
		var isStartX:Bool = false;
		var isEndX:Bool = false;
		var startX:Int = 0;
		var endX:Int = 0;

		var lastYLen:String = null;
		var isStartY:Bool = false;
		var isEndY:Bool = false;
		var startY:Int = 0;
		var endY:Int = 0;

		// 新版算法
        var twoWidth:Int = Std.int(bitmap.width / 2);
        var ix:Int = 0;
        lastXLen = Base64.encode(bitmap.getPixels(new Rectangle(twoWidth, 0, 1, bitmap.height)));
		while (ix < twoWidth) {
            ix ++;
            var curXLenA = Base64.encode(bitmap.getPixels(new Rectangle(twoWidth - ix,0,1,bitmap.height)));
            var curXLenB = Base64.encode(bitmap.getPixels(new Rectangle(twoWidth + ix,0,1,bitmap.height)));
			if (!isStartX && curXLenA != lastXLen) {
                isStartX = true;
                startX = twoWidth - ix - 1;
            }
            if (!isEndX && curXLenB != lastXLen) {
                isEndX = true;
                endX = twoWidth + ix + 1;
            }
		}
        var twoHeight:Int = Std.int(bitmap.height / 2);
        lastYLen = Base64.encode(bitmap.getPixels(new Rectangle(0,twoHeight,bitmap.width,1)));
        var iy:Int = 0;
		while (iy < twoHeight) {
            iy ++;
            var curXLenA = Base64.encode(bitmap.getPixels(new Rectangle(0,twoHeight - iy,bitmap.width,1)));
            var curXLenB = Base64.encode(bitmap.getPixels(new Rectangle(0,twoHeight + iy,bitmap.width,1)));
			if (!isStartY && curXLenA != lastYLen) {
                isStartY = true;
                startY = twoHeight - iy - 1;
            }
            if (!isEndY && curXLenB != lastYLen) {
                isEndY = true;
                endY = twoHeight + iy + 1;
            }
		}

		// 旧版算法

		// for(ix in 0...bitmap.width){
		//     if(lastXLen == null){
		//         lastXLen = Base64.encode(bitmap.getPixels(new Rectangle(ix,0,1,bitmap.height)));
		//         continue;
		//     }
		//     var curXLen = Base64.encode(bitmap.getPixels(new Rectangle(ix,0,1,bitmap.height)));
		//     if(curXLen == lastXLen){
		//         if(isStartX){
		//             //相等，记录第一个点
		//             startX = ix - 1;
		//             isStartX = false;
		//         }
		//     }
		//     else if(!isStartX){
		//         //不再相等，计算最后一个点
		//         endX = ix - 1;
		//         break;
		//     }
		//     lastXLen = curXLen;
		// }

		// for(iy in 0...bitmap.height){
		//     if(lastYLen == null){
		//         lastYLen = Base64.encode(bitmap.getPixels(new Rectangle(0,iy,bitmap.width,1)));
		//         continue;
		//     }
		//     var curYLen = Base64.encode(bitmap.getPixels(new Rectangle(0,iy,bitmap.width,1)));
		//     if(curYLen == lastYLen){
		//         if(isStartY){
		//             //相等，记录第一个点
		//             startY = iy - 1;
		//             isStartY = false;
		//         }
		//     }
		//     else if(!isStartY){
		//         //不再相等，计算最后一个点
		//         endY = iy - 1;
		//         break;
		//     }
		//     lastYLen = curYLen;
		// }

		if (startX == 0 && endX == 0 && startY == 0 && endY == 0) {
			var newBitmapData:BitmapData = new BitmapData(4, 4, true, 0x0);
			newBitmapData.draw(bitmap, null, null, new Rectangle(0, 0, 4, 4));
			return new Slice9(newBitmapData, "1 1 1 1");
		}
		trace("x结果：", startX, endX, startY, endY);
		var css = [startY, bitmap.width - endX, bitmap.height - endY, startX].join(" ");
		trace("生成CSS：", css);
		// 创建出新的位图
		var newBitmapData:BitmapData = new BitmapData(bitmap.width - (endX - startX) + 4, bitmap.height - (endY - startY) + 4, true, 0x0);
		// var newBitmapData:BitmapData = new BitmapData(bitmap.width,bitmap.height,true,0x0);
		// 左上
		var mx:Matrix = new Matrix();
		newBitmapData.draw(bitmap, mx, null, null, new Rectangle(0, 0, startX, startY));
		// 左下
		mx.tx = 0;
		mx.ty = -endY + startY + 4;
		newBitmapData.draw(bitmap, mx, null, null, new Rectangle(0, startY, startX + 4, bitmap.height - endY + 4));
		// 右上
		mx.tx = -endX + startX + 4;
		mx.ty = 0;
		newBitmapData.draw(bitmap, mx, null, null, new Rectangle(startX, 0, bitmap.width - endX + 4, startY));
		// 右下
		mx.tx = -endX + startX + 4;
		mx.ty = -endY + startY + 4;
		newBitmapData.draw(bitmap, mx, null, null, new Rectangle(startX, startY, bitmap.width - endX + 4, bitmap.height - endY + 4));
		return new Slice9(newBitmapData, css);
	}
}

class Slice9 {
	public var bitmapData:BitmapData;

	public var css:String;

	public function new(bitmapData:BitmapData, css:String):Void {
		this.bitmapData = bitmapData;
		this.css = css;
	}
}
