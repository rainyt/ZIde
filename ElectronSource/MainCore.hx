import electron.main.Dialog;
import electron.main.IpcMain;
import electron.main.App;
import electron.main.BrowserWindow;
import electron.main.MenuItem;
import electron.main.Menu;

@:expose
class MainCore {
	static function main() {
		trace("ElectronCore初始化");
		var template:Array<Dynamic> = [
			{
				label: "Application",
				submenu: [
					{
						label: "检查更新",
						accelerator: "Command+U",
						selector: null,
						click: function() {
							untyped BrowserWindow.getFocusedWindow().send("update");
						}
					},
					{
						label: "重启",
						accelerator: "Command+R",
						selector: null,
						click: function() {
							untyped BrowserWindow.getFocusedWindow().reload();
						}
					},
					{
						label: "关闭",
						accelerator: "Command+Q",
						selector: null,
						click: function() {
							App.quit();
						}
					}
				]
			},
			{
				label: "编辑",
				submenu: [
					{
						label: "拷贝全部",
						accelerator: "CmdOrCtrl+A",
						selector: "selectAll:",
						click: null
					},
					{
						label: "复制",
						accelerator: "CmdOrCtrl+C",
						selector: "copy:",
						click: null
					},
					{
						label: "粘贴",
						accelerator: "CmdOrCtrl+V",
						selector: "paste:",
						click: null
					},
					{
						label: "剪切",
						accelerator: "CmdOrCtrl+X",
						selector: "cut:",
						click: null
					},
					{
						label: "保存",
						accelerator: "CmdOrCtrl+S",
						selector: null,
						click: () -> {
							untyped BrowserWindow.getFocusedWindow().send("save");
						}
					}
				]
			},
			{
				label: "构造",
				submenu: [
					{
						label: "编译",
						accelerator: "CmdOrCtrl+B",
						selector: null,
						click: () -> {
							untyped BrowserWindow.getFocusedWindow().send("build");
						}
					},
					{
						label: "刷新缓存",
						accelerator: "F5",
						selector: null,
						click: () -> {
							untyped BrowserWindow.getFocusedWindow().send("f5");
						}
					}
				]
			},
			{
				label: "工具",
				submenu: [
					{
						label: "开发者工具",
						accelerator: "F12",
						selector: null,
						click: () -> {
							var window:BrowserWindow = BrowserWindow.getFocusedWindow();
							window.webContents.openDevTools();
						}
					},
					{
						label: "联想提示",
						accelerator: "CmdOrCtrl+D",
						selector: null,
						click: () -> {
							untyped BrowserWindow.getFocusedWindow().send("codetips");
						}
					}
				]
			}
		];
		Menu.setApplicationMenu(Menu.buildFromTemplate(template));
	}
}
