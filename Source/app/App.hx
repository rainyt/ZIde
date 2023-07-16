package app;

import app.utils.UpdateCore;
import element.plus.ElementPlus;
import element.plus.ElMessageBox;
import element.plus.ElMessage;
import haxe.Exception;
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
@:mainHtml("html/index.html")
@:assets("./Assets", "./")
@:require("./electron-core.js")
class App extends VueComponent {
	override function data():Dynamic {
		return {
			updateing: false,
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
		array = array.filter((a) -> return a.name == tabKey || a.isChange || a.lock);
		this.tabs = array;
	}

	public function onTabChange(item):Void {
		if (this.tabKey != item.props.name) {
			this.tabKey = item.props.name;
			// 渲染到编辑器中
			var editer = this.get("editer", IFrameElement);
			untyped editer.contentWindow.setCodeValue(this.tabKey, getCurrentTapData().code);
			this.onRender();
		}
	}

	public function onRemoveTab(item):Void {
		var tabData = this.getCurrentTapData();
		if (tabData != null && tabData.isChange) {
			ElMessageBox.confirm("注意当前文件未保存，避免造成数据丢失", "是否保存当前文件", {
				cancelButtonText: "放弃",
				confirmButtonText: "保存并关闭",
				distinguishCancelAndClose: true,
			}).then((data) -> {
				// 先保存，再关闭
				if (onSave()) {
					removeTap(item);
				}
			}).catchError((data) -> {
				if (data != "close") {
					removeTap(item);
				}
			});
			return;
		}
		removeTap(item);
	}

	public function removeTap(item):Void {
		var array:Array<TapData> = this.tabs;
		array = array.filter((a) -> a.name != item);
		this.tabs = array;
		if (array.length > 0) {
			// 默认切换到第一个
			this.tabKey = array[0].name;
		} else {
			// 清空代码区域
			this.tabKey = "";
		}
		onCodeUpdate();
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
	public function onSave():Bool {
		// TODO
		var tabData = this.getCurrentTapData();
		if (tabData != null) {
			if (tabData.isChange) {
				// 检验一下
				try {
					Xml.parse(tabData.code);
				} catch (e:Exception) {
					ElMessage.error("保存失败：" + e.message);
					return false;
				}
				File.saveContent(tabData.path, tabData.code);
				ElMessage.success("保存成功");
				tabData.isChange = false;
			}
		}
		return true;
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
			try {
				Xml.parse(code);
				untyped uiediter.contentWindow.openFile(currentData.path, code, AppData.currentProject, null);
			} catch (e:Exception) {
				ElMessage.error("渲染错误：" + e.message);
			}
		}
	}

	public function onCodeUpdate():Void {
		var editer = this.get("editer", IFrameElement);
		var currentData = getCurrentTapData();
		if (currentData != null) {
			untyped editer.contentWindow.setCodeValue(currentData.name, currentData.code);
		} else {
			untyped editer.contentWindow.setCodeValue("", "");
		}
		this.onRender();
	}

	/**
	 * 单栏点击
	 */
	public function onHandleNodeClick(item):Void {
		if (this.tabKey == item.label) {
			var tabData = this.getCurrentTapData();
			tabData.lock = true;
			return;
		}
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
			isChange: false,
			lock: false
		});
		this.tabKey = item.label;
		this.cleanNoChangeTab();
		// 尝试渲染
		onRender();
	}

	/**
	 * PSD导出处理
	 */
	public function onPSDExport():Void {
		var app = PsdExportView.createApp();
		app.use(ElementPlus);
		app.mount("#dialog");
	}

	public function onUpdate():Void {
		updateing = true;
		new UpdateCore((code) -> {
			updateing = false;
			switch code {
				case 0:
					ElMessageBox.alert("更新完成", "提示");
				default:
					ElMessageBox.alert("更新程序包错误", "错误");
			}
		});
	}
}

typedef TapData = {
	title:String,
	name:String,
	path:String,
	code:String,
	isChange:Bool,
	lock:Bool
}
