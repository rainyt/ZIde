package app;

import element.plus.ElMessageBox;
import haxe.io.Path;
import app.utils.PSDTools;
import electron.FileSystem;
import vue3.VueComponent;

/**
 * PSD导出界面实现
 */
@:t("html/psd_export_view.html")
class PsdExportView extends VueComponent {
	override function data():Dynamic {
		return {
			exporting: false,
			option: {
				psd: "",
				atlas: true,
				laytouFile: true,
				batchRender: true,
				s9out: false,
				miniPng: true
			}
		}
	}

	/**
	 * 将PSD格式导出处理
	 */
	public function onExport():Void {
		// 开始导出
		exporting = true;
		var tools = new PSDTools();
		var psdPath = new Path(option.psd);
		var outDir = psdPath.dir + "/bin/";
		sys.FileSystem.createDirectory(outDir);
		tools.exportPsdUIFiles(option.psd, outDir, option.layoutFile, option.atlas, psdPath.file, 2048, option.batchRender, (bool) -> {
			exporting = false;
			if (bool) {
				this.unmount();
				ElMessageBox.alert("导出完成", "导出PSD成功");
			}
		}, option.s9out);
	}

	/**
	 * 将PSD文件上传
	 */
	public function onPSDUpload():Void {
		FileSystem.openFile({
			title: "选择PSD文件",
			filters: [
				{
					name: "Photoshop文件",
					extensions: [".psd"]
				}
			]
		}, (data) -> {
			if (!data.canceled) {
				option.psd = data.filePaths[0];
			}
		});
	}
}
