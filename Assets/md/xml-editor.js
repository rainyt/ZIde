(function ($hx_exports, $global) { "use strict";
function $extend(from, fields) {
	var proto = Object.create(from);
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var HxOverrides = function() { };
HxOverrides.__name__ = "HxOverrides";
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) {
		return undefined;
	}
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(len == null) {
		len = s.length;
	} else if(len < 0) {
		if(pos == 0) {
			len = s.length + len;
		} else {
			return "";
		}
	}
	return s.substr(pos,len);
};
HxOverrides.remove = function(a,obj) {
	var i = a.indexOf(obj);
	if(i == -1) {
		return false;
	}
	a.splice(i,1);
	return true;
};
HxOverrides.now = function() {
	return Date.now();
};
Math.__name__ = "Math";
var Reflect = function() { };
Reflect.__name__ = "Reflect";
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( _g ) {
		return null;
	}
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) {
			a.push(f);
		}
		}
	}
	return a;
};
var Std = function() { };
Std.__name__ = "Std";
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
Std.parseInt = function(x) {
	if(x != null) {
		var _g = 0;
		var _g1 = x.length;
		while(_g < _g1) {
			var i = _g++;
			var c = x.charCodeAt(i);
			if(c <= 8 || c >= 14 && c != 32 && c != 45) {
				var nc = x.charCodeAt(i + 1);
				var v = parseInt(x,nc == 120 || nc == 88 ? 16 : 10);
				if(isNaN(v)) {
					return null;
				} else {
					return v;
				}
			}
		}
	}
	return null;
};
var StringBuf = function() {
	this.b = "";
};
StringBuf.__name__ = "StringBuf";
StringBuf.prototype = {
	__class__: StringBuf
};
var StringTools = function() { };
StringTools.__name__ = "StringTools";
StringTools.htmlEscape = function(s,quotes) {
	var buf_b = "";
	var _g_offset = 0;
	var _g_s = s;
	while(_g_offset < _g_s.length) {
		var s = _g_s;
		var index = _g_offset++;
		var c = s.charCodeAt(index);
		if(c >= 55296 && c <= 56319) {
			c = c - 55232 << 10 | s.charCodeAt(index + 1) & 1023;
		}
		var c1 = c;
		if(c1 >= 65536) {
			++_g_offset;
		}
		var code = c1;
		switch(code) {
		case 34:
			if(quotes) {
				buf_b += "&quot;";
			} else {
				buf_b += String.fromCodePoint(code);
			}
			break;
		case 38:
			buf_b += "&amp;";
			break;
		case 39:
			if(quotes) {
				buf_b += "&#039;";
			} else {
				buf_b += String.fromCodePoint(code);
			}
			break;
		case 60:
			buf_b += "&lt;";
			break;
		case 62:
			buf_b += "&gt;";
			break;
		default:
			buf_b += String.fromCodePoint(code);
		}
	}
	return buf_b;
};
StringTools.isSpace = function(s,pos) {
	var c = HxOverrides.cca(s,pos);
	if(!(c > 8 && c < 14)) {
		return c == 32;
	} else {
		return true;
	}
};
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) ++r;
	if(r > 0) {
		return HxOverrides.substr(s,r,l - r);
	} else {
		return s;
	}
};
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) ++r;
	if(r > 0) {
		return HxOverrides.substr(s,0,l - r);
	} else {
		return s;
	}
};
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
};
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
};
var Suggestions = function() { };
Suggestions.__name__ = "Suggestions";
Suggestions.create = function(label,insertText,detail,className,filterText) {
	if(className == null) {
		className = "Property";
	}
	return { label : label, insertText : insertText, detail : detail, filterText : filterText, kind : monaco.languages.CompletionItemKind[className], insertTextRules : monaco.languages.CompletionItemInsertTextRule.KeepWhitespace};
};
var TipsPool = function() {
	this.childrenMaps = new haxe_ds_StringMap();
	this.xmlItemMaps = new haxe_ds_StringMap();
	this.attartMaps = new haxe_ds_StringMap();
	this.classesend = [];
	this.classes = [];
	var xml = Xml.parse("<tips>\n    <Base igone=\"true\">\n        <id tips=\"设置ID标示\" />\n        <width tips=\"宽度\" />\n        <height tips=\"高度\" />\n        <scaleX tips=\"ScaleX缩放\" />\n        <scaleY tips=\"ScaleY缩放\" />\n        <alpha tips=\"透明度\" />\n        <x tips=\"X轴坐标\" />\n        <y tips=\"Y轴坐标\" />\n        <visible tips=\"可见\" />\n        <left tips=\"左对齐\" />\n        <right tips=\"右对齐\" />\n        <top tips=\"顶部对齐\" />\n        <bottom tips=\"底部对齐\" />\n        <centerX tips=\"横向对齐\" />\n        <centerY tips=\"垂直对齐\" />\n    </Base>\n    <BaseBox class=\"Base\" igone=\"true\">\n        <gap tips=\"间隔\" />\n    </BaseBox>\n    <ZImage class=\"Base\" tips=\"图像对象\">\n        <src tips=\"设置图像，支持网络地址、图集地址\" />\n    </ZImage>\n    <ZBox class=\"Base\" tips=\"基本容器\"></ZBox>\n    <ZStack class=\"ZBox\">\n        <currentId tips=\"设置当前显示的ID\" />\n    </ZStack>\n    <VBox class=\"BaseBox\" tips=\"基本容器(竖向)\"></VBox>\n    <HBox class=\"BaseBox\" tips=\"基本容器(横向)\"></HBox>\n    <ZQuad class=\"Base\" tips=\"色块\">\n        <color tips=\"颜色\" />\n    </ZQuad>\n    <ZLabel class=\"Base\" tips=\"文本\">\n        <text tips=\"文本\" />\n        <color tips=\"文本颜色\" />\n        <size tips=\"文本大小\" />\n        <fontName tips=\"文本字体\" />\n        <wordWrap tips=\"是否自动换行\" />\n    </ZLabel>\n    <ZInputLabel class=\"ZLabel\" tips=\"输入文本框\"></ZInputLabel>\n    <ZTween tips=\"动画\">\n        <auto tips=\"自动播放(Bool)\" />\n    </ZTween>\n    <ZSpine class=\"Base\" tips=\"Spine动画\">\n        <action tips=\"动画名\" />\n        <isLoop tips=\"是否循环播放\" />\n    </ZSpine>\n    <ZScroll class=\"Base\" tips=\"Scroll窗口\">\n        <vscrollState tips=\"竖向滑行\" />\n        <hscrollState tips=\"横向滑行\" />\n    </ZScroll>\n    <ZList class=\"Base\" tips=\"数据列表窗口\"></ZList>\n    <ZButton class=\"Base\" tips=\"按钮\">\n        <src tips=\"设置图像\" />\n        <text tips=\"设置按钮文案\" />\n        <size tips=\"设置文案大小\" />\n    </ZButton>\n    <ZBitmapLabel class=\"ZLabel\" tips=\"位图文本\">\n        <src tips=\"设置图集或者Fnt\" />\n    </ZBitmapLabel>\n    <ImageBatchs class=\"Base\" tips=\"批渲染对象（无触摸）\">\n        <src tips=\"设置图集\" />\n    </ImageBatchs>\n    <TouchImageBatchsContainer class=\"ImageBatchs\" tips=\"批渲染对象（含触摸）\"></TouchImageBatchsContainer>\n    <BButton class=\"Base\" tips=\"批渲染按钮\">\n        <src tips=\"设置图集\" />\n    </BButton>\n    <BBox class=\"Base\" tips=\"批渲染布局\"></BBox>\n    <VBBox class=\"Base\" tips=\"批渲染布局V\"></VBBox>\n    <HBBox class=\"Base\" tips=\"批渲染布局H\"></HBBox>\n    <BImage class=\"Base\" tips=\"批渲染图片\">\n        <src tips=\"设置图集\" />\n    </BImage>\n    <BScale9Image class=\"Base\" tips=\"批渲染图片（九宫格）\"></BScale9Image>\n    <BLabel class=\"Base\" tips=\"批渲染文本\">\n        <src tips=\"设置图集或者Fnt\" />\n        <fontName tips=\"文本字体\" />\n        <size tips=\"文本大小\" />\n    </BLabel>\n    <add parent=\"ZTween\" tips=\"递增动画\">\n        <bind tips=\"绑定ID值\" />\n        <key tips=\"修改的属性\" />\n        <start tips=\"开始帧\" />\n        <end tips=\"结束帧\" />\n        <to tips=\"修改值\" />\n        <type tips=\"类型\" />\n    </add>\n    <tween parent=\"ZTween\" class=\"add\" tips=\"过渡动画\">\n        <from tips=\"初始值\" />\n    </tween>\n    <ZHaxe tips=\"HScript\">\n        <id tips=\"调用名\" />\n    </ZHaxe>\n    <ZSound tips=\"音频\">\n        <id tips=\"调用名\" />\n        <src tips=\"音频ID\" />\n    </ZSound>\n    <ZParticles class=\"Base\">\n        <src tips=\"设置粒子的图片:JSON数据\" />\n    </ZParticles>\n    <BStack class=\"BBox\">\n        <currentId tips=\"设置当前显示的ID\" />\n    </BStack>\n    <ZCacheBitmapLabel class=\"ZLabel\"></ZCacheBitmapLabel>\n</tips>");
	var item = xml.firstElement().elements();
	while(item.hasNext()) {
		var item1 = item.next();
		var tmp = haxe_Log.trace;
		if(item1.nodeType != Xml.Element) {
			throw haxe_Exception.thrown("Bad node type, expected Element but found " + (item1.nodeType == null ? "null" : XmlType.toString(item1.nodeType)));
		}
		tmp("API:",{ fileName : "TipsPool.hx", lineNumber : 33, className : "TipsPool", methodName : "new", customParams : [item1.nodeName]});
		if(!item1.exists("igone")) {
			var tmp1 = this.classes;
			if(item1.nodeType != Xml.Element) {
				throw haxe_Exception.thrown("Bad node type, expected Element but found " + (item1.nodeType == null ? "null" : XmlType.toString(item1.nodeType)));
			}
			if(item1.nodeType != Xml.Element) {
				throw haxe_Exception.thrown("Bad node type, expected Element but found " + (item1.nodeType == null ? "null" : XmlType.toString(item1.nodeType)));
			}
			tmp1.push(Suggestions.create(item1.nodeName,item1.nodeName,item1.get("tips")));
			var tmp3 = this.classesend;
			if(item1.nodeType != Xml.Element) {
				throw haxe_Exception.thrown("Bad node type, expected Element but found " + (item1.nodeType == null ? "null" : XmlType.toString(item1.nodeType)));
			}
			if(item1.nodeType != Xml.Element) {
				throw haxe_Exception.thrown("Bad node type, expected Element but found " + (item1.nodeType == null ? "null" : XmlType.toString(item1.nodeType)));
			}
			tmp3.push(Suggestions.create(item1.nodeName,item1.nodeName,item1.get("tips")));
		}
		var this1 = this.attartMaps;
		if(item1.nodeType != Xml.Element) {
			throw haxe_Exception.thrown("Bad node type, expected Element but found " + (item1.nodeType == null ? "null" : XmlType.toString(item1.nodeType)));
		}
		if(Object.prototype.hasOwnProperty.call(this1.h,item1.nodeName) == false) {
			var this2 = this.attartMaps;
			if(item1.nodeType != Xml.Element) {
				throw haxe_Exception.thrown("Bad node type, expected Element but found " + (item1.nodeType == null ? "null" : XmlType.toString(item1.nodeType)));
			}
			this2.h[item1.nodeName] = [];
		}
		var attritem = item1.elements();
		while(attritem.hasNext()) {
			var attritem1 = attritem.next();
			var this3 = this.attartMaps;
			if(item1.nodeType != Xml.Element) {
				throw haxe_Exception.thrown("Bad node type, expected Element but found " + (item1.nodeType == null ? "null" : XmlType.toString(item1.nodeType)));
			}
			var tmp5 = this3.h[item1.nodeName];
			if(attritem1.nodeType != Xml.Element) {
				throw haxe_Exception.thrown("Bad node type, expected Element but found " + (attritem1.nodeType == null ? "null" : XmlType.toString(attritem1.nodeType)));
			}
			if(attritem1.nodeType != Xml.Element) {
				throw haxe_Exception.thrown("Bad node type, expected Element but found " + (attritem1.nodeType == null ? "null" : XmlType.toString(attritem1.nodeType)));
			}
			tmp5.push(Suggestions.create(attritem1.nodeName,attritem1.nodeName,attritem1.get("tips")));
		}
		var this4 = this.xmlItemMaps;
		if(item1.nodeType != Xml.Element) {
			throw haxe_Exception.thrown("Bad node type, expected Element but found " + (item1.nodeType == null ? "null" : XmlType.toString(item1.nodeType)));
		}
		this4.h[item1.nodeName] = item1;
	}
	var item = xml.firstElement().elements();
	while(item.hasNext()) {
		var item1 = item.next();
		if(item1.exists("class")) {
			var c = item1.get("class");
			this.extendsClass(item1,c);
		}
	}
	haxe_Log.trace(this.childrenMaps == null ? "null" : haxe_ds_StringMap.stringify(this.childrenMaps.h),{ fileName : "TipsPool.hx", lineNumber : 63, className : "TipsPool", methodName : "new"});
};
TipsPool.__name__ = "TipsPool";
TipsPool.prototype = {
	getCacheFileMapsByXml: function(xmlid) {
		if(Object.prototype.hasOwnProperty.call(TipsPool.cacheData.xmlFiles.h,xmlid)) {
			haxe_Log.trace("xmlid=" + xmlid,{ fileName : "TipsPool.hx", lineNumber : 73, className : "TipsPool", methodName : "getCacheFileMapsByXml"});
			var path = TipsPool.cacheData.xmlFiles.h[xmlid];
			var xml = Xml.parse(TipsPool.cacheData.xmlDatas.h[path]);
			var array = [];
			var item = xml.firstElement().elements();
			while(item.hasNext()) {
				var item1 = item.next();
				array.push(Suggestions.create(item1.get("name"),item1.get("name"),"图集名"));
			}
			return array;
		}
		return [];
	}
	,getCacheFileMaps: function() {
		var array = [];
		var h = TipsPool.cacheData.pngFiles.h;
		var _g_h = h;
		var _g_keys = Object.keys(h);
		var _g_length = _g_keys.length;
		var _g_current = 0;
		while(_g_current < _g_length) {
			var key = _g_keys[_g_current++];
			var _g1_key = key;
			var _g1_value = _g_h[key];
			var key1 = _g1_key;
			var value = _g1_value;
			var fileName = zygame_utils_StringUtils.getName(value);
			if(fileName.indexOf(".") == 0) {
				continue;
			}
			array.push(Suggestions.create(fileName,fileName,StringTools.replace(value,TipsPool.cacheData.rootPath,""),"Property",null));
		}
		return array;
	}
	,extendsClass: function(item,c) {
		var array = this.attartMaps.h[c];
		var _g_current = 0;
		var _g_array = array;
		while(_g_current < _g_array.length) {
			var _g1_value = _g_array[_g_current];
			var _g1_key = _g_current++;
			var index = _g1_key;
			var value = _g1_value;
			var this1 = this.attartMaps;
			if(item.nodeType != Xml.Element) {
				throw haxe_Exception.thrown("Bad node type, expected Element but found " + (item.nodeType == null ? "null" : XmlType.toString(item.nodeType)));
			}
			this1.h[item.nodeName].push(value);
		}
	}
	,__class__: TipsPool
};
var TweenApi = function() { };
TweenApi.__name__ = "TweenApi";
TweenApi.returnSuggestions = function() {
	var array = [];
	var _g_current = 0;
	var _g_array = TweenApi._type;
	while(_g_current < _g_array.length) {
		var _g1_value = _g_array[_g_current];
		var _g1_key = _g_current++;
		var index = _g1_key;
		var value = _g1_value;
		array.push(Suggestions.create(value,value,value));
	}
	return array;
};
var XmlType = {};
XmlType.toString = function(this1) {
	switch(this1) {
	case 0:
		return "Element";
	case 1:
		return "PCData";
	case 2:
		return "CData";
	case 3:
		return "Comment";
	case 4:
		return "DocType";
	case 5:
		return "ProcessingInstruction";
	case 6:
		return "Document";
	}
};
var Xml = function(nodeType) {
	this.nodeType = nodeType;
	this.children = [];
	this.attributeMap = new haxe_ds_StringMap();
};
Xml.__name__ = "Xml";
Xml.parse = function(str) {
	return haxe_xml_Parser.parse(str);
};
Xml.createElement = function(name) {
	var xml = new Xml(Xml.Element);
	if(xml.nodeType != Xml.Element) {
		throw haxe_Exception.thrown("Bad node type, expected Element but found " + (xml.nodeType == null ? "null" : XmlType.toString(xml.nodeType)));
	}
	xml.nodeName = name;
	return xml;
};
Xml.createPCData = function(data) {
	var xml = new Xml(Xml.PCData);
	if(xml.nodeType == Xml.Document || xml.nodeType == Xml.Element) {
		throw haxe_Exception.thrown("Bad node type, unexpected " + (xml.nodeType == null ? "null" : XmlType.toString(xml.nodeType)));
	}
	xml.nodeValue = data;
	return xml;
};
Xml.createCData = function(data) {
	var xml = new Xml(Xml.CData);
	if(xml.nodeType == Xml.Document || xml.nodeType == Xml.Element) {
		throw haxe_Exception.thrown("Bad node type, unexpected " + (xml.nodeType == null ? "null" : XmlType.toString(xml.nodeType)));
	}
	xml.nodeValue = data;
	return xml;
};
Xml.createComment = function(data) {
	var xml = new Xml(Xml.Comment);
	if(xml.nodeType == Xml.Document || xml.nodeType == Xml.Element) {
		throw haxe_Exception.thrown("Bad node type, unexpected " + (xml.nodeType == null ? "null" : XmlType.toString(xml.nodeType)));
	}
	xml.nodeValue = data;
	return xml;
};
Xml.createDocType = function(data) {
	var xml = new Xml(Xml.DocType);
	if(xml.nodeType == Xml.Document || xml.nodeType == Xml.Element) {
		throw haxe_Exception.thrown("Bad node type, unexpected " + (xml.nodeType == null ? "null" : XmlType.toString(xml.nodeType)));
	}
	xml.nodeValue = data;
	return xml;
};
Xml.createProcessingInstruction = function(data) {
	var xml = new Xml(Xml.ProcessingInstruction);
	if(xml.nodeType == Xml.Document || xml.nodeType == Xml.Element) {
		throw haxe_Exception.thrown("Bad node type, unexpected " + (xml.nodeType == null ? "null" : XmlType.toString(xml.nodeType)));
	}
	xml.nodeValue = data;
	return xml;
};
Xml.createDocument = function() {
	return new Xml(Xml.Document);
};
Xml.prototype = {
	get: function(att) {
		if(this.nodeType != Xml.Element) {
			throw haxe_Exception.thrown("Bad node type, expected Element but found " + (this.nodeType == null ? "null" : XmlType.toString(this.nodeType)));
		}
		return this.attributeMap.h[att];
	}
	,set: function(att,value) {
		if(this.nodeType != Xml.Element) {
			throw haxe_Exception.thrown("Bad node type, expected Element but found " + (this.nodeType == null ? "null" : XmlType.toString(this.nodeType)));
		}
		this.attributeMap.h[att] = value;
	}
	,exists: function(att) {
		if(this.nodeType != Xml.Element) {
			throw haxe_Exception.thrown("Bad node type, expected Element but found " + (this.nodeType == null ? "null" : XmlType.toString(this.nodeType)));
		}
		return Object.prototype.hasOwnProperty.call(this.attributeMap.h,att);
	}
	,attributes: function() {
		if(this.nodeType != Xml.Element) {
			throw haxe_Exception.thrown("Bad node type, expected Element but found " + (this.nodeType == null ? "null" : XmlType.toString(this.nodeType)));
		}
		return new haxe_ds__$StringMap_StringMapKeyIterator(this.attributeMap.h);
	}
	,elements: function() {
		if(this.nodeType != Xml.Document && this.nodeType != Xml.Element) {
			throw haxe_Exception.thrown("Bad node type, expected Element or Document but found " + (this.nodeType == null ? "null" : XmlType.toString(this.nodeType)));
		}
		var _g = [];
		var _g1 = 0;
		var _g2 = this.children;
		while(_g1 < _g2.length) {
			var child = _g2[_g1];
			++_g1;
			if(child.nodeType == Xml.Element) {
				_g.push(child);
			}
		}
		var ret = _g;
		return new haxe_iterators_ArrayIterator(ret);
	}
	,firstElement: function() {
		if(this.nodeType != Xml.Document && this.nodeType != Xml.Element) {
			throw haxe_Exception.thrown("Bad node type, expected Element or Document but found " + (this.nodeType == null ? "null" : XmlType.toString(this.nodeType)));
		}
		var _g = 0;
		var _g1 = this.children;
		while(_g < _g1.length) {
			var child = _g1[_g];
			++_g;
			if(child.nodeType == Xml.Element) {
				return child;
			}
		}
		return null;
	}
	,addChild: function(x) {
		if(this.nodeType != Xml.Document && this.nodeType != Xml.Element) {
			throw haxe_Exception.thrown("Bad node type, expected Element or Document but found " + (this.nodeType == null ? "null" : XmlType.toString(this.nodeType)));
		}
		if(x.parent != null) {
			x.parent.removeChild(x);
		}
		this.children.push(x);
		x.parent = this;
	}
	,removeChild: function(x) {
		if(this.nodeType != Xml.Document && this.nodeType != Xml.Element) {
			throw haxe_Exception.thrown("Bad node type, expected Element or Document but found " + (this.nodeType == null ? "null" : XmlType.toString(this.nodeType)));
		}
		if(HxOverrides.remove(this.children,x)) {
			x.parent = null;
			return true;
		}
		return false;
	}
	,toString: function() {
		return haxe_xml_Printer.print(this);
	}
	,__class__: Xml
};
var XmlEditor = function() { };
XmlEditor.__name__ = "XmlEditor";
XmlEditor.main = function() {
};
var XmlEditorContent = $hx_exports["XmlEditorContent"] = function() {
	this.triggerCharacters = ["<"," ","/","\"",":"];
	this.tipsPool = new TipsPool();
};
XmlEditorContent.__name__ = "XmlEditorContent";
XmlEditorContent.registerZProjectData = function(cachedata) {
	haxe_Log.trace("更新项目缓存",{ fileName : "XmlEditor.hx", lineNumber : 12, className : "XmlEditorContent", methodName : "registerZProjectData"});
	TipsPool.cacheData = cachedata;
};
XmlEditorContent.prototype = {
	provideCompletionItems: function(model,position,context,token) {
		var line = position.lineNumber;
		var column = position.column;
		haxe_Log.trace(Reflect.fields(position),{ fileName : "XmlEditor.hx", lineNumber : 35, className : "XmlEditorContent", methodName : "provideCompletionItems"});
		var content = model.getLineContent(line);
		var sym = content[column - 2];
		var leftInput = HxOverrides.substr(content,0,column - 1);
		if(leftInput.indexOf(" ") != -1) {
			leftInput = HxOverrides.substr(leftInput,leftInput.lastIndexOf(" ") + 1,null);
		}
		if(leftInput.indexOf("</") == 0) {
			return this.returnSuggestions(this.filterSuggestions(position,sym,content,this.tipsPool.classesend.slice()));
		} else if(leftInput.indexOf("<") == 0) {
			var copy = this.tipsPool.classes.slice();
			if(TipsPool.cacheData != null) {
				var _g_current = 0;
				var _g_array = TipsPool.cacheData.builderFiles;
				while(_g_current < _g_array.length) {
					var _g1_value = _g_array[_g_current];
					var _g1_key = _g_current++;
					var index = _g1_key;
					var value = _g1_value;
					var cName = StringTools.replace(value.name,".xml","");
					copy.push(Suggestions.create(cName,cName,value.path));
				}
			}
			return this.returnSuggestions(this.filterSuggestions(position,sym,content,copy));
		} else if(sym == " ") {
			var classFount = HxOverrides.substr(content,content.lastIndexOf("<"),null);
			classFount = HxOverrides.substr(classFount,1,classFount.indexOf(" ") - 1);
			if(Object.prototype.hasOwnProperty.call(this.tipsPool.attartMaps.h,classFount)) {
				return this.returnSuggestions(this.filterSuggestions(position,sym,content,this.tipsPool.attartMaps.h[classFount],"="));
			}
		} else if(sym == "\"" && leftInput == "src=\"") {
			return this.returnSuggestions(this.filterSuggestions(position,sym,content,this.tipsPool.getCacheFileMaps()));
		} else if(sym == ":" && leftInput.indexOf("src=\"") != -1) {
			var xmlid = HxOverrides.substr(leftInput,leftInput.indexOf("\"") + 1,null);
			xmlid = HxOverrides.substr(xmlid,0,xmlid.indexOf(":"));
			return this.returnSuggestions(this.filterSuggestions(position,sym,content,this.tipsPool.getCacheFileMapsByXml(xmlid)));
		} else if(sym == "\"" && leftInput.indexOf("type=\"") != -1) {
			return this.returnSuggestions(this.filterSuggestions(position,sym,content,TweenApi.returnSuggestions()));
		}
		return { };
	}
	,getLastClassName: function(model,line) {
		var _g = 0;
		var _g1 = line;
		while(_g < _g1) {
			var i = _g++;
			var index = line - i;
			var content = model.getLineContent(index);
			haxe_Log.trace("检查：",{ fileName : "XmlEditor.hx", lineNumber : 88, className : "XmlEditorContent", methodName : "getLastClassName", customParams : [content]});
			if(content.indexOf("<") != -1) {
				var c = HxOverrides.substr(content,content.indexOf("<") + 1,null);
				c = HxOverrides.substr(c,0,content.indexOf(" "));
				haxe_Log.trace("类型判断",{ fileName : "XmlEditor.hx", lineNumber : 92, className : "XmlEditorContent", methodName : "getLastClassName", customParams : [c]});
				if(Object.prototype.hasOwnProperty.call(this.tipsPool.xmlItemMaps.h,c)) {
					return c;
				}
			}
		}
		return null;
	}
	,filterSuggestions: function(position,sym,content,array,endPushInsertText) {
		if(endPushInsertText == null) {
			endPushInsertText = "";
		}
		var newarray = [];
		var _g_current = 0;
		var _g_array = array;
		while(_g_current < _g_array.length) {
			var _g1_value = _g_array[_g_current];
			var _g1_key = _g_current++;
			var index = _g1_key;
			var value = _g1_value;
			newarray.push(Suggestions.create(value.label,Std.string(value.insertText) + endPushInsertText,value.detail,value.className,HxOverrides.substr(content,0,content.lastIndexOf(sym) + 1) + Std.string(value.insertText)));
		}
		return newarray;
	}
	,returnSuggestions: function(array) {
		return { suggestions : array};
	}
	,__class__: XmlEditorContent
};
var data_ZProjectData = function(path,xml) {
	this.assetsPaths = [];
	this.stagecolor = 0;
	this.HDHeight = 0;
	this.HDWidth = 0;
	this.xmlDatas = new haxe_ds_StringMap();
	this.atlasFiles = new haxe_ds_StringMap();
	this.mp3Files = new haxe_ds_StringMap();
	this.jsonFiles = new haxe_ds_StringMap();
	this.xmlFiles = new haxe_ds_StringMap();
	this.pngFiles = new haxe_ds_StringMap();
	this.builderFiles = [];
	this.rootXmlPath = "";
	this.rootPath = "";
	this.rootXmlPath = path;
};
data_ZProjectData.__name__ = "data.ZProjectData";
data_ZProjectData.prototype = {
	isLandsapce: function() {
		return this.HDWidth > this.HDHeight;
	}
	,__class__: data_ZProjectData
};
var haxe_Exception = function(message,previous,native) {
	Error.call(this,message);
	this.message = message;
	this.__previousException = previous;
	this.__nativeException = native != null ? native : this;
};
haxe_Exception.__name__ = "haxe.Exception";
haxe_Exception.thrown = function(value) {
	if(((value) instanceof haxe_Exception)) {
		return value.get_native();
	} else if(((value) instanceof Error)) {
		return value;
	} else {
		var e = new haxe_ValueException(value);
		return e;
	}
};
haxe_Exception.__super__ = Error;
haxe_Exception.prototype = $extend(Error.prototype,{
	get_native: function() {
		return this.__nativeException;
	}
	,__class__: haxe_Exception
});
var haxe_Log = function() { };
haxe_Log.__name__ = "haxe.Log";
haxe_Log.formatOutput = function(v,infos) {
	var str = Std.string(v);
	if(infos == null) {
		return str;
	}
	var pstr = infos.fileName + ":" + infos.lineNumber;
	if(infos.customParams != null) {
		var _g = 0;
		var _g1 = infos.customParams;
		while(_g < _g1.length) {
			var v = _g1[_g];
			++_g;
			str += ", " + Std.string(v);
		}
	}
	return pstr + ": " + str;
};
haxe_Log.trace = function(v,infos) {
	var str = haxe_Log.formatOutput(v,infos);
	if(typeof(console) != "undefined" && console.log != null) {
		console.log(str);
	}
};
var haxe_ValueException = function(value,previous,native) {
	haxe_Exception.call(this,String(value),previous,native);
	this.value = value;
};
haxe_ValueException.__name__ = "haxe.ValueException";
haxe_ValueException.__super__ = haxe_Exception;
haxe_ValueException.prototype = $extend(haxe_Exception.prototype,{
	__class__: haxe_ValueException
});
var haxe_ds_StringMap = function() {
	this.h = Object.create(null);
};
haxe_ds_StringMap.__name__ = "haxe.ds.StringMap";
haxe_ds_StringMap.stringify = function(h) {
	var s = "{";
	var first = true;
	for (var key in h) {
		if (first) first = false; else s += ',';
		s += key + ' => ' + Std.string(h[key]);
	}
	return s + "}";
};
haxe_ds_StringMap.prototype = {
	__class__: haxe_ds_StringMap
};
var haxe_ds__$StringMap_StringMapKeyIterator = function(h) {
	this.h = h;
	this.keys = Object.keys(h);
	this.length = this.keys.length;
	this.current = 0;
};
haxe_ds__$StringMap_StringMapKeyIterator.__name__ = "haxe.ds._StringMap.StringMapKeyIterator";
haxe_ds__$StringMap_StringMapKeyIterator.prototype = {
	hasNext: function() {
		return this.current < this.length;
	}
	,next: function() {
		return this.keys[this.current++];
	}
	,__class__: haxe_ds__$StringMap_StringMapKeyIterator
};
var haxe_iterators_ArrayIterator = function(array) {
	this.current = 0;
	this.array = array;
};
haxe_iterators_ArrayIterator.__name__ = "haxe.iterators.ArrayIterator";
haxe_iterators_ArrayIterator.prototype = {
	hasNext: function() {
		return this.current < this.array.length;
	}
	,next: function() {
		return this.array[this.current++];
	}
	,__class__: haxe_iterators_ArrayIterator
};
var haxe_xml_XmlParserException = function(message,xml,position) {
	this.xml = xml;
	this.message = message;
	this.position = position;
	this.lineNumber = 1;
	this.positionAtLine = 0;
	var _g = 0;
	var _g1 = position;
	while(_g < _g1) {
		var i = _g++;
		var c = xml.charCodeAt(i);
		if(c == 10) {
			this.lineNumber++;
			this.positionAtLine = 0;
		} else if(c != 13) {
			this.positionAtLine++;
		}
	}
};
haxe_xml_XmlParserException.__name__ = "haxe.xml.XmlParserException";
haxe_xml_XmlParserException.prototype = {
	toString: function() {
		var c = js_Boot.getClass(this);
		return c.__name__ + ": " + this.message + " at line " + this.lineNumber + " char " + this.positionAtLine;
	}
	,__class__: haxe_xml_XmlParserException
};
var haxe_xml_Parser = function() { };
haxe_xml_Parser.__name__ = "haxe.xml.Parser";
haxe_xml_Parser.parse = function(str,strict) {
	if(strict == null) {
		strict = false;
	}
	var doc = Xml.createDocument();
	haxe_xml_Parser.doParse(str,strict,0,doc);
	return doc;
};
haxe_xml_Parser.doParse = function(str,strict,p,parent) {
	if(p == null) {
		p = 0;
	}
	var xml = null;
	var state = 1;
	var next = 1;
	var aname = null;
	var start = 0;
	var nsubs = 0;
	var nbrackets = 0;
	var buf = new StringBuf();
	var escapeNext = 1;
	var attrValQuote = -1;
	while(p < str.length) {
		var c = str.charCodeAt(p);
		switch(state) {
		case 0:
			switch(c) {
			case 9:case 10:case 13:case 32:
				break;
			default:
				state = next;
				continue;
			}
			break;
		case 1:
			if(c == 60) {
				state = 0;
				next = 2;
			} else {
				start = p;
				state = 13;
				continue;
			}
			break;
		case 2:
			switch(c) {
			case 33:
				if(str.charCodeAt(p + 1) == 91) {
					p += 2;
					if(HxOverrides.substr(str,p,6).toUpperCase() != "CDATA[") {
						throw haxe_Exception.thrown(new haxe_xml_XmlParserException("Expected <![CDATA[",str,p));
					}
					p += 5;
					state = 17;
					start = p + 1;
				} else if(str.charCodeAt(p + 1) == 68 || str.charCodeAt(p + 1) == 100) {
					if(HxOverrides.substr(str,p + 2,6).toUpperCase() != "OCTYPE") {
						throw haxe_Exception.thrown(new haxe_xml_XmlParserException("Expected <!DOCTYPE",str,p));
					}
					p += 8;
					state = 16;
					start = p + 1;
				} else if(str.charCodeAt(p + 1) != 45 || str.charCodeAt(p + 2) != 45) {
					throw haxe_Exception.thrown(new haxe_xml_XmlParserException("Expected <!--",str,p));
				} else {
					p += 2;
					state = 15;
					start = p + 1;
				}
				break;
			case 47:
				if(parent == null) {
					throw haxe_Exception.thrown(new haxe_xml_XmlParserException("Expected node name",str,p));
				}
				start = p + 1;
				state = 0;
				next = 10;
				break;
			case 63:
				state = 14;
				start = p;
				break;
			default:
				state = 3;
				start = p;
				continue;
			}
			break;
		case 3:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				if(p == start) {
					throw haxe_Exception.thrown(new haxe_xml_XmlParserException("Expected node name",str,p));
				}
				xml = Xml.createElement(HxOverrides.substr(str,start,p - start));
				parent.addChild(xml);
				++nsubs;
				state = 0;
				next = 4;
				continue;
			}
			break;
		case 4:
			switch(c) {
			case 47:
				state = 11;
				break;
			case 62:
				state = 9;
				break;
			default:
				state = 5;
				start = p;
				continue;
			}
			break;
		case 5:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				if(start == p) {
					throw haxe_Exception.thrown(new haxe_xml_XmlParserException("Expected attribute name",str,p));
				}
				var tmp = HxOverrides.substr(str,start,p - start);
				aname = tmp;
				if(xml.exists(aname)) {
					throw haxe_Exception.thrown(new haxe_xml_XmlParserException("Duplicate attribute [" + aname + "]",str,p));
				}
				state = 0;
				next = 6;
				continue;
			}
			break;
		case 6:
			if(c == 61) {
				state = 0;
				next = 7;
			} else {
				throw haxe_Exception.thrown(new haxe_xml_XmlParserException("Expected =",str,p));
			}
			break;
		case 7:
			switch(c) {
			case 34:case 39:
				buf = new StringBuf();
				state = 8;
				start = p + 1;
				attrValQuote = c;
				break;
			default:
				throw haxe_Exception.thrown(new haxe_xml_XmlParserException("Expected \"",str,p));
			}
			break;
		case 8:
			switch(c) {
			case 38:
				var len = p - start;
				buf.b += len == null ? HxOverrides.substr(str,start,null) : HxOverrides.substr(str,start,len);
				state = 18;
				escapeNext = 8;
				start = p + 1;
				break;
			case 60:case 62:
				if(strict) {
					throw haxe_Exception.thrown(new haxe_xml_XmlParserException("Invalid unescaped " + String.fromCodePoint(c) + " in attribute value",str,p));
				} else if(c == attrValQuote) {
					var len1 = p - start;
					buf.b += len1 == null ? HxOverrides.substr(str,start,null) : HxOverrides.substr(str,start,len1);
					var val = buf.b;
					buf = new StringBuf();
					xml.set(aname,val);
					state = 0;
					next = 4;
				}
				break;
			default:
				if(c == attrValQuote) {
					var len2 = p - start;
					buf.b += len2 == null ? HxOverrides.substr(str,start,null) : HxOverrides.substr(str,start,len2);
					var val1 = buf.b;
					buf = new StringBuf();
					xml.set(aname,val1);
					state = 0;
					next = 4;
				}
			}
			break;
		case 9:
			p = haxe_xml_Parser.doParse(str,strict,p,xml);
			start = p;
			state = 1;
			break;
		case 10:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				if(start == p) {
					throw haxe_Exception.thrown(new haxe_xml_XmlParserException("Expected node name",str,p));
				}
				var v = HxOverrides.substr(str,start,p - start);
				if(parent == null || parent.nodeType != 0) {
					throw haxe_Exception.thrown(new haxe_xml_XmlParserException("Unexpected </" + v + ">, tag is not open",str,p));
				}
				if(parent.nodeType != Xml.Element) {
					throw haxe_Exception.thrown("Bad node type, expected Element but found " + (parent.nodeType == null ? "null" : XmlType.toString(parent.nodeType)));
				}
				if(v != parent.nodeName) {
					if(parent.nodeType != Xml.Element) {
						throw haxe_Exception.thrown("Bad node type, expected Element but found " + (parent.nodeType == null ? "null" : XmlType.toString(parent.nodeType)));
					}
					throw haxe_Exception.thrown(new haxe_xml_XmlParserException("Expected </" + parent.nodeName + ">",str,p));
				}
				state = 0;
				next = 12;
				continue;
			}
			break;
		case 11:
			if(c == 62) {
				state = 1;
			} else {
				throw haxe_Exception.thrown(new haxe_xml_XmlParserException("Expected >",str,p));
			}
			break;
		case 12:
			if(c == 62) {
				if(nsubs == 0) {
					parent.addChild(Xml.createPCData(""));
				}
				return p;
			} else {
				throw haxe_Exception.thrown(new haxe_xml_XmlParserException("Expected >",str,p));
			}
			break;
		case 13:
			if(c == 60) {
				var len3 = p - start;
				buf.b += len3 == null ? HxOverrides.substr(str,start,null) : HxOverrides.substr(str,start,len3);
				var child = Xml.createPCData(buf.b);
				buf = new StringBuf();
				parent.addChild(child);
				++nsubs;
				state = 0;
				next = 2;
			} else if(c == 38) {
				var len4 = p - start;
				buf.b += len4 == null ? HxOverrides.substr(str,start,null) : HxOverrides.substr(str,start,len4);
				state = 18;
				escapeNext = 13;
				start = p + 1;
			}
			break;
		case 14:
			if(c == 63 && str.charCodeAt(p + 1) == 62) {
				++p;
				var str1 = HxOverrides.substr(str,start + 1,p - start - 2);
				parent.addChild(Xml.createProcessingInstruction(str1));
				++nsubs;
				state = 1;
			}
			break;
		case 15:
			if(c == 45 && str.charCodeAt(p + 1) == 45 && str.charCodeAt(p + 2) == 62) {
				parent.addChild(Xml.createComment(HxOverrides.substr(str,start,p - start)));
				++nsubs;
				p += 2;
				state = 1;
			}
			break;
		case 16:
			if(c == 91) {
				++nbrackets;
			} else if(c == 93) {
				--nbrackets;
			} else if(c == 62 && nbrackets == 0) {
				parent.addChild(Xml.createDocType(HxOverrides.substr(str,start,p - start)));
				++nsubs;
				state = 1;
			}
			break;
		case 17:
			if(c == 93 && str.charCodeAt(p + 1) == 93 && str.charCodeAt(p + 2) == 62) {
				var child1 = Xml.createCData(HxOverrides.substr(str,start,p - start));
				parent.addChild(child1);
				++nsubs;
				p += 2;
				state = 1;
			}
			break;
		case 18:
			if(c == 59) {
				var s = HxOverrides.substr(str,start,p - start);
				if(s.charCodeAt(0) == 35) {
					var c1 = s.charCodeAt(1) == 120 ? Std.parseInt("0" + HxOverrides.substr(s,1,s.length - 1)) : Std.parseInt(HxOverrides.substr(s,1,s.length - 1));
					buf.b += String.fromCodePoint(c1);
				} else if(!Object.prototype.hasOwnProperty.call(haxe_xml_Parser.escapes.h,s)) {
					if(strict) {
						throw haxe_Exception.thrown(new haxe_xml_XmlParserException("Undefined entity: " + s,str,p));
					}
					buf.b += Std.string("&" + s + ";");
				} else {
					buf.b += Std.string(haxe_xml_Parser.escapes.h[s]);
				}
				start = p + 1;
				state = escapeNext;
			} else if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45) && c != 35) {
				if(strict) {
					throw haxe_Exception.thrown(new haxe_xml_XmlParserException("Invalid character in entity: " + String.fromCodePoint(c),str,p));
				}
				buf.b += String.fromCodePoint(38);
				var len5 = p - start;
				buf.b += len5 == null ? HxOverrides.substr(str,start,null) : HxOverrides.substr(str,start,len5);
				--p;
				start = p + 1;
				state = escapeNext;
			}
			break;
		}
		++p;
	}
	if(state == 1) {
		start = p;
		state = 13;
	}
	if(state == 13) {
		if(parent.nodeType == 0) {
			if(parent.nodeType != Xml.Element) {
				throw haxe_Exception.thrown("Bad node type, expected Element but found " + (parent.nodeType == null ? "null" : XmlType.toString(parent.nodeType)));
			}
			throw haxe_Exception.thrown(new haxe_xml_XmlParserException("Unclosed node <" + parent.nodeName + ">",str,p));
		}
		if(p != start || nsubs == 0) {
			var len = p - start;
			buf.b += len == null ? HxOverrides.substr(str,start,null) : HxOverrides.substr(str,start,len);
			parent.addChild(Xml.createPCData(buf.b));
			++nsubs;
		}
		return p;
	}
	if(!strict && state == 18 && escapeNext == 13) {
		buf.b += String.fromCodePoint(38);
		var len = p - start;
		buf.b += len == null ? HxOverrides.substr(str,start,null) : HxOverrides.substr(str,start,len);
		parent.addChild(Xml.createPCData(buf.b));
		++nsubs;
		return p;
	}
	throw haxe_Exception.thrown(new haxe_xml_XmlParserException("Unexpected end",str,p));
};
var haxe_xml_Printer = function(pretty) {
	this.output = new StringBuf();
	this.pretty = pretty;
};
haxe_xml_Printer.__name__ = "haxe.xml.Printer";
haxe_xml_Printer.print = function(xml,pretty) {
	if(pretty == null) {
		pretty = false;
	}
	var printer = new haxe_xml_Printer(pretty);
	printer.writeNode(xml,"");
	return printer.output.b;
};
haxe_xml_Printer.prototype = {
	writeNode: function(value,tabs) {
		switch(value.nodeType) {
		case 0:
			this.output.b += Std.string(tabs + "<");
			if(value.nodeType != Xml.Element) {
				throw haxe_Exception.thrown("Bad node type, expected Element but found " + (value.nodeType == null ? "null" : XmlType.toString(value.nodeType)));
			}
			this.output.b += Std.string(value.nodeName);
			var attribute = value.attributes();
			while(attribute.hasNext()) {
				var attribute1 = attribute.next();
				this.output.b += Std.string(" " + attribute1 + "=\"");
				var input = StringTools.htmlEscape(value.get(attribute1),true);
				this.output.b += Std.string(input);
				this.output.b += "\"";
			}
			if(this.hasChildren(value)) {
				this.output.b += ">";
				if(this.pretty) {
					this.output.b += "\n";
				}
				if(value.nodeType != Xml.Document && value.nodeType != Xml.Element) {
					throw haxe_Exception.thrown("Bad node type, expected Element or Document but found " + (value.nodeType == null ? "null" : XmlType.toString(value.nodeType)));
				}
				var _g_current = 0;
				var _g_array = value.children;
				while(_g_current < _g_array.length) {
					var child = _g_array[_g_current++];
					this.writeNode(child,this.pretty ? tabs + "\t" : tabs);
				}
				this.output.b += Std.string(tabs + "</");
				if(value.nodeType != Xml.Element) {
					throw haxe_Exception.thrown("Bad node type, expected Element but found " + (value.nodeType == null ? "null" : XmlType.toString(value.nodeType)));
				}
				this.output.b += Std.string(value.nodeName);
				this.output.b += ">";
				if(this.pretty) {
					this.output.b += "\n";
				}
			} else {
				this.output.b += "/>";
				if(this.pretty) {
					this.output.b += "\n";
				}
			}
			break;
		case 1:
			if(value.nodeType == Xml.Document || value.nodeType == Xml.Element) {
				throw haxe_Exception.thrown("Bad node type, unexpected " + (value.nodeType == null ? "null" : XmlType.toString(value.nodeType)));
			}
			var nodeValue = value.nodeValue;
			if(nodeValue.length != 0) {
				var input = tabs + StringTools.htmlEscape(nodeValue);
				this.output.b += Std.string(input);
				if(this.pretty) {
					this.output.b += "\n";
				}
			}
			break;
		case 2:
			this.output.b += Std.string(tabs + "<![CDATA[");
			if(value.nodeType == Xml.Document || value.nodeType == Xml.Element) {
				throw haxe_Exception.thrown("Bad node type, unexpected " + (value.nodeType == null ? "null" : XmlType.toString(value.nodeType)));
			}
			this.output.b += Std.string(value.nodeValue);
			this.output.b += "]]>";
			if(this.pretty) {
				this.output.b += "\n";
			}
			break;
		case 3:
			if(value.nodeType == Xml.Document || value.nodeType == Xml.Element) {
				throw haxe_Exception.thrown("Bad node type, unexpected " + (value.nodeType == null ? "null" : XmlType.toString(value.nodeType)));
			}
			var commentContent = value.nodeValue;
			var _this_r = new RegExp("[\n\r\t]+","g".split("u").join(""));
			commentContent = commentContent.replace(_this_r,"");
			commentContent = "<!--" + commentContent + "-->";
			this.output.b += tabs == null ? "null" : "" + tabs;
			var input = StringTools.trim(commentContent);
			this.output.b += Std.string(input);
			if(this.pretty) {
				this.output.b += "\n";
			}
			break;
		case 4:
			if(value.nodeType == Xml.Document || value.nodeType == Xml.Element) {
				throw haxe_Exception.thrown("Bad node type, unexpected " + (value.nodeType == null ? "null" : XmlType.toString(value.nodeType)));
			}
			this.output.b += Std.string("<!DOCTYPE " + value.nodeValue + ">");
			if(this.pretty) {
				this.output.b += "\n";
			}
			break;
		case 5:
			if(value.nodeType == Xml.Document || value.nodeType == Xml.Element) {
				throw haxe_Exception.thrown("Bad node type, unexpected " + (value.nodeType == null ? "null" : XmlType.toString(value.nodeType)));
			}
			this.output.b += Std.string("<?" + value.nodeValue + "?>");
			if(this.pretty) {
				this.output.b += "\n";
			}
			break;
		case 6:
			if(value.nodeType != Xml.Document && value.nodeType != Xml.Element) {
				throw haxe_Exception.thrown("Bad node type, expected Element or Document but found " + (value.nodeType == null ? "null" : XmlType.toString(value.nodeType)));
			}
			var _g_current = 0;
			var _g_array = value.children;
			while(_g_current < _g_array.length) {
				var child = _g_array[_g_current++];
				this.writeNode(child,tabs);
			}
			break;
		}
	}
	,hasChildren: function(value) {
		if(value.nodeType != Xml.Document && value.nodeType != Xml.Element) {
			throw haxe_Exception.thrown("Bad node type, expected Element or Document but found " + (value.nodeType == null ? "null" : XmlType.toString(value.nodeType)));
		}
		var _g_current = 0;
		var _g_array = value.children;
		while(_g_current < _g_array.length) {
			var child = _g_array[_g_current++];
			switch(child.nodeType) {
			case 0:case 1:
				return true;
			case 2:case 3:
				if(child.nodeType == Xml.Document || child.nodeType == Xml.Element) {
					throw haxe_Exception.thrown("Bad node type, unexpected " + (child.nodeType == null ? "null" : XmlType.toString(child.nodeType)));
				}
				if(StringTools.ltrim(child.nodeValue).length != 0) {
					return true;
				}
				break;
			default:
			}
		}
		return false;
	}
	,__class__: haxe_xml_Printer
};
var js_Boot = function() { };
js_Boot.__name__ = "js.Boot";
js_Boot.getClass = function(o) {
	if(o == null) {
		return null;
	} else if(((o) instanceof Array)) {
		return Array;
	} else {
		var cl = o.__class__;
		if(cl != null) {
			return cl;
		}
		var name = js_Boot.__nativeClassName(o);
		if(name != null) {
			return js_Boot.__resolveNativeClass(name);
		}
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) {
		return "null";
	}
	if(s.length >= 5) {
		return "<...>";
	}
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) {
		t = "object";
	}
	switch(t) {
	case "function":
		return "<function>";
	case "object":
		if(((o) instanceof Array)) {
			var str = "[";
			s += "\t";
			var _g = 0;
			var _g1 = o.length;
			while(_g < _g1) {
				var i = _g++;
				str += (i > 0 ? "," : "") + js_Boot.__string_rec(o[i],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( _g ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") {
				return s2;
			}
		}
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		var k = null;
		for( k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) {
			str += ", \n";
		}
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") {
		return null;
	}
	return name;
};
js_Boot.__resolveNativeClass = function(name) {
	return $global[name];
};
var js_node_KeyValue = {};
js_node_KeyValue.get_key = function(this1) {
	return this1[0];
};
js_node_KeyValue.get_value = function(this1) {
	return this1[1];
};
var js_node_stream_WritableNewOptionsAdapter = {};
js_node_stream_WritableNewOptionsAdapter.from = function(options) {
	if(!Object.prototype.hasOwnProperty.call(options,"final")) {
		Object.defineProperty(options,"final",{ get : function() {
			return options.final_;
		}});
	}
	return options;
};
var js_node_url_URLSearchParamsEntry = {};
js_node_url_URLSearchParamsEntry._new = function(name,value) {
	var this1 = [name,value];
	return this1;
};
js_node_url_URLSearchParamsEntry.get_name = function(this1) {
	return this1[0];
};
js_node_url_URLSearchParamsEntry.get_value = function(this1) {
	return this1[1];
};
var openfl_events_Event = function(type,bubbles,cancelable) {
	if(cancelable == null) {
		cancelable = false;
	}
	if(bubbles == null) {
		bubbles = false;
	}
	this.type = type;
	this.bubbles = bubbles;
	this.cancelable = cancelable;
	this.eventPhase = 2;
};
openfl_events_Event.__name__ = "openfl.events.Event";
openfl_events_Event.prototype = {
	clone: function() {
		var event = new openfl_events_Event(this.type,this.bubbles,this.cancelable);
		event.eventPhase = this.eventPhase;
		event.target = this.target;
		event.currentTarget = this.currentTarget;
		return event;
	}
	,formatToString: function(className,p1,p2,p3,p4,p5) {
		var parameters = [];
		if(p1 != null) {
			parameters.push(p1);
		}
		if(p2 != null) {
			parameters.push(p2);
		}
		if(p3 != null) {
			parameters.push(p3);
		}
		if(p4 != null) {
			parameters.push(p4);
		}
		if(p5 != null) {
			parameters.push(p5);
		}
		return $bind(this,this.__formatToString).apply(this,[className,parameters]);
	}
	,isDefaultPrevented: function() {
		return this.__preventDefault;
	}
	,preventDefault: function() {
		if(this.cancelable) {
			this.__preventDefault = true;
		}
	}
	,stopImmediatePropagation: function() {
		this.__isCanceled = true;
		this.__isCanceledNow = true;
	}
	,stopPropagation: function() {
		this.__isCanceled = true;
	}
	,toString: function() {
		return this.__formatToString("Event",["type","bubbles","cancelable"]);
	}
	,__formatToString: function(className,parameters) {
		var output = "[" + className;
		var arg = null;
		var _g = 0;
		while(_g < parameters.length) {
			var param = parameters[_g];
			++_g;
			arg = Reflect.field(this,param);
			if(typeof(arg) == "string") {
				output += " " + param + "=\"" + Std.string(arg) + "\"";
			} else {
				output += " " + param + "=" + Std.string(arg);
			}
		}
		output += "]";
		return output;
	}
	,__init: function() {
		this.target = null;
		this.currentTarget = null;
		this.bubbles = false;
		this.cancelable = false;
		this.eventPhase = 2;
		this.__isCanceled = false;
		this.__isCanceledNow = false;
		this.__preventDefault = false;
	}
	,__class__: openfl_events_Event
};
var openfl_events_EventType = {};
openfl_events_EventType.equals = function(a,b) {
	return a == b;
};
openfl_events_EventType.notEquals = function(a,b) {
	return a != b;
};
var zygame_events_ZEvent = function(type,data) {
	this.data = null;
	openfl_events_Event.call(this,type,true,false);
	this.data = data;
};
zygame_events_ZEvent.__name__ = "zygame.events.ZEvent";
zygame_events_ZEvent.__super__ = openfl_events_Event;
zygame_events_ZEvent.prototype = $extend(openfl_events_Event.prototype,{
	__class__: zygame_events_ZEvent
});
var zygame_macro_ZMacroUtils = function() { };
zygame_macro_ZMacroUtils.__name__ = "zygame.macro.ZMacroUtils";
var zygame_utils_StringUtils = function() { };
zygame_utils_StringUtils.__name__ = "zygame.utils.StringUtils";
zygame_utils_StringUtils.getExtType = function(data) {
	if(data == null) {
		return data;
	}
	var index = data.lastIndexOf(".");
	if(index == -1) {
		return null;
	} else {
		return HxOverrides.substr(data,index + 1,null);
	}
};
zygame_utils_StringUtils.getName = function(source) {
	var data = source;
	if(data == null) {
		return data;
	}
	data = HxOverrides.substr(data,data.lastIndexOf("/") + 1,null);
	if(data.indexOf(".") != -1) {
		data = HxOverrides.substr(data,0,data.lastIndexOf("."));
	} else if(source.indexOf("http") == 0) {
		return source;
	}
	return data;
};
var $_;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $global.$haxeUID++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = m.bind(o); o.hx__closures__[m.__id__] = f; } return f; }
$global.$haxeUID |= 0;
if(typeof(performance) != "undefined" ? typeof(performance.now) == "function" : false) {
	HxOverrides.now = performance.now.bind(performance);
}
if( String.fromCodePoint == null ) String.fromCodePoint = function(c) { return c < 0x10000 ? String.fromCharCode(c) : String.fromCharCode((c>>10)+0xD7C0)+String.fromCharCode((c&0x3FF)+0xDC00); }
String.prototype.__class__ = String;
String.__name__ = "String";
Array.__name__ = "Array";
js_Boot.__toStr = ({ }).toString;
TweenApi._type = "linear\nsineIn\nsineOut\nsineInOut\nsineOutIn\nquadIn\nquadOut\nquadInOut\nquadOutIn\ncubicIn\ncubicOut\ncubicInOut\ncubicOutIn\nquartIn\nquartOut\nquartInOut\nquartOutIn\nquintIn\nquintOut\nquintInOut\nquintOutIn\nexpoIn\nexpoOut\nexpoInOut\nexpoOutIn\ncircIn\ncircOut\ncircInOut\ncircOutIn\nbounceIn\nbounceOut\nbounceInOut\nbounceOutIn\nbackIn\nbackOut\nbackInOut\nbackOutIn\nelasticIn\nelasticOut\nelasticInOut\nelasticOutIn\nwarpOut\nwarpIn\nwarpInOut\nwarpOutIn".split("\n");
Xml.Element = 0;
Xml.PCData = 1;
Xml.CData = 2;
Xml.Comment = 3;
Xml.DocType = 4;
Xml.ProcessingInstruction = 5;
Xml.Document = 6;
haxe_xml_Parser.escapes = (function($this) {
	var $r;
	var h = new haxe_ds_StringMap();
	h.h["lt"] = "<";
	h.h["gt"] = ">";
	h.h["amp"] = "&";
	h.h["quot"] = "\"";
	h.h["apos"] = "'";
	$r = h;
	return $r;
}(this));
openfl_events_Event.ACTIVATE = "activate";
openfl_events_Event.ADDED = "added";
openfl_events_Event.ADDED_TO_STAGE = "addedToStage";
openfl_events_Event.CANCEL = "cancel";
openfl_events_Event.CHANGE = "change";
openfl_events_Event.CLEAR = "clear";
openfl_events_Event.CLOSE = "close";
openfl_events_Event.COMPLETE = "complete";
openfl_events_Event.CONNECT = "connect";
openfl_events_Event.CONTEXT3D_CREATE = "context3DCreate";
openfl_events_Event.COPY = "copy";
openfl_events_Event.CUT = "cut";
openfl_events_Event.DEACTIVATE = "deactivate";
openfl_events_Event.ENTER_FRAME = "enterFrame";
openfl_events_Event.EXIT_FRAME = "exitFrame";
openfl_events_Event.FRAME_CONSTRUCTED = "frameConstructed";
openfl_events_Event.FRAME_LABEL = "frameLabel";
openfl_events_Event.FULLSCREEN = "fullScreen";
openfl_events_Event.ID3 = "id3";
openfl_events_Event.INIT = "init";
openfl_events_Event.MOUSE_LEAVE = "mouseLeave";
openfl_events_Event.OPEN = "open";
openfl_events_Event.PASTE = "paste";
openfl_events_Event.REMOVED = "removed";
openfl_events_Event.REMOVED_FROM_STAGE = "removedFromStage";
openfl_events_Event.RENDER = "render";
openfl_events_Event.RESIZE = "resize";
openfl_events_Event.SCROLL = "scroll";
openfl_events_Event.SELECT = "select";
openfl_events_Event.SELECT_ALL = "selectAll";
openfl_events_Event.SOUND_COMPLETE = "soundComplete";
openfl_events_Event.TAB_CHILDREN_CHANGE = "tabChildrenChange";
openfl_events_Event.TAB_ENABLED_CHANGE = "tabEnabledChange";
openfl_events_Event.TAB_INDEX_CHANGE = "tabIndexChange";
openfl_events_Event.TEXTURE_READY = "textureReady";
openfl_events_Event.UNLOAD = "unload";
XmlEditor.main();
})(typeof exports != "undefined" ? exports : typeof window != "undefined" ? window : typeof self != "undefined" ? self : this, typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);
