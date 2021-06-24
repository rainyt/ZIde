import sys.io.File;

class TweenApiCreate {
	static function main() {
		var code = File.getContent("Tools.api");
		var Easing = code.substr(code.indexOf("class Easing"));
		Easing = Easing.substr(0, Easing.indexOf("class FloatTools"));
		var lines = Easing.split("\n");
		var array:Array<String> = [];
		for (index => value in lines) {
			if (value.indexOf("function") != -1) {
				var funname = value.substr(0, value.indexOf("("));
				funname = funname.substr(funname.lastIndexOf(" ") + 1);
				array.push(funname);
				trace(funname);
			}
		}
		File.saveContent("tween-type-tips.txt", array.join("\n"));
	}
}
