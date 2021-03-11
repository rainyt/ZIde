package data;

import zygame.utils.StringUtils;
import zygame.events.ZEvent;
#if electron
import sys.FileSystem;
import sys.io.File;
#end

class ZProjectData {
	/**
	 * 当前ProjectData数据的目录
	 */
	public var rootPath:String = "";

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
	 * 是否横屏
	 * @return Bool
	 */
	public function isLandsapce():Bool {
		return HDWidth > HDHeight;
	}

	public function new(path:String, xml:Xml = null) {
		#if electron
		if (path.indexOf(".xml") != -1) {
			rootPath = path.substr(0, path.lastIndexOf("/"));
		} else {
			rootPath = path;
		}
		baseXml = xml;
		if (baseXml == null) {
			baseXml = Xml.parse(File.getContent(path));
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
					proessFile(assetsPath);
				case "app":
					if (item.exists("hdwidth"))
						HDWidth = Std.parseInt(item.get("hdwidth"));
					if (item.exists("hdheight"))
						HDHeight = Std.parseInt(item.get("hdheight"));
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
					if (Utils.isZBuilderXml(path)) {
						this.builderFiles.push({
							name: path.substr(path.lastIndexOf("/") + 1),
							path: path
						});
					}
					// 普通XML文件
					xmlFiles.set(StringUtils.getName(path), path);
					xmlDatas.set(path, File.getContent(path));
				case "png":
					// 图片文件缓存
					pngFiles.set(StringUtils.getName(path), path);
				case "json":
					jsonFiles.set(StringUtils.getName(path), path);
				case "atlas":
					atlasFiles.set(StringUtils.getName(path), path);
			}
		}
	}
	#end
}
