// Generated by Haxe 4.1.5
(function ($hx_exports, $global) { "use strict";
var MainCore = $hx_exports["MainCore"] = function() { };
MainCore.main = function() {
	console.log("MainCore.hx:11:","ElectronCore初始化");
	var template = [{ label : "Application", submenu : [{ label : "检查更新", accelerator : "Command+U", selector : null, click : function() {
		MainCore.window.send("update");
	}},{ label : "关闭", accelerator : "Command+Q", selector : "quit:", click : function() {
		electron_main_App.quit();
	}}]},{ label : "编辑", submenu : [{ label : "拷贝全部", accelerator : "CmdOrCtrl+A", selector : "selectAll:", click : null},{ label : "粘贴", accelerator : "CmdOrCtrl+V", selector : "paste:", click : null},{ label : "剪切", accelerator : "CmdOrCtrl+X", selector : "cut:", click : null},{ label : "保存", accelerator : "CmdOrCtrl+S", selector : null, click : function() {
		return MainCore.window.send("save");
	}}]},{ label : "构造", submenu : [{ label : "编译", accelerator : "CmdOrCtrl+B", selector : null, click : function() {
		return MainCore.window.send("build");
	}}]}];
	electron_main_Menu.setApplicationMenu(electron_main_Menu.buildFromTemplate(template));
};
var electron_main_App = require("electron").app;
var electron_main_Menu = require("electron").Menu;
var haxe_iterators_ArrayIterator = function(array) {
	this.current = 0;
	this.array = array;
};
haxe_iterators_ArrayIterator.prototype = {
	hasNext: function() {
		return this.current < this.array.length;
	}
	,next: function() {
		return this.array[this.current++];
	}
};
var js_node_KeyValue = {};
js_node_KeyValue.get_key = function(this1) {
	return this1[0];
};
js_node_KeyValue.get_value = function(this1) {
	return this1[1];
};
MainCore.main();
})(typeof exports != "undefined" ? exports : typeof window != "undefined" ? window : typeof self != "undefined" ? self : this, {});
