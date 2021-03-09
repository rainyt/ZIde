import zygame.macro.ZMacroUtils;

class TipsPool {
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

	public function new() {
		var xml = Xml.parse(ZMacroUtils.readFileContent("tips.xml"));
		for (item in xml.firstElement().elements()) {
			trace("API:", item.nodeName);
			if (!item.exists("igone")) {
				classes.push(Suggestions.create(item.nodeName, item.nodeName, item.get("tips")));
				classesend.push(Suggestions.create(item.nodeName, item.nodeName, item.get("tips")));
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

		// trace("classes=", classes);
		// trace("attartMaps=", attartMaps);
	}

	/**
	 * 继承关系
	 * @param item 
	 * @param c 
	 */
	public function extendsClass(item:Xml, c:String) {
		trace("继承", item.nodeName, c);
		var array = attartMaps.get(c);
		for (index => value in array) {
            trace("push",value.label);
			attartMaps.get(item.nodeName).push(value);
		}
	}
}
