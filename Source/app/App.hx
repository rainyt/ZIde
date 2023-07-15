package app;

import sys.io.File;
import js.html.IFrameElement;
import data.ZProjectData;
import electron.FileSystem;
import app.AppData;
import vue3.VueComponent;

/**
 * 应用主程序
 */
@:t("html/app.html")
@:s("html/css/main.css")
class App extends VueComponent {
	override function data():Dynamic {
		return {
			filterFileName: "",
			files: [],
			tabKey: "",
			tabs: [],
		}
	}

	/**
	 * 代码发生变更时触发
	 */
	public function onCodeChange(url:String, data:String):Void {
		var tabData = this.getCurrentTapData();
		if (tabData != null && tabData.name == url) {
			var editer = this.get("editer", IFrameElement);
			if (!tabData.isChange) {
				tabData.isChange = tabData.code != untyped editer.contentWindow.getCodeValue();
			}
			tabData.code = untyped editer.contentWindow.getCodeValue();
		}
	}

	/**
	 * 清理没有修改过的Tab
	 */
	public function cleanNoChangeTab():Void {
		var array:Array<TapData> = this.tabs;
		array = array.filter((a) -> return a.name == tabKey || a.isChange);
		this.tabs = array;
	}

	public function onTabChange(item):Void {
		this.tabKey = item.props.name;
		// 渲染到编辑器中
		var editer = this.get("editer", IFrameElement);
		untyped editer.contentWindow.setCodeValue(this.tabKey, getCurrentTapData().code);
		this.onRender();
	}

	public function onRemoveTab(item):Void {
		var array:Array<TapData> = this.tabs;
		array = array.filter((a) -> a.name != item);
		this.tabs = array;
	}

	public function addTap(item:TapData):Void {
		var array:Array<TapData> = this.tabs;
		if (array.filter((a) -> a.name == item.name).length == 0)
			array.push(item);
		this.tabs = array;
	}

	public function getCurrentTapData(?name:String):TapData {
		name = name ?? this.tabKey;
		var array:Array<TapData> = this.tabs;
		return array.filter((a) -> a.name == name)[0];
	}

	public function onOpenProject():Void {
		FileSystem.openFile({
			title: "选择project.xml文件",
			filters: [
				{
					name: "项目配置文件",
					extensions: [".xml"]
				}
			]
		}, (data) -> {
			if (!data.canceled) {
				AppData.currentProject = new ZProjectData(data.filePaths[0]);
				this.onFilterChange();
			}
		});
	}

	public function onFilterChange():Void {
		if (AppData.currentProject == null) {
			return;
		}
		var list:Array<{label:String, path:String}> = [];
		for (key => value in AppData.currentProject.builderFiles) {
			if (value.name.indexOf(filterFileName) != -1)
				list.push({
					label: value.name,
					path: value.path
				});
		}
		this.files = list;
	}

	/**
	 * 将文件保存
	 */
	public function onSave():Void {
		// TODO
	}

	/**
	 * 开始渲染UI
	 */
	public function onRender():Void {
		var currentData = this.getCurrentTapData();
		if (currentData != null) {
			var editer = this.get("editer", IFrameElement);
			var uiediter = this.get("uiediter", IFrameElement);
			var code:String = untyped editer.contentWindow.getCodeValue();
			untyped uiediter.contentWindow.openFile(currentData.path, code, AppData.currentProject, null);
		}
	}

	/**
	 * 单栏点击
	 */
	public function onHandleNodeClick(item):Void {
		var xmlContent = File.getContent(item.path);
		// 渲染到编辑器中
		var editer = this.get("editer", IFrameElement);
		untyped editer.contentWindow.onCodeChange = this.onCodeChange;
		untyped editer.contentWindow.setCodeValue(item.label, xmlContent);
		this.addTap({
			title: item.label,
			path: item.path,
			name: item.label,
			code: xmlContent,
			isChange: false
		});
		this.tabKey = item.label;
		this.cleanNoChangeTab();
		// 尝试渲染
		onRender();
	}
}

typedef TapData = {
	title:String,
	name:String,
	path:String,
	code:String,
	isChange:Bool
}
