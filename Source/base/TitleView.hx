package base;

import feathers.controls.PopUpListView;
import openfl.display.DisplayObject;
import feathers.layout.VerticalLayoutData;
import feathers.layout.HorizontalLayoutData;
import feathers.controls.TextInput;
import feathers.layout.VerticalLayout;
import openfl.events.MouseEvent;
import feathers.text.TextFormat;
import feathers.controls.Label;
import feathers.layout.AnchorLayout;
import feathers.controls.LayoutGroup;
import feathers.skins.RectangleSkin;
import feathers.layout.AnchorLayoutData;
import feathers.controls.Panel;

class TitleView extends LayoutGroup {
	private var _title:Label;

	private var _plane:Panel;

	private var _group:LayoutGroup;

	public function new() {
		super();
		this.backgroundSkin = new RectangleSkin(SolidColor(0x0, 0.8));
		this.layout = new AnchorLayout();
		this.layoutData = AnchorLayoutData.fill();
		var plane = new Panel();
		// plane.width = 600;
		// plane.height = 400;
		this.addChild(plane);
		var skin = new RectangleSkin(SolidColor(0xffffff));
		skin.cornerRadius = 3;
		plane.backgroundSkin = skin;
		plane.layout = new AnchorLayout();
		plane.layoutData = AnchorLayoutData.center();
		_plane = plane;

		var title = new Label();
		plane.addChild(title);
		title.text = "标题内容";
		title.layoutData = AnchorLayoutData.topCenter(10);
		title.textFormat = new TextFormat(Utils.fontName, 20, 0x0);
		_title = title;

		var group:LayoutGroup = new LayoutGroup();
		var layout = new VerticalLayout();
		layout.horizontalAlign = HorizontalAlign.RIGHT;
		group.layout = layout;
		layout.paddingTop = 50.0;
		layout.paddingRight = 20.0;
		layout.paddingBottom = 20.0;
		layout.paddingLeft = 20.0;
		layout.gap = 10.0;
		group.layoutData = AnchorLayoutData.center();
		this.getPanel().addChild(group);
		_group = group;

		this.addEventListener(MouseEvent.CLICK, onClick);
	}

	private function onClick(e:MouseEvent):Void {
		if (e.target == this.backgroundSkin && mouseEnabled) {
			this.parent.removeChild(this);
		}
	}

	public function setTitle(text:String) {
		_title.text = text;
	}

	public function getPanel() {
		return _plane;
	}

	public function getGroup() {
		return _group;
	}

	private var maps:Map<String, DisplayObject> = [];

	public function getTextInput(name:String):TextInput {
		return cast maps.get(name);
	}

	public function getPopUpListView(name:String):PopUpListView {
		return cast maps.get(name);
	}

	public function createText(name:String, value:String = null, canedit:Bool = true, tips:String = null):TextInput {
		var layout = new LayoutGroup();
		layout.layout = new HorizontalLayout();
		cast(layout.layout, HorizontalLayout).verticalAlign = VerticalAlign.MIDDLE;
		cast(layout.layout, HorizontalLayout).gap = 10;
		var n = new Label();
		n.text = name + ":";
		layout.addChild(n);
		var input = new TextInput();
		input.width = 300;
		layout.addChild(input);
		getGroup().addChild(layout);
		input.enabled = canedit;
		input.text = value;
		input.prompt = tips;
		input.toolTip = tips;

		maps.set(name, input);
		return input;
	}

	public function createUpload(name:String, value:String = null, canedit:Bool = true, tips:String = null, type:String = null):TextInput {
		var layout = new LayoutGroup();
		layout.layout = new HorizontalLayout();
		cast(layout.layout, HorizontalLayout).verticalAlign = VerticalAlign.MIDDLE;
		cast(layout.layout, HorizontalLayout).gap = 10;
		var n = new Label();
		n.text = name + ":";
		layout.addChild(n);
		var input = new TextInput();
		input.enabled = false;
		input.width = 240;
		layout.addChild(input);
		getGroup().addChild(layout);
		input.enabled = canedit;
		input.text = value;
		input.prompt = tips;
		input.toolTip = tips;

		maps.set(name, input);

		var upload = new Button();
		layout.addChild(upload);
		upload.text = "选择";
		Utils.click(upload, function() {
			Utils.openFile(function(data) {
				input.text = data.path;
			}, type);
		});

		return input;
	}

	public function createDrop(name:String, list:Array<{index:Int, id:String, text:String}>, value:String = null, canedit:Bool = true):PopUpListView {
		var layout = new LayoutGroup();
		layout.layout = new HorizontalLayout();
		cast(layout.layout, HorizontalLayout).verticalAlign = VerticalAlign.MIDDLE;
		cast(layout.layout, HorizontalLayout).gap = 10;
		var n = new Label();
		n.text = name + ":";
		layout.addChild(n);
		var input = new PopUpListView();
		input.width = 300;
		layout.addChild(input);
		getGroup().addChild(layout);
		input.enabled = canedit;
		input.dataProvider = new ArrayCollection(list);
		input.itemToText = Utils.itemToText;
		var f = list.filter((data) -> data.id == value);
		input.selectedIndex = f.length > 0 ? f[0].index : 0;
		maps.set(name, input);
		return input;
	}

	public function createOkButton(txt:String, okcb:Void->Void):Void {
		var layout = new LayoutGroup();
		getGroup().addChild(layout);
		var button = new Button();
		button.text = txt;
		// Skin.mainButton(button);
		button.width = 200;
		button.height = 32;
		layout.addChild(button);
		layout.layout = new AnchorLayout();
		layout.layoutData = new VerticalLayoutData(100);
		button.layoutData = AnchorLayoutData.center();
		Utils.click(button, okcb);
	}
}
