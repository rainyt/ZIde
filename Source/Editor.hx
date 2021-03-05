import feathers.layout.HorizontalLayoutData;
import feathers.layout.VerticalLayoutData;
import feathers.skins.RectangleSkin;
import feathers.layout.AnchorLayoutData;
import openfl.display.DOMElement;
import js.Browser;
import js.html.IFrameElement;
import feathers.controls.LayoutGroup;

/**
 * XML脚本编辑器
 */
class Editor extends LayoutGroup {
	public static var current:Editor;

	private var iframe:IFrameElement;

	private var cacheX:Float = 0;
	private var cacheY:Float = 0;

	public function new() {
		super();
		current = this;
		this.backgroundSkin = new RectangleSkin(SolidColor(0x252525));
		iframe = cast Browser.document.createIFrameElement();
		iframe.id = "editor";
		var dom:DOMElement = new DOMElement(iframe);
		this.addChild(dom);
		dom.width = this.width;
		dom.height = this.height;
		dom.x = this.x;
		dom.y = this.y;
		iframe.style.border = "none";
		iframe.src = "md/editor.html";
		this.layoutData = new HorizontalLayoutData(100, 100);
		this.visible = true;
	}

	public function setEditorData(content:String):Void {
		untyped iframe.contentWindow.setCodeValue(content);
	}

	public function getEditorData():String {
		return untyped iframe.contentWindow.getCodeValue();
	}

	override function initialize() {
		super.initialize();
	}

	override function set_width(value:Float):Float {
		iframe.width = Std.int(value) + "px";
		iframe.style.width = Std.int(value) + "px";
		return super.set_width(value);
	}

	override function set_height(value:Float):Float {
		iframe.height = Std.int(value) + "px";
		iframe.style.height = Std.int(value) + "px";
		return super.set_height(value);
	}
}
