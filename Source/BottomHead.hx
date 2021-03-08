import views.AssetsTipsView;
import feathers.controls.ButtonState;
import openfl.events.Event;
import zygame.macro.ZMacroUtils;

class BottomHead extends LayoutGroup {
	public static var current:BottomHead;

	public var tips:Label = new Label();

	public function new() {
		super();
		current = this;
		this.backgroundSkin = new RectangleSkin(SolidColor(0x007acc));
		this.height = 20;

		this.layout = new AnchorLayout();

		var leftLayout = new LayoutGroup();
		this.addChild(leftLayout);
		leftLayout.layout = new HorizontalLayout();
		cast(leftLayout.layout, HorizontalLayout).verticalAlign = VerticalAlign.MIDDLE;
		cast(leftLayout.layout, HorizontalLayout).horizontalAlign = HorizontalAlign.LEFT;

		leftLayout.addChild(tips);
		tips.textFormat = new TextFormat(Utils.fontName, 12, 0xffffff);
		leftLayout.layoutData = AnchorLayoutData.middleLeft(0, 10);
		tips.text = "绘制次数:0 | 文件大小:0Kb";

		var asslist = new Button();
		leftLayout.addChild(asslist);
		asslist.text = "[文件详情]";
		asslist.backgroundSkin = null;
		asslist.setTextFormatForState(ButtonState.UP, new TextFormat(Utils.fontName, 12, 0xffffff));
		asslist.setTextFormatForState(ButtonState.HOVER, new TextFormat(Utils.fontName, 12, 0xcccccc));
		asslist.setTextFormatForState(ButtonState.DOWN, new TextFormat(Utils.fontName, 12, 0xaaaaaa));
		Utils.click(asslist, function() {
			Main.current.addChild(new AssetsTipsView(StageCavans.current.assetsList));
		});

		var version = new Label();
		this.addChild(version);
		version.text = ZMacroUtils.buildDateTime();
		version.textFormat = new TextFormat(Utils.fontName, 12, 0xffffff);
		version.layoutData = AnchorLayoutData.middleRight(0, 10);

		this.addEventListener(Event.ENTER_FRAME, function(e) {
			updateConfig({
				drawcall: StageCavans.current.getStart().fps.getDrawCall(),
				filesize: StageCavans.current.assetsSize
			});
		});
	}

	/**
	 * 更新界面配置
	 * @param config 
	 */
	public function updateConfig(config:{drawcall:Int, filesize:Int}):Void {
		tips.text = "绘制次数:" + config.drawcall + " | 文件大小:" + Utils.getSize(config.filesize);
	}

	
}
