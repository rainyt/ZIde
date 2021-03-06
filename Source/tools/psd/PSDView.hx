package tools.psd;

import zygame.utils.StringUtils;
import base.TitleView;

class PSDView extends TitleView {
	public function new() {
		super();
		this.setTitle("导出PSD格式UI文件");
		this.createUpload("PSD文件", null, false, "请选择需要导出的PSD文件", ".psd");
		this.createDrop("导出为图集", [
			{
				index: 0,
				id: "true",
				text: "是"
			},
			{
				index: 1,
				id: "true",
				text: "否"
			}
		]);
		this.createDrop("导出布局文件", [
			{
				index: 0,
				id: "true",
				text: "是"
			},
			{
				index: 1,
				id: "true",
				text: "否"
			}
		]);
		this.createDrop("使用批渲染布局", [
			{
				index: 0,
				id: "true",
				text: "是"
			},
			{
				index: 1,
				id: "true",
				text: "否"
			}
		]);
		this.createOkButton("导出", function() {
			// 开始导出
			var psd = new tools.psd.PSDTools();
			var psdfile = this.getTextInput("PSD文件").text;
			psd.exportPsdUIFiles(psdfile, psdfile.substr(0, psdfile.lastIndexOf("/")) + "/bin/", this.getPopUpListView("导出布局文件").selectedIndex == 0,
				this.getPopUpListView("导出为图集").selectedIndex == 0, StringUtils.getName(psdfile), this.getPopUpListView("使用批渲染布局").selectedIndex == 0, function(bool){
					if(bool){
						this.parent.removeChild(this);
					}
				});
		});
		this.createOkButton("取消", function() {
			this.parent.removeChild(this);
		});
		this.mouseEnabled = false;
	}
}
