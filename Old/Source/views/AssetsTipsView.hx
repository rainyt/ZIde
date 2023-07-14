package views;

import zygame.utils.StringUtils;
import feathers.controls.ListView;
import base.TitleView;

class AssetsTipsView extends TitleView {
	public function new(data:Array<Dynamic>) {
		super();
		this.setTitle("资源列表");
		var list = new ListView();
		this.getGroup().addChild(list);
		list.width = 650;
		list.height = 500;
		list.dataProvider = new ArrayCollection(data);
		list.itemToText = function(data:Dynamic) {
			var file:String = data.file;
			file = StringTools.replace(file, App.currentProject.rootPath + "/", "");
			return file + " 文件大小：" + Utils.getSize(data.size);
		};
	}
}
