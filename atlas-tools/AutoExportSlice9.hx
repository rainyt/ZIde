import openfl.geom.Matrix;
import haxe.crypto.Base64;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;

/**
 * 自动生成出九宫格图
 */
class AutoExportSlice9 {
	public static function createSlice9(bitmap:BitmapData):Slice9 {
		// 数组算法
		var xArray:Array<String> = [];
		var yArray:Array<String> = [];
		for (i in 0...bitmap.width) {
			xArray.push(Base64.encode(bitmap.getPixels(new Rectangle(i, 0, 1, bitmap.height))));
		}
		for (i in 0...bitmap.height) {
			yArray.push(Base64.encode(bitmap.getPixels(new Rectangle(0, i, bitmap.width, 1))));
		}
		var xdata = proessArray(xArray);
		var ydata = proessArray(yArray);
		trace(xdata, ydata);
		var newBitmapData:BitmapData = new BitmapData(xdata.len, ydata.len, true, 0x0);
		// var newBitmapData:BitmapData = new BitmapData(bitmap.width, bitmap.height, false, 0xff0000);
		var mx:Matrix = new Matrix();
		// 左上
		newBitmapData.draw(bitmap, mx, null, null, new Rectangle(0, 0, xdata.left1, ydata.left1));
		// 左下
		mx.tx = 0;
		mx.ty = -(yArray.length - ydata.len);
		trace("左下", mx.tx, mx.ty);
		newBitmapData.draw(bitmap, mx, null, null, new Rectangle(0, ydata.len - ydata.rightlen, xdata.left1, ydata.rightlen));
		// 右上
		mx.tx = -(xArray.length - xdata.len);
		mx.ty = 0;
		trace("右上", mx.tx, mx.ty);
		newBitmapData.draw(bitmap, mx, null, null, new Rectangle(xdata.len - xdata.rightlen, 0, xdata.rightlen, ydata.left1));
		// 右下
		mx.tx = -(xArray.length - xdata.len);
		mx.ty = -(yArray.length - ydata.len);
		newBitmapData.draw(bitmap, mx, null, null, new Rectangle(xdata.len - xdata.rightlen, ydata.len - ydata.rightlen, xdata.rightlen, ydata.rightlen));
		// 补充缺失块
		if (!xdata.t) {
			trace("Y轴丢失");
			// 上中
			mx.tx = -(xArray.length - xdata.len) - 1;
			mx.ty = 0;
			newBitmapData.draw(bitmap, mx, null, null, new Rectangle(xdata.len - xdata.rightlen - 1, 0, 1, ydata.left1));
			// 下中
			mx.tx = -(xArray.length - xdata.len) - 1;
			mx.ty = -(yArray.length - ydata.len);
			newBitmapData.draw(bitmap, mx, null, null, new Rectangle(xdata.len - xdata.rightlen - 1, ydata.len - ydata.rightlen, 1, ydata.rightlen));
		}

		if (!ydata.t) {
			trace("X轴丢失");
			// 左中
			mx.tx = 0;
			mx.ty = -(yArray.length - ydata.len) - 1;
			newBitmapData.draw(bitmap, mx, null, null, new Rectangle(0, ydata.len - ydata.rightlen - 1, xdata.left1, 1));
			// 右中
			mx.tx = -(xArray.length - xdata.len);
			mx.ty = -(yArray.length - ydata.len) - 1;
			newBitmapData.draw(bitmap, mx, null, null, new Rectangle(xdata.len - xdata.rightlen, ydata.len - ydata.rightlen - 1, xdata.rightlen, 1));
		}

		if (!ydata.t && !xdata.t) {
			// 都缺失的情况下，需要补充中心点
			// 中心
			mx.tx = -(xArray.length - xdata.len) - 1;
			mx.ty = -(yArray.length - ydata.len) - 1;
			newBitmapData.draw(bitmap, mx, null, null, new Rectangle(xdata.len - xdata.rightlen - 1, ydata.len - ydata.rightlen - 1, 1, 1));
		}
		// top right bottom left
		var css = [ydata.left1 + 1, xdata.rightlen + 1, ydata.rightlen + 1, xdata.left1 + 1].join(" ");
		return new Slice9(newBitmapData, css);
	}

	/**
	 * 解析数组
	 * @param array 
	 * @return Dynamic
	 */
	public static function proessArray(array:Array<String>):{
		left1:Int,
		left2:Int,
		right1:Int,
		right2:Int,
		len:Int, // 长度
		rightlen:Int, // 右侧保留的长度
		t:Bool // 是否为偶数
	} {
		var left = 0;
		var right = array.length;
		var endleft = 0;
		var endright = 0;
		var len = 0;
		trace("数组长度", array.length);
		if (array.length % 2 == 0) {
			// 偶数，则直接一半计算
			trace("偶数算法");
			left = Std.int(array.length / 2);
			right = left + 1;
		} else {
			// 奇数，则偏移一位计算
			trace("奇数算法");
			left = Std.int((array.length - 1) / 2);
			right = Std.int((array.length + 1) / 2) + 1;
			len++;
		}
		trace("开始计算：", left, right);
		endleft = left;
		endright = right;
		var currentLeft = array[endleft];
		var currentRight = array[endright];
		while (endleft > 0) {
			endleft--;
			var newLeft = array[endleft];
			if (currentLeft != newLeft) {
				break;
			}
		}
		while (endright < array.length) {
			endright++;
			var newRight = array[endright];
			if (currentRight != newRight) {
				break;
			}
		}
		// len += 2;
		len += endleft;
		len += (array.length - endright);
		trace("计算结果：["
			+ endleft
			+ ","
			+ left
			+ "] ["
			+ right
			+ ","
			+ endright
			+ "] len="
			+ len
			+ " rightlen="
			+ (array.length - endright));
		// 开始减值计算
		return {
			rightlen: array.length - endright,
			t: array.length % 2 == 0,
			len: len,
			left1: endleft,
			left2: left,
			right1: right,
			right2: endright
		};
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
