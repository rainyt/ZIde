package tools.psd;

import tools.file.FileUtils;
import sys.FileSystem;
import sys.io.File;
import zygame.utils.StringUtils;
import base.TitleView;

/**
 * PSD批量导出实现
 */
class PSDBatchView extends TitleView {
	private var psdfiles:Array<String>;

	private var psdfilesClone:Array<String>;

	public function new() {
		super();
		this.setTitle("导出PSD格式UI文件(批量导出)");
		this.createUpload("PSD目录", null, false, "请选择需要导出的PSD文件", "dir");
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
		this.createDrop("九宫格图分离", [
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
		this.createDrop("精灵图最大尺寸", [
			{
				index: 0,
				id: "2048",
				text: "2048x2048"
			},
			{
				index: 1,
				id: "1024",
				text: "1024x1024"
			},
			{
				index: 2,
				id: "512",
				text: "512x512"
			}
		]);
		this.createOkButton("导出", function() {
			// 开始导出
			var psddir = this.getTextInput("PSD目录").text;
			psddir = psddir.substr(0, psddir.lastIndexOf("/"));
			function readPsdFiles(path:String):Array<String> {
				var files = [];
				var list = FileSystem.readDirectory(path);
				for (file in list) {
					var dir = path + "/" + file;
					if (FileSystem.isDirectory(dir)) {
						var list = readPsdFiles(dir);
						if (list.length > 0) {
							files = files.concat(list);
						}
					} else if (file.indexOf(".psd") != -1) {
						files.push(dir);
					}
				}
				return files;
			}

			psdfiles = readPsdFiles(psddir);
			psdfilesClone = psdfiles.copy();

			nextParserPsd();
			trace("psd列表：", psdfiles);
		});
		this.createOkButton("取消", function() {
			this.parent.removeChild(this);
		});
		this.mouseEnabled = false;
	}

	/**
	 * 导出PSD
	* **/
	function exportPsd(psdfile:String) {
		trace("开始导出：", psdfile);
		var psd = new tools.psd.PSDTools();
		psd.exportPsdUIFiles(psdfile, psdfile.substr(0, psdfile.lastIndexOf("/")) + "/bin/", this.getPopUpListView("导出布局文件").selectedIndex == 0,
			this.getPopUpListView("导出为图集").selectedIndex == 0, StringUtils.getName(psdfile), Std.parseInt(this.getPopUpListView("精灵图最大尺寸").selectedItem.id),
			this.getPopUpListView("使用批渲染布局").selectedIndex == 0, function(bool) {
				if (bool) {
					nextParserPsd();
				}
		}, this.getPopUpListView("九宫格图分离").selectedIndex == 0);
	}

	public function nextParserPsd():Void {
		var file = psdfiles.shift();
		if (file != null) {
			exportPsd(file);
		} else {
			var psddir = this.getTextInput("PSD目录").text;
			psddir = psddir.substr(0, psddir.lastIndexOf("/"));
			if (FileSystem.exists(psddir + "/bin")) {
				FileUtils.removeDic(psddir + "/bin");
			}
			FileSystem.createDirectory(psddir + "/bin");
			for (s in psdfilesClone) {
				var name = StringUtils.getName(s) + "Atlas";
				var dir = s.substr(0, s.lastIndexOf("/")) + "/bin/";
				var png = dir + name + ".png";
				var xml = dir + name + ".xml";
				File.copy(png, psddir + "/bin/" + name + ".png");
				File.copy(xml, psddir + "/bin/" + name + ".xml");
			}
			Alert.show("提示", "导出完成");
		}
	}
}
