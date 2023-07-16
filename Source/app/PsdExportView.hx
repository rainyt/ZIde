package app;

import vue3.VueComponent;

/**
 * PSD导出界面实现
 */
@:t("html/psd_export_view.html")
class PsdExportView extends VueComponent {
	override function data():Dynamic {
		return {
			option: {
				psd: "",
				atlas: true,
				laytouFile: true,
				batchRender: true,
				s9out: true,
				miniPng: true
			}
		}
	}

	/**
	 * 将PSD格式导出处理
	 */
	public function onExport():Void {
		// 开始导出
	}
}
