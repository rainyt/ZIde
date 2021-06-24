import zygame.macro.ZMacroUtils;

class TweenApi {
	private static var _type:Array<String> = ZMacroUtils.readFileContent("tween-type-tips.txt").split("\n");

	public static function returnSuggestions():Array<Dynamic> {
		var array = [];
		for (index => value in _type) {
			array.push(Suggestions.create(value, value, value));
		}
		return array;
	}
}
