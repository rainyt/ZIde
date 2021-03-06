import zygame.macro.ZMacroUtils;

class BottomHead extends LayoutGroup {
	public function new() {
		super();
		this.backgroundSkin = new RectangleSkin(SolidColor(0x007acc));
		this.height = 20;

		this.layout = new AnchorLayout();

		var version = new Label();
		this.addChild(version);
		version.text = ZMacroUtils.buildDateTime();
		version.textFormat = new TextFormat(Utils.fontName, 12, 0xffffff);
		version.layoutData = AnchorLayoutData.middleRight(0, 10);
	}
}
