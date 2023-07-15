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
			tabs: [
				{
					title: 'Tab 1',
					name: '1',
					content: 'Tab 1 content',
				},
				{
					title: 'Tab 2',
					name: '2',
					content: 'Tab 2 content',
				},
			]
		}
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
	 * 开始调试内容
	 */
	public function onDebug():Void {
		var editer = this.get("editer", IFrameElement);
	}

	/**
	 * 开始渲染UI
	 */
	public function onRender():Void {
		var uiediter = this.get("uiediter", IFrameElement);
	}

	/**
	 * 单栏点击
	 */
	public function onHandleNodeClick(item):Void {
		trace(item);
		var xmlContent = File.getContent(item.path);
		// 渲染到编辑器中
		var editer = this.get("editer", IFrameElement);
		untyped editer.contentWindow.setCodeValue(xmlContent);
	}
}
