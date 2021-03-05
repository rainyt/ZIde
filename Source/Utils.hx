import zygame.components.ZBuilder;
import sys.io.File;
import haxe.Exception;
import js.html.InputElement;
import openfl.events.EventDispatcher;
import js.Browser;
import feathers.events.TriggerEvent;
import feathers.controls.Button;

class Utils {
	public static var fontName:String = "Helvetica";

	public static var input:InputElement = null;

	public static var listener:EventDispatcher = new EventDispatcher();

	public static function click(button:Button, cb:Void->Void):Void {
		button.addEventListener(TriggerEvent.TRIGGER, function(e) {
			cb();
		});
	}

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
