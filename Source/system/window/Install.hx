package system.window;

import sys.io.Process;
import sys.FileSystem;
import sys.io.File;
import electron.renderer.IpcRenderer;

/**
 * Window初始化时，需要进行一次npm install安装
 */
class Install {
	/**
	 * 初始化安装逻辑
	 */
	public static function init() {
		var npmversion = "inited.2";
		if (!FileSystem.exists(npmversion))
			feathers.controls.Alert.show("Window系统需要进行node_moudle初始化", "初始化", ["确定"], function(state) {
				trace("开始更新npm install");
				var code = Sys.command('npm install');
				if (code == 0) {
					File.saveContent(npmversion, "inited");
					feathers.controls.Alert.show("初始化成功，点击确定重启应用", "初始化完成", ["确定"], function(state) {
						IpcRenderer.send("reload");
					});
				} else {
					feathers.controls.Alert.show("npm install运行错误：" + code, "错误", ["确定"]);
				}
			});
		else {
			var npmlib = "node_modules/sharp/build/Release/sharp-win32-x64.node";
			if (!FileSystem.exists(npmlib)) {
				// 缺少sharp-win32-x64.node组件
				feathers.controls.Alert.show("缺少sharp-win32-x64环境", "安装", ["确定"], function(state) {
					var code = Sys.command("npm install --platform=win32 --arch=x64 sharp");
					feathers.controls.Alert.show("安装成功，点击确定重启应用", "初始化完成", ["确定"], function(state) {
						IpcRenderer.send("reload");
					});
				});
			}
		}
	}
}
