import js.html.DivElement;
import sys.FileSystem;
import UIStart;
import js.Browser;
import js.html.CanvasElement;
import openfl.display.DOMElement;
import openfl.events.Event;
import openfl.display.Stage;
import feathers.controls.LayoutGroup;

/**
 * WEBGL渲染舞台，用于渲染UI组件功能
 */
class StageCavans extends LayoutGroup {
	public static var current:StageCavans;

	var element:DivElement;

	private var cacheX:Float = 0;
	private var cacheY:Float = 0;

	public var assetsSize:Int = 0;

	public var assetsList:Array<Dynamic>;

	public function new() {
		super();
		current = this;
		element = cast Browser.document.createDivElement();
		untyped window.canvas = element;
		element.id = "uicanvas";
		// element.style.transform = "translateZ(0px)";
		var dom:DOMElement = new DOMElement(element);
		this.addChild(dom);
		// dom.width = this.width;
		// dom.height = this.height;
		// dom.x = this.x;
		// dom.y = this.y;
	}

	public function getStart():UIStart {
		return cast untyped window.uiStart;
	}

	public var inited = false;

	override function initialize() {
		super.initialize();
		stage.addEventListener(Event.ENTER_FRAME, function(e) {
			if (!inited && untyped window.onLimeEnbed != null) {
				inited = true;
				untyped window.onLimeEnbed();
				this.onWindowResize();
				// 注册资源文件变更事件
				getStart().onFileChanged = onFileChanged;
			}
		});
	}

	private function onFileChanged(list:Array<Dynamic>):Void {
		assetsSize = 0;
		assetsList = list;
		for (index => value in list) {
			var size = FileSystem.stat(value.file).size;
			value.size = size;
			assetsSize += size;
		}
	}

	override function set_width(value:Float):Float {
		super.set_width(value);
		onWindowResize();
		return value;
	}

	override function set_height(value:Float):Float {
		super.set_height(value);
		onWindowResize();
		return value;
	}

	public function onWindowResize():Void {
		if (getStart() == null)
			return;
		// if (App.currentProject == null || !App.currentProject.isLandsapce()) {
		// 	this.width = 480;
		// 	this.height = 800;
		// } else {
		// 	this.height = 480;
		// 	this.width = 800;
		// }
		var stage:Stage = untyped window.uiContext;
		element.style.width = Std.int(this.width) + "px";
		element.style.height = Std.int(this.height) + "px";
		if (App.currentProject == null) {
			getStart().HDHeight = Std.int(this.height);
			getStart().HDWidth = Std.int(this.width);
		} else {
			getStart().HDHeight = App.currentProject.HDHeight == 0 ? Std.int(this.height) : App.currentProject.HDHeight;
			getStart().HDWidth = App.currentProject.HDWidth == 0 ? Std.int(this.width) : App.currentProject.HDWidth;
		}
		if (stage != null) {
			stage.color = App.currentProject == null ? 0x373737 : App.currentProject.stagecolor;
			// stage.window.resize(Std.int(this.width), Std.int(this.height));
			// @:privateAccess stage.__resize();
			getStart().onStageSizeChange();
			trace("window.uiContext.resize()", Std.int(this.width), Std.int(this.height), getStart().HDWidth, getStart().HDHeight);
		} else {
			trace("window.uiContext is null");
		}
	}
}
