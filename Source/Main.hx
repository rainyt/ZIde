import electron.renderer.Remote;
import tools.update.UpdateCore;
import electron.renderer.IpcRenderer;
import feathers.layout.VerticalAlign;
import feathers.layout.HorizontalAlign;
import feathers.layout.HorizontalLayout;
import zygame.components.ZBuilder;
import feathers.layout.AnchorLayoutData;
import feathers.controls.LayoutGroup;
import feathers.layout.AnchorLayout;
import feathers.skins.RectangleSkin;
import feathers.controls.Application;

/**
 * ZIde主框架，实现界面逻辑
 */
class Main extends Application {
	public static var current:Main;

	public function new() {
		super();

		App.init();

		js.Syntax.code("// 此处修复命令行索引
		const fixPath = require('fix-path');
		console.log(process.env.PATH);
		//=> '/usr/bin'
		fixPath();
		console.log(process.env.PATH);");

		IpcRenderer.on("debug", function(){
			Menu.current.onDebug();
		});

		IpcRenderer.on("formatxml", function() {
			Editor.current.formatXml();
		});

		IpcRenderer.on("save", function() {
			Menu.current.onSave();
		});

		IpcRenderer.on("build", function() {
			Menu.current.onBuild();
		});

		IpcRenderer.on("codetips", function() {
			trace("联想提示");
		});

		IpcRenderer.on("selectFile", function(event,args){
			trace("选择文件夹：" + args);
			@:privateAccess Utils._openFileSaveCB(args);
		});

		IpcRenderer.on("update", function() {
			// 更新
			new UpdateCore(function(code) {
				if (code == 0) {
					Alert.showSelect("提示", "已更新成功，是否马上重启？", function(data) {
						if (data == "确定") {
							Remote.getCurrentWebContents().reload();
						}
					});
				} else
					Alert.show("错误", "更新错误（" + code + "）");
			});
		});

		current = this;

		ZBuilder.init();

		this.stage.color = 0x252525;
		this.backgroundSkin = new RectangleSkin(SolidColor(0x252525));
		this.layout = new AnchorLayout();

		var stageLayoutGroup = new LayoutGroup();
		stageLayoutGroup.backgroundSkin = new RectangleSkin(SolidColor(0x1e1e1e));
		this.addChild(stageLayoutGroup);
		stageLayoutGroup.layout = new HorizontalLayout();
		cast(stageLayoutGroup.layout, HorizontalLayout).horizontalAlign = HorizontalAlign.CENTER;
		cast(stageLayoutGroup.layout, HorizontalLayout).verticalAlign = VerticalAlign.MIDDLE;

		var editor = new Editor();
		stageLayoutGroup.addChild(editor);

		var stageCanvas = new StageCavans();
		stageLayoutGroup.addChild(stageCanvas);

		var menu = new Menu();
		this.addChild(menu);
		var head = new Head();
		this.addChild(head);
		var assets = new AssetsList();
		this.addChild(assets);
		var bottom = new BottomHead();
		this.addChild(bottom);
		bottom.layoutData = new AnchorLayoutData(null, 0, 0, 50);

		stageLayoutGroup.layoutData = new AnchorLayoutData(36, 0, 20, 50 + assets.width);
	}
}
