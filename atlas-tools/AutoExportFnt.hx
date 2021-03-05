import lime.text.UTF8String;
import neko.Utf8;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import sys.io.File;

class AutoExportFnt {
    
    public static function createFnt(path:String,bitmapData:BitmapData = null):Fnt{
        return new Fnt(path,StringTools.replace(path, ".png", ".fnt"),bitmapData);
    }

}

class Fnt {

    public var maps:Map<String,BitmapData> = [];
    
    public function new(file:String,fnt:String,bitmapData:BitmapData) {
        var fntContent:UTF8String = File.getContent(fnt);
        trace("字列表：",fntContent);
        var bitmapData = bitmapData != null?bitmapData:BitmapData.fromFile(file);
        // 是否开始剪切
        var isStartCut:Bool = false;
        var ix:Int = 0;
        // 字的索引
        var index:Int = 0;
        // 开始剪切的位置
        var cutX:Int = 0;
        // 结束剪切的位置
        var endX:Int = 0;
        // 从左侧开始计算
		while (ix < bitmapData.width) {
            // trace(bitmapData.width - 1,ix,isStartCut);
			if (!isAlpha(bitmapData.getPixels(new Rectangle(ix, 0, 1, bitmapData.height))) && ix != bitmapData.width - 1) {
				if(!isStartCut){
                    //开始剪切
                    isStartCut = true;
                    cutX = ix;
                }
            }
            else if(isStartCut)
            {
                //透明处理
                isStartCut = false;
                endX = ix;
                //开始保存
                var fntBitmapData = new BitmapData(endX - cutX,bitmapData.height,true,0x0);
                fntBitmapData.copyPixels(bitmapData,new Rectangle(cutX,0,endX - cutX,bitmapData.height),new Point());
                maps.set(Utf8.sub(fntContent,index,1),fntBitmapData);
                // trace("剪切结束，字是：",Utf8.sub(fntContent,index,1),cutX,endX);
                index ++;
            }
            ix ++;
		}
    }

    public static function isAlpha(array:ByteArray):Bool {
		for (i in 0...array.length) {
			if (array[i] != 0)
				return false;
		}
		return true;
	}

}