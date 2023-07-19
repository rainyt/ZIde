import zygame.utils.StringUtils;
import data.ZProjectData;
import zygame.macro.ZMacroUtils;

class TipsPool {
	/**
	 * 项目缓存
	 */
	public static var cacheData:ZProjectData;

	/**
	 * <开头 所有类型返回
	 */
	public var classes:Array<Dynamic> = [];

	/**
	 * </开头 所有类型返回结尾类型
	 */
	public var classesend:Array<Dynamic> = [];

	/**
	 * 属性映射表
	 */
	public var attartMaps:Map<String, Array<Dynamic>> = [];

	public var xmlItemMaps:Map<String, Xml> = [];

	public var childrenMaps:Map<String, Array<Dynamic>> = [];

	public function new() {
		var xml = Xml.parse(ZMacroUtils.readFileContent("tips.xml"));
		for (item in xml.firstElement().elements()) {
			trace("API:", item.nodeName);
			if (!item.exists("igone")) {
				// 暂禁用
				if (false && item.exists("parent")) {
					var p = item.get("parent");
					if (!childrenMaps.exists(p)) {
						childrenMaps.set(p, []);
					}
					childrenMaps.get(p).push(Suggestions.create(item.nodeName, item.nodeName, item.get("tips")));
				} else {
					classes.push(Suggestions.create(item.nodeName, item.nodeName, item.get("tips")));
					classesend.push(Suggestions.create(item.nodeName, item.nodeName, item.get("tips")));
				}
			}
			if (attartMaps.exists(item.nodeName) == false) {
				attartMaps.set(item.nodeName, []);
			}
			// 识别属性
			for (attritem in item.elements()) {
				attartMaps.get(item.nodeName).push(Suggestions.create(attritem.nodeName, attritem.nodeName, attritem.get("tips")));
			}
			xmlItemMaps.set(item.nodeName, item);
		}
		// 处理继承关系
		for (item in xml.firstElement().elements()) {
			if (item.exists("class")) {
				var c = item.get("class");
				extendsClass(item, c);
			}
		}
		trace(childrenMaps);
	}

	/**
	 * 根据Xml联想
	 * @param xmlid 
	 * @return Array<Dynamic>
	 */
	public function getCacheFileMapsByXml(xmlid:String):Array<Dynamic> {
		if (cacheData.xmlFiles.exists(xmlid)) {
			var path = cacheData.xmlFiles.get(xmlid);
			var xml = Xml.parse(cacheData.xmlDatas.get(path));
			var array = [];
			for (item in xml.firstElement().elements()) {
				if (item.exists("name"))
					array.push(Suggestions.create(item.get("name"), item.get("name"), "图集名"));
				else if (item.exists("id")) {
					array.push(Suggestions.create(item.get("id"), item.get("id"), "ID"));
				}
			}
			return array;
		}
		return [];
	}

	/**
	 * 获取缓存联想
	 * @return Array<Dynamic>
	 */
	public function getCacheFileMaps():Array<Dynamic> {
		// if (cacheData == null)
		// 	return [];
		var array = [];
		for (key => value in cacheData.pngFiles) {
			var fileName = StringUtils.getName(value);
			if (fileName.indexOf(".") == 0)
				continue;
			array.push(Suggestions.create(fileName, fileName, StringTools.replace(value, cacheData.rootPath, ""), "Property", null));
		}
		return array;
	}

	/**
	 * 继承关系
	 * @param item 
	 * @param c 
	 */
	public function extendsClass(item:Xml, c:String) {
		var array = attartMaps.get(c);
		for (index => value in array) {
			attartMaps.get(item.nodeName).push(value);
		}
	}
}
