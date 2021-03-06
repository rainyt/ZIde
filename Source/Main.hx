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

		js.Syntax.code("// 此处修复命令行索引
		const fixPath = require('fix-path');
		console.log(process.env.PATH);
		//=> '/usr/bin'
		fixPath();
		console.log(process.env.PATH);");

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
		bottom.layoutData = new AnchorLayoutData(null,0,0,50);

		stageLayoutGroup.layoutData = new AnchorLayoutData(36, 0, 20, 50 + assets.width);
	}
}
