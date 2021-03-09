/**
 * 提示索引
 */
class Suggestions {
	/**
	 * 创建一个提示索引
	 * @param label 提示显示
	 * @param insertText 插入内容
	 * @param detail 提示
	 * @param className Function
	 */
	public static function create(label:String, insertText:String, detail:String, className:String = "Property",filterText:String = null):Dynamic {
		return {
			label: label,
			insertText: insertText,
			detail: detail,
			filterText: filterText,
			kind: untyped monaco.languages.CompletionItemKind[className],
			insertTextRules: untyped monaco.languages.CompletionItemInsertTextRule.KeepWhitespace
		}
	}
}
