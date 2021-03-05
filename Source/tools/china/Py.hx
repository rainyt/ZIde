package tools.china;

class Py {

	/**
	 * 将中文转化为英文
	 * @param text 
	 * @return String
	 */
	public static function getFullChars(text:String):String {
		return untyped window["pinyin"].getFullChars(text);
	}
}
