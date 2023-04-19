import electron.renderer.IpcRenderer;
import haxe.Exception;
import zygame.events.ZEvent;
import sys.io.File;
import feathers.controls.ButtonState;
import feathers.text.TextFormat;
import feathers.controls.Button;
import feathers.layout.VerticalLayout;
import feathers.skins.RectangleSkin;
import feathers.layout.AnchorLayoutData;
import feathers.controls.LayoutGroup;

/**
 * 左侧菜单栏
 */
class Menu extends LayoutGroup {
	public static var current:Menu;

	public function new() {
		super();
		current = this;
		this.width = 50;
		this.layoutData = new AnchorLayoutData(0, null, 0);
		this.backgroundSkin = new RectangleSkin(SolidColor(0x333333));
		this.layout = new VerticalLayout();
		cast(this.layout, VerticalLayout).gap = 1;
		// 打开文件
		var open = new MenuButton();
		open.text = "打开";
		this.addChild(open);
		Utils.click(open, function() {
			Utils.openFile(function(data) {
				Utils.listener.dispatchEvent(new ZEvent("openProject", data));
				Main.current.changeLandsapce(App.currentProject.isLandsapce());
			}, ".xml");
		});

		var build = new MenuButton();
		build.text = "编译";
		this.addChild(build);
		Utils.click(build, onBuild);

		var save = new MenuButton();
		save.text = "保存";
		this.addChild(save);
		Utils.click(save, onSave);

		var exportPsd = new MenuButton();
		exportPsd.text = "PSD";
		this.addChild(exportPsd);
		Utils.click(exportPsd, function() {
			Main.current.addChild(new tools.psd.PSDView());
		});

		var exportBatchPsd = new MenuButton();
		exportBatchPsd.text = "批量";
		this.addChild(exportBatchPsd);
		Utils.click(exportBatchPsd, function() {
			Main.current.addChild(new tools.psd.PSDBatchView());
		});

		var debug = new MenuButton();
		debug.text = "调试";
		this.addChild(debug);
		Utils.click(debug, onDebug);
	}

	public function onDebug():Void {
		// 不兼容electron16
		// Remote.getCurrentWebContents().openDevTools();
		IpcRenderer.send("debug");
	}

	public function onBuild():Void {
		// 编译界面
		try {
			var data = Editor.current.getEditorData();
			Xml.parse(data);
			StageCavans.current.getStart().openFile(null, data, App.currentProject, Main.current.head.buildParams.text);
		} catch (e:Exception) {
			Alert.show("错误", "编译错误：" + e.message);
		}
	}

	public function onSave():Void {
		// 编译界面
		try {
			var data = Editor.current.getEditorData();
			Xml.parse(data);
			if (App.currentEditPath == null) {
				// 保存新文件
				Utils.openFileSave(function(path) {
					App.currentEditPath = path;
					File.saveContent(App.currentEditPath, data);
					// 将文件追加到zproject中
					if (App.currentProject != null) {
						App.currentProject.builderFiles.push({
							name: path.substr(path.lastIndexOf("/") + 1),
							path: path
						});
					}
				});
			} else {
				File.saveContent(App.currentEditPath, data);
			}
		} catch (e:Exception) {
			Alert.show("错误", "保存错误：" + e.message);
		}
	}
}

class MenuButton extends Button {
	public function new() {
		super();
		this.width = 50;
		this.height = 50;
		this.backgroundSkin = new RectangleSkin(SolidColor(0x444444));
		this.textFormat = new TextFormat(Utils.fontName, 12, 0x858585);
		this.setTextFormatForState(ButtonState.HOVER, new TextFormat(Utils.fontName, 12, 0xffffff));
		this.setSkinForState(ButtonState.HOVER, new RectangleSkin(SolidColor(0x666666)));
	}
}
