import app.AppData;
import element.plus.ElementPlus;
import vue3.Vue;
import app.App;

class Main {
	static function main() {
		trace("ZIde v2.0 inited");
		js.Syntax.code("// 此处修复命令行索引
		const fixPath = require('fix-path');
		console.log(process.env.PATH);
		//=> '/usr/bin'
		fixPath();
		console.log(process.env.PATH);");
		AppData.init();
		var config = new App();
		var app = Vue.createApp(config);
		app.use(ElementPlus);
		app.component("FolderOpened", ElementPlusIconsVue.FolderOpened);
		app.component("Folder", ElementPlusIconsVue.Folder);
		app.component("FolderChecked", ElementPlusIconsVue.FolderChecked);
		app.component("Odometer", ElementPlusIconsVue.Odometer);
		app.component("Tools", ElementPlusIconsVue.Tools);
		app.component("Search", ElementPlusIconsVue.Search);
		app.mount("#app");
		// 初始化文件管理器API
		electron.FileSystem.init();
	}
}

@:jsRequire("@element-plus/icons-vue") extern class ElementPlusIconsVue {
	public static var FolderOpened:Dynamic;
	public static var Folder:Dynamic;
	public static var FolderChecked:Dynamic;
	public static var Odometer:Dynamic;
	public static var Tools:Dynamic;
	public static var Search:Dynamic;
}
