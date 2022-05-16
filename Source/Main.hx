import feathers.controls.HDividedBox;
import zygame.events.ZEvent;
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

	public var head = new Head();

	public function new() {
		super();

		App.init();

		js.Syntax.code("// 此处修复命令行索引
		const fixPath = require('fix-path');
		console.log(process.env.PATH);
		//=> '/usr/bin'
		fixPath();
		console.log(process.env.PATH);");

		trace("系统环境：", Sys.systemName());

		IpcRenderer.on("f5", function() {
			// 刷新缓存
			if (App.currentProject != null) {
				trace("update Cache:", App.currentProject.rootXmlPath);
				Utils.listener.dispatchEvent(new ZEvent("openProject", {
					path: App.currentProject.rootXmlPath
				}));
				changeLandsapce(App.currentProject.isLandsapce());
			} else {
				Alert.show("提示", "需要打开一个项目才能清理缓存");
			}
		});

		IpcRenderer.on("debug", function() {
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

		IpcRenderer.on("selectFile", function(event, args) {
			trace("选择文件夹：" + args);
			@:privateAccess Utils._openFileSaveCB(args);
		});

		IpcRenderer.on("update", function() {
			// 更新
			new UpdateCore(function(code) {
				if (code == 0) {
					Alert.showSelect("提示", "已更新成功，是否马上重启？", function(data) {
						if (data == "确定") {
							// Electron16已不支持
							// Remote.getCurrentWebContents().reload();
							IpcRenderer.send("reload");
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

		var menu = new Menu();
		this.addChild(menu);
		this.addChild(head);
		var assets = new AssetsList();
		this.addChild(assets);
		var bottom = new BottomHead();
		this.addChild(bottom);
		bottom.layoutData = new AnchorLayoutData(null, 0, 0, 50);

		var layout:LayoutGroup = new LayoutGroup();
		this.addChild(layout);
		layout.layout = new AnchorLayout();
		layout.layoutData = new AnchorLayoutData(36, 0, 20, 50 + assets.width);

		stageCanvas = new StageCavans();
		layout.addChild(stageCanvas);
		stageCanvas.width = 400 * 0.85;
		stageCanvas.height = 800 * 0.85;
		stageCanvas.layoutData = new AnchorLayoutData(null, 0, null, null, null, 0);

		editor = new Editor();
		layout.addChild(editor);
		editor.layoutData = new AnchorLayoutData(0, stageCanvas.width, 0, 0);

		// changeLandsapce(true);
	}

	private var stageCanvas:StageCavans;
	private var editor:Editor;

	public function changeLandsapce(isLandsapce:Bool = false):Void {
		if (!isLandsapce) {
			stageCanvas.width = 400 * 0.85;
			stageCanvas.height = 800 * 0.85;
			stageCanvas.layoutData = new AnchorLayoutData(null, 0, null, null, null, 0);
			editor.layoutData = new AnchorLayoutData(0, stageCanvas.width, 0, 0);
		} else {
			stageCanvas.width = 800 * 0.85;
			stageCanvas.height = 400 * 0.85;
			stageCanvas.layoutData = new AnchorLayoutData(0, null, null, null, 0, null);
			editor.layoutData = new AnchorLayoutData(stageCanvas.height, 0, 0, 0);
		}
	}
}
