import feathers.controls.TextInput;
import zygame.macro.ZMacroUtils;
import data.ZProjectData;
import zygame.events.ZEvent;
import feathers.text.TextFormat;
import feathers.layout.AnchorLayoutData;
import feathers.controls.Label;
import feathers.layout.AnchorLayout;
import feathers.skins.RectangleSkin;
import feathers.controls.LayoutGroup;

/**
 * 头部信息栏
 */
class Head extends LayoutGroup {
	public var buildParams:TextInput;

	public function new() {
		super();
		this.height = 36;
		this.backgroundSkin = new RectangleSkin(SolidColor(0x2d2d2d));
		this.layout = new AnchorLayout();
		var label = new Label();
		this.addChild(label);
		label.text = "未打开项目";
		label.layoutData = new AnchorLayoutData(null, null, null, 10, null, 0);
		label.textFormat = new TextFormat(Utils.fontName, 12, 0x959595);
		this.layoutData = new AnchorLayoutData(0, 0, null, 50);

		var clayout = new LayoutGroup();
		this.addChild(clayout);
		var desc = new Label("编译参数：");
		desc.textFormat = new TextFormat(null, null, 0xffffff);
		clayout.addChild(desc);
		var input = new TextInput();
		clayout.addChild(input);
		buildParams = input;
		clayout.layout = new HorizontalLayout();
		cast(clayout.layout, HorizontalLayout).verticalAlign = MIDDLE;
		clayout.layoutData = new AnchorLayoutData(null, 0, null, null, null, 0);

		Utils.listener.addEventListener("openProject", function(e:ZEvent):Void {
			if (e.data == null)
				return;
			var filepath = e.data.path;
			filepath = StringTools.replace(filepath, "\\", "/");
			label.text = filepath;
			App.currentProject = new ZProjectData(filepath);
			Utils.listener.dispatchEvent(new ZEvent("assetsProess"));
			StageCavans.current.onWindowResize();
			Editor.current.bindZProjectData(App.currentProject);
		});
	}
}
