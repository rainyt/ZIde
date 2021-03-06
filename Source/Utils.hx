import electron.remote.Dialog;
import electron.renderer.Remote;
import zygame.components.ZBuilder;
import sys.io.File;
import haxe.Exception;
import js.html.InputElement;
import openfl.events.EventDispatcher;
import js.Browser;
import feathers.events.TriggerEvent;
import feathers.controls.Button;

/**
 * 通用工具类
 */
class Utils {
	/**
	 * 字体
	 */
	public static var fontName:String = "Helvetica";

	/**
	 * 上传组件
	 */
	public static var input:InputElement = null;

	/**
	 * 侦听器
	 */
	public static var listener:EventDispatcher = new EventDispatcher();

	/**
	 * 统一侦听按钮点击事件
	 * @param button 按钮
	 * @param cb 点击事件
	 */
	public static function click(button:Button, cb:Void->Void):Void {
		button.addEventListener(TriggerEvent.TRIGGER, function(e) {
			cb();
		});
	}

	/**
	 * 选择文件
	 * @param cb 
	 * @param type 
	 */
	public static function openFile(cb:Dynamic->Void, type:String):Void {
		if (input == null)
			input = Browser.document.createInputElement();
		input.value = "";
		input.accept = type;
		input.setAttribute("id", "openDir");
		input.type = "file";
		input.style.setProperty("visibility", "hidden");
		Browser.document.body.appendChild(input);
		input.onchange = function() {
			cb(input.files[0]);
			input.blur();
		};
		input.click();
	}

	/**
	 * 判断是否为ZBuilderXml目录
	 * @param path 
	 * @return Bool
	 */
	public static function isZBuilderXml(path:String):Bool {
		try {
			var xml = Xml.parse(File.getContent(path));
			var nodeName = xml.firstElement().nodeName;
			return @:privateAccess ZBuilder.classMaps.exists(nodeName);
		} catch (e:Exception) {}
		return false;
	}

	public static function itemToText(data:Dynamic):String {
		return data.text;
	}
}
