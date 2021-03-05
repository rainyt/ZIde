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

class Menu extends LayoutGroup {
	public function new() {
		super();
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
			}, ".xml");
		});

		var build = new MenuButton();
		build.text = "编译";
		this.addChild(build);
		Utils.click(build, function() {
			// 编译界面
			try {
				var data = Editor.current.getEditorData();
				Xml.parse(data);
				StageCavans.current.getStart().openFile(data, App.currentProject);
			} catch (e:Exception) {
				Alert.show("错误", "编译错误：" + e.message);
			}
		});

		var save = new MenuButton();
		save.text = "保存";
		this.addChild(save);
		Utils.click(save, function() {
			// 编译界面
			try {
				var data = Editor.current.getEditorData();
				Xml.parse(data);
				File.saveContent(App.currentEditPath, data);
				Alert.show("提示", "保存成功");
			} catch (e:Exception) {
				Alert.show("错误", "保存错误：" + e.message);
			}
		});

		var exportPsd = new MenuButton();
		exportPsd.text = "PSD";
		this.addChild(exportPsd);
		Utils.click(exportPsd, function() {
			Main.current.addChild(new tools.psd.PSDView());
		});
	}
}

class MenuButton extends Button {
	public function new() {
		super();
		this.width = 50;
		this.height = 50;
		this.backgroundSkin = new RectangleSkin(SolidColor(0x444444));
		this.textFormat = new TextFormat(null, 12, 0x858585);
		this.setTextFormatForState(ButtonState.HOVER, new TextFormat(Utils.fontName, 12, 0xffffff));
		this.setSkinForState(ButtonState.HOVER, new RectangleSkin(SolidColor(0x666666)));
	}
}
