package base;

import feathers.layout.HorizontalAlign;
import feathers.layout.VerticalLayout;
import feathers.layout.AnchorLayoutData;
import feathers.controls.Button;
import feathers.layout.VerticalLayoutData;
import feathers.layout.AnchorLayout;
import feathers.controls.LayoutGroup;
import feathers.controls.Label;

/**
 * 通用式弹窗
 */
class Alert extends TitleView {
	public static function show(title:String, content:String):Void {
		Main.current.addChild(new Alert(title, content));
	}

	/**
	 * 显示确定、取消等选项
	 * @param title 
	 * @param content 
	 * @param cb 
	 */
	public static function showSelect(title:String, content:String, cb:String->Void = null):Void {
		Main.current.addChild(new Alert(title, content, "确定", "取消", cb));
	}

	public function new(title:String, content:String, okText:String = null, cannelText:String = null, cb:String->Void = null) {
		super();
		this.setTitle(title);

		cast(getGroup().layout, VerticalLayout).horizontalAlign = HorizontalAlign.CENTER;

		var label = new Label();
		getGroup().addChild(label);
		label.text = content;
		label.wordWrap = true;
		label.maxWidth = 300;

		var layout = new LayoutGroup();
		getGroup().addChild(layout);
		layout.layout = new AnchorLayout();
		layout.layoutData = new VerticalLayoutData(100);

		var buttonlayout = new LayoutGroup();
		layout.addChild(buttonlayout);
		buttonlayout.layout = new HorizontalLayout();
		cast(buttonlayout.layout,HorizontalLayout).gap = 10;

		var ok = new Button();
		buttonlayout.addChild(ok);
		ok.width = 100;
		ok.text = okText == null ? "确定" : okText;
		// Skin.mainButton(ok);
		buttonlayout.layoutData = AnchorLayoutData.center();
		Utils.click(ok, function() {
			this.parent.removeChild(this);
			if (cb != null) {
				cb(ok.text);
			}
		});

		if (cannelText != null) {
			this.mouseEnabled = false;
			var cannel = new Button();
			buttonlayout.addChild(cannel);
			cannel.width = 100;
			cannel.text = cannelText;
			// Skin.mainButton(cannel);
			Utils.click(cannel, function() {
				this.parent.removeChild(this);
				if (cb != null) {
					cb(cannel.text);
				}
			});
		}
	}
}
