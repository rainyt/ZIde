package app;

import electron.FileSystem;
import vue3.VueComponent;

/**
 * 应用主程序
 */
@:t("html/app.html")
@:s("html/css/main.css")
class App extends VueComponent {
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
				trace("选择了项目配置：", data.filePaths[0]);
			}
		});
	}
}
