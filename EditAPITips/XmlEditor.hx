class XmlEditor {
	static function main() {}
}

@:expose
class XmlEditorContent {
	public var tipsPool = new TipsPool();

	/**
	 * 初始化提示缓存
	 */
	public function new():Void {
		// var keys = "qwertyuioplkjhgfdsazxbnmQWERTYUIOPLKJHGFDSAZXCVBNM".split("");
		// for (k in keys) {
		// 	triggerCharacters.push(k);
		// }
	}

	/**
	 * 智能提示逻辑
	 * @param model
	 * @param position
	 * @return Dynamic
	 */
	public function provideCompletionItems(model:Dynamic, position:Dynamic, context:Dynamic, token:Dynamic):Dynamic {
		trace(context, token);
		var line:Int = position.lineNumber;
		var column = position.column;
		trace(Reflect.fields(position));
		// // 获取当前输入行的所有内容
		var content:String = model.getLineContent(line);
		var sym = untyped content[column - 2];
		var leftInput = content.substr(0, column - 1);
		if (leftInput.indexOf(" ") != -1) {
			leftInput = leftInput.substr(leftInput.lastIndexOf(" ") + 1);
		}
		trace("position:", position, content, sym, "leftInput=", leftInput);
		if (leftInput.indexOf("</") == 0) {
			// </开头时，应输入类型
			return returnSuggestions(filterSuggestions(position, sym, content, tipsPool.classesend.copy()));
		} else if (leftInput.indexOf("<") == 0) {
			// <开头时，应输入类型
			return returnSuggestions(filterSuggestions(position, sym, content, tipsPool.classes.copy()));
		} else if (sym == " ") {
			// 可能是访问属性
			var classFount = content.substr(content.lastIndexOf("<"));
			classFount = classFount.substr(1, classFount.indexOf(" ") - 1);
			if (tipsPool.attartMaps.exists(classFount))
				return returnSuggestions(filterSuggestions(position, sym, content, tipsPool.attartMaps.get(classFount), "=\"\""));
		}
		return {};
	}

	public function filterSuggestions(position:Dynamic, sym:String, content:String, array:Array<Dynamic>, endPushInsertText = ""):Array<Dynamic> {
		var newarray = [];
		for (index => value in array) {
			newarray.push(Suggestions.create(value.label, value.insertText + endPushInsertText, value.detail, value.className,
				content.substr(0, content.lastIndexOf(sym) + 1) + value.insertText));
		}
		trace("提示：", newarray);
		return newarray;
	}

	public function returnSuggestions(array:Array<Dynamic>):Dynamic {
		return {
			suggestions: array,
		};
	}

	public var triggerCharacters:Array<String> = ["<", " ", "/"];
}
