import openfl.geom.Rectangle;
import AutoExportCut;
import AutoExportSlice9.Slice9;
import openfl.display.PNGEncoderOptions;
import sys.io.File;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import sys.FileSystem;

class Main {
	static function main() {
		var args = Sys.args();
		trace("创建图集", args, Sys.programPath());
		var isCreateFnt = args[0] == "-fnt";
		if (isCreateFnt)
			args.shift();
		var xml:Xml = Xml.createDocument();
		var textureXml:Xml = Xml.createElement("TextureAtlas");
		textureXml.set("build", "Use zyeditui create.");
		xml.insertChild(textureXml, 0);
		var pwidth = 2048;
		var pheight = 2048;
		if (args[2] != null)
			pwidth = Std.parseInt(args[2]);
		var atlas = new MaxRectsBinPack(pwidth, pheight, false);
		var atlasBitmap:BitmapData = new BitmapData(2048, 2048, true, 0x0);
		// 九宫格图
		var atlasBitmapScale9:BitmapData = null;
		var read = args[0];
		var out = read + "/" + args[1];
		out = StringTools.replace(out, "//", "/");
		var files:Array<String> = FileSystem.readDirectory(args[0]);
		var minWidth:Int = 256;
		var minHeight:Int = 256;
		var xmlIndex:Int = 0;
		for (file in files) {
			if (file.indexOf(".") == 0
				|| file.indexOf(".png") == -1
				|| FileSystem.exists(read + "/" + StringTools.replace(file, ".png", ".xml")))
				continue;
			var isFnt = false;
			if (FileSystem.exists(read + "/" + StringTools.replace(file, ".png", ".fnt"))) {
				if (isCreateFnt) {
					// 字符格式
					var fnt = AutoExportFnt.createFnt(read + "/" + file);
					var dir = read + "/" + StringTools.replace(file, ".png", "");
					if (!FileSystem.exists(dir)) {
						FileSystem.createDirectory(dir);
					}
					for (key => value in fnt.maps) {
						var png = new PNGEncoderOptions();
						var bytes = value.encode(value.rect, png);
						File.saveBytes(read + "/" + StringTools.replace(file, ".png", "/" + key + ".png"), bytes);
					}
					continue;
				}
				isFnt = true;
			} else if (isCreateFnt) {
				// 只创建Fnt时，其他行为直接过滤
				continue;
			}

			var newBitmap = BitmapData.fromFile(read + "/" + file);
			trace("检查：", file);
			var slice:Slice9 = null;
			var cut:CutImage = null;
			if (isFnt) {
				// 字符格式
				var fnt = AutoExportFnt.createFnt(read + "/" + file, newBitmap);
				var fontName = file.substr(0, file.lastIndexOf("."));
				if (fontName.indexOf("#") != -1)
					fontName = fontName.substr(0, fontName.lastIndexOf("#"));
				for (key => value in fnt.maps) {
					newBitmap = value;
					// trace("install",newBitmap.width,newBitmap.height);
					var rect = addToPack(atlas, newBitmap.width + 2, newBitmap.height + 2);
					if (rect.width == 0 || rect.height == 0)
						continue;
					rect.x++;
					rect.y++;
					rect.width -= 2;
					rect.height -= 2;
					var m:Matrix = new Matrix();
					m.tx = rect.x;
					m.ty = rect.y;
					var mwidth = minSize(rect.x + rect.width);
					var mheight = minSize(rect.y + rect.height);
					if (mwidth > minWidth)
						minWidth = mwidth;
					if (mheight > minHeight)
						minHeight = mheight;
					if (newBitmap != null) {
						atlasBitmap.draw(newBitmap, m);
					}
					var a = Xml.createElement("SubTexture");
					a.set("width", Std.string(rect.width));
					a.set("height", Std.string(rect.height));
					a.set("x", Std.string(rect.x));
					a.set("y", Std.string(rect.y));
					a.set("name", fontName + key);
					if (slice != null)
						a.set("slice9", slice.css);
					if (cut != null) {
						a.set("frameX", Std.string(-cut.rect.x + 1));
						a.set("frameY", Std.string(-cut.rect.y + 1));
						a.set("frameWidth", Std.string(cut.rect.width));
						a.set("frameHeight", Std.string(cut.rect.height));
					}
					// trace("a",a);
					textureXml.insertChild(a, xmlIndex);
					xmlIndex++;
				}
				continue;
			} else if (file.indexOf("s9_") != -1) {
				slice = AutoExportSlice9.createSlice9(newBitmap);
				newBitmap = slice.bitmapData;
			} else {
				cut = AutoExportCutImage.createCutImage(newBitmap);
				if (cut != null) {
					newBitmap = cut.bitmapData;
				}
			}
			var rect = addToPack(atlas, newBitmap.width + 2, newBitmap.height + 2);
			if (rect.width == 0 || rect.height == 0)
				continue;
			rect.x++;
			rect.y++;
			rect.width -= 2;
			rect.height -= 2;
			var m:Matrix = new Matrix();
			m.tx = rect.x;
			m.ty = rect.y;
			var mwidth = minSize(rect.x + rect.width);
			var mheight = minSize(rect.y + rect.height);
			if (mwidth > minWidth)
				minWidth = mwidth;
			if (mheight > minHeight)
				minHeight = mheight;
			if (newBitmap != null) {
				if (file.indexOf("s9_") != -1) {
					if (atlasBitmapScale9 == null)
						atlasBitmapScale9 = new BitmapData(2048, 2048, true, 0x0);
					atlasBitmapScale9.draw(newBitmap, m);
				} else
					atlasBitmap.draw(newBitmap, m);
			}
			var a = Xml.createElement("SubTexture");
			a.set("width", Std.string(rect.width));
			a.set("height", Std.string(rect.height));
			a.set("x", Std.string(rect.x));
			a.set("y", Std.string(rect.y));
			a.set("name", file.substr(0, file.lastIndexOf(".")));
			if (slice != null)
				a.set("slice9", slice.css);
			if (cut != null) {
				a.set("frameX", Std.string(-cut.rect.x + 1));
				a.set("frameY", Std.string(-cut.rect.y + 1));
				a.set("frameWidth", Std.string(cut.rect.width));
				a.set("frameHeight", Std.string(cut.rect.height));
			}
			textureXml.insertChild(a, xmlIndex);
			xmlIndex++;
			FileSystem.deleteFile(read + "/" + file);
		}
		if (isCreateFnt)
			return;
		// 剪切
		if (minWidth != 2048 || minHeight != 2048) {
			var newAtlasBitmap:BitmapData = new BitmapData(minWidth, minHeight, true, 0x0);
			newAtlasBitmap.draw(atlasBitmap);
			atlasBitmap = newAtlasBitmap;
		}
		var png = new PNGEncoderOptions();
		var bytes = atlasBitmap.encode(atlasBitmap.rect, png);
		File.saveBytes(out + ".png", bytes);
		File.saveContent(out + ".xml", xml.toString());

		// if(atlasBitmapScale9 != null){
		// 	//储存九宫格
		// 	var s9_bytes = atlasBitmapScale9.encode(atlasBitmapScale9.rect,png);
		// 	File.saveBytes(out + "_s9.png", s9_bytes);
		// }
		// 开始压缩计算
		trace("压缩png", Sys.programPath(), "./pngquant/pngquant --force --speed=1 " + out + ".png");
		var path = Sys.programPath();
		path = StringTools.replace(path, "\\", "/");
		path = path.substr(0, path.lastIndexOf("/"));
		Sys.command(path + "/pngquant/pngquant" + (Sys.systemName() == "Windows" ? ".exe" : "") + " --force --speed=1 " + out + ".png");
		// if (atlasBitmapScale9 != null) {
		// 	var pngfs8:BitmapData = BitmapData.fromFile(out + "-fs8.png");
		// 	pngfs8.draw(atlasBitmapScale9);
		// 	var png = new PNGEncoderOptions();
		// 	var bytes = pngfs8.encode(pngfs8.rect, png);
		// 	File.saveBytes(out + "-s9.png", bytes);
		// 	FileSystem.deleteFile(out + "-fs8.png");
		// 	FileSystem.deleteFile(out + ".png");
		// 	FileSystem.rename(out + "-s9.png", out + ".png");
		// 	// Sys.command(Sys.programPath().substr(0,Sys.programPath().lastIndexOf("/")) + "/pngquant/pngquant --force --speed=1 "+ out + "-s9.png");
		// 	// FileSystem.rename(out + "-s9-fs8.png",out + ".png");
		// 	// FileSystem.deleteFile(out + "-s9.png");
		// 	trace("合并九宫格图完毕");
		// } else {
		if (FileSystem.exists(out + "-fs8.png")) {
			FileSystem.deleteFile(out + ".png");
			FileSystem.rename(out + "-fs8.png", out + ".png");
		}
		// }
	}

	public static function addToPack(atlas:MaxRectsBinPack, width:Int, height:Int):Rectangle {
		var rect = atlas.insert(width, height, MaxRectsBinPack.FreeRectangleChoiceHeuristic.BestAreaFit);
		return rect;
	}

	public static function minSize(size:Float):Int {
		var maxi:Int = 0;
		var sizes = [256, 512, 1024, 2048];
		for (item in sizes) {
			if (size > item) {
				maxi++;
			}
		}
		return sizes[maxi];
	}
}
