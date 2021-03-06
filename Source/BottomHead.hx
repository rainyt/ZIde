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

		this.addChild(tips);
		tips.textFormat = new TextFormat(Utils.fontName, 12, 0xffffff);
		tips.layoutData = AnchorLayoutData.middleLeft(0, 10);
		tips.text = "绘制次数:0 | 文件大小:0Kb";

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
		tips.text = "绘制次数:" + config.drawcall + " | 文件大小:" + getSize(config.filesize);
	}

	private function getSize(size:Int):String {
		if (size < 1024)
			return size + "k";
		if (size < 1024 * 1024)
			return Std.int(size / 1024 * 100) / 100 + "kb";
		if (size < 1024 * 1024 * 1024)
			return Std.int(size / 1024 / 1024 * 100) / 100 + "mb";
		return "0k";
	}
}
