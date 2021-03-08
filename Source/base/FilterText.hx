package base;

import feathers.controls.ButtonState;
import openfl.events.Event;
import feathers.controls.TextInput;

/**
 * 筛选功能输入文本
 */
class FilterText extends LayoutGroup {
	private var _data:Array<Dynamic>;

	public var text:String;

	public var input = new TextInput();

	public function new() {
		super();
		this.height = 32;
		this.layout = new AnchorLayout();
		var clear = new Button();
		clear.visible = false;
		this.addChild(input);
		input.backgroundSkin = new RectangleSkin(SolidColor(0x3c3c3c));
		input.layoutData = AnchorLayoutData.fill();
		input.textFormat = new TextFormat(Utils.fontName, 12, 0xffffff);
		input.addEventListener(Event.CHANGE, function(e:Event) {
			clear.visible = input.text.length != 0;
			text = input.text;
			onFiltered(_data.filter(onFilter));
		});
		clear.width = 26;
		clear.height = 26;
		clear.text = "x";
		clear.backgroundSkin = null;
		clear.textFormat = new TextFormat(Utils.fontName, 9, 0xa6a6a6);
		clear.setSkinForState(ButtonState.UP, new RectangleSkin(SolidColor(0x252525)));
		clear.setSkinForState(ButtonState.HOVER, new RectangleSkin(SolidColor(0x252525)));
		clear.setSkinForState(ButtonState.DOWN, new RectangleSkin(SolidColor(0x111111)));
		this.addChild(clear);
		clear.layoutData = AnchorLayoutData.middleRight(0, 10);
		Utils.click(clear, function() {
			input.text = "";
			clear.visible = false;
		});
	}

	public function bindData(data:Array<Dynamic>):Void {
		this.input.text = "";
		_data = data;
	}

	dynamic public function onFilter(data:Dynamic):Bool {
		return true;
	}

	dynamic public function onFiltered(data:Array<Dynamic>):Void {}
}
