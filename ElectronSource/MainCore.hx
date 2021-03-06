import electron.main.Dialog;
import electron.main.IpcMain;
import electron.main.App;
import electron.main.BrowserWindow;
import electron.main.MenuItem;
import electron.main.Menu;

@:expose
class MainCore {
	public static var window:BrowserWindow;

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
							untyped window.send("update");
						}
					},
					{
						label: "重启",
						accelerator: "Command+R",
						selector: null,
						click: function() {
							window.reload();
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
							untyped window.send("save");
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
							untyped window.send("build");
						}
					},
					{
						label: "刷新缓存",
						accelerator: "F5",
						selector: null,
						click: () -> {
							untyped window.send("f5");
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
							untyped window.send("debug");
						}
					},
					{
						label: "联想提示",
						accelerator: "CmdOrCtrl+D",
						selector: null,
						click: () -> {
							untyped window.send("codetips");
						}
					}
				]
			}
		];
		Menu.setApplicationMenu(Menu.buildFromTemplate(template));

		IpcMain.on("saveFile", function(event) {
			Dialog.showSaveDialog(window, {
				title: "储存文件"
			}).then(function(promise) {
				if (untyped !promise.canceled)
					untyped window.send("selectFile", promise.filePath);
			});
		});
	}
}
