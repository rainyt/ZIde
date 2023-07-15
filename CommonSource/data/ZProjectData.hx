package data;

import haxe.Exception;
#if (electron || sys)
import sys.FileSystem;
import sys.io.File;
#end

class ZProjectData {
	/**
	 * 当前ProjectData数据的目录
	 */
	public var rootPath:String = "";

	public var rootXmlPath:String = "";

	private var baseXml:Xml;

	/**
	 * ZBuilder格式文件
	 */
	public var builderFiles:Array<{name:String, path:String}> = [];

	/**
	 * PNG文件缓存
	 */
	public var pngFiles:Map<String, String> = [];

	/**
	 * XML文件缓存
	 */
	public var xmlFiles:Map<String, String> = [];

	/**
	 * JSON文件缓存
	 */
	public var jsonFiles:Map<String, String> = [];

	/**
	 * MP3文件缓存
	 */
	public var mp3Files:Map<String, String> = [];

	/**
	 * Atlas文件缓存
	 */
	public var atlasFiles:Map<String, String> = [];

	/**
	 * XML数据缓存
	 */
	public var xmlDatas:Map<String, String> = [];

	/**
	 * 分辨率宽度
	 */
	public var HDWidth:Int = 0;

	/**
	 * 分辨率高度
	 */
	public var HDHeight:Int = 0;

	/**
	 *	舞台颜色值 
	 */
	public var stagecolor:UInt = 0;

	public var assetsPaths:Array<String> = [];

	/**
	 * 是否横屏
	 * @return Bool
	 */
	public function isLandsapce():Bool {
		return HDWidth > HDHeight;
	}

	public function new(path:String, xml:Xml = null) {
		rootXmlPath = path;
		#if electron
		if (path.indexOf(".xml") != -1) {
			rootPath = path.substr(0, path.lastIndexOf("/"));
		} else {
			rootPath = path;
		}
		baseXml = xml;
		if (baseXml == null) {
			#if electron
			baseXml = Xml.parse(File.getContent(path));
			#end
		}
		if (baseXml.nodeType == Element) {
			parserElements(baseXml);
		} else {
			parserElements(baseXml.firstElement());
		}
		#end
	}

	#if electron
	private function parserElements(xml:Xml):Void {
		for (item in xml.elements()) {
			switch (item.nodeName) {
				case "assets":
					var assetsPath = rootPath + "/" + item.get("path");
					if (assetsPaths.indexOf(assetsPath) == -1) {
						assetsPaths.push(assetsPath);
						proessFile(assetsPath);
					}
				case "app":
					if (item.exists("hdwidth"))
						HDWidth = Std.parseInt(item.get("hdwidth"));
					if (item.exists("hdheight"))
						HDHeight = Std.parseInt(item.get("hdheight"));
					if (item.exists("stagecolor"))
						this.stagecolor = Std.parseInt(item.get("stagecolor"));
					else
						this.stagecolor = 0x373737;
			}
		}
	}
	#end

	#if electron
	private function proessFile(path:String):Void {
		if (FileSystem.isDirectory(path)) {
			var files = FileSystem.readDirectory(path);
			for (file in files) {
				proessFile(path + "/" + file);
			}
		} else {
			var type = path.substr(path.lastIndexOf(".") + 1);
			switch (type) {
				case "xml":
					// 判断是否为ZBuilder配置XML
					if (isZBuilderXml(path)) {
						this.builderFiles.push({
							name: path.substr(path.lastIndexOf("/") + 1),
							path: path
						});
					}
					// 普通XML文件
					xmlFiles.set(getName(path), path);
					xmlDatas.set(path, File.getContent(path));
				case "png", "jpg":
					// 图片文件缓存
					pngFiles.set(getName(path), path);
				case "json":
					jsonFiles.set(getName(path), path);
				case "atlas":
					atlasFiles.set(getName(path), path);
				case "mp3":
					mp3Files.set(getName(path), path);
			}
		}
	}
	#end

	/**
	 * 判断是否为ZBuilderXml目录
	 * @param path 
	 * @return Bool
	 */
	public static function isZBuilderXml(path:String):Bool {
		#if electron
		try {
			var xml = Xml.parse(File.getContent(path));
			var nodeName = xml.firstElement().nodeName;
			if (nodeName == "TextureAtlas") {
				return false;
			}
			return true;
		} catch (e:Exception) {}
		#end
		return false;
	}

	public function getName(source:String):String {
		var data = source;
		if (data == null)
			return data;
		data = data.substr(data.lastIndexOf("/") + 1);
		if (data.indexOf(".") != -1)
			data = data.substr(0, data.lastIndexOf("."));
		else if (source.indexOf("http") == 0)
			return source;
		return data;
	}
}
