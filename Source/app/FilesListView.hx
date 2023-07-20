package app;

import vue3.VueComponent;

@:t("html/files_list_view.html")
class FilesListView extends VueComponent {
	public var filesData:Dynamic;

	override function data():Dynamic {
		return {
			tableData: filesData
		}
	}
}
