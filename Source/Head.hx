import data.ZProjectData;
import js.Browser;
import zygame.events.ZEvent;
import openfl.display.Stage;
import feathers.events.TriggerEvent;
import feathers.controls.Button;
import feathers.text.TextFormat;
import feathers.layout.AnchorLayoutData;
import feathers.controls.Label;
import feathers.layout.AnchorLayout;
import feathers.skins.RectangleSkin;
import feathers.controls.LayoutGroup;

class Head extends LayoutGroup {
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

		Utils.listener.addEventListener("openProject", function(e:ZEvent):Void {
			label.text = e.data.path;
			App.currentProject = new ZProjectData(e.data.path);
			Utils.listener.dispatchEvent(new ZEvent("assetsProess"));
			StageCavans.current.onWindowResize();
		});
	}
}
