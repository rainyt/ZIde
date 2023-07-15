package app;

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
		for (key => value in AppData.currentProject.xmlFiles) {
			if (key.indexOf(filterFileName) != -1)
				list.push({
					label: key,
					path: value
				});
		}
		this.files = list;
	}
}
