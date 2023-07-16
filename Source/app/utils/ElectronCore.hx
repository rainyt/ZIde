package app.utils;

import electron.renderer.IpcRenderer;

class ElectronCore {
	/**
	 * 当发生保存时
	 */
	public dynamic static function onSave() {};

	/**
	 * 当发生重构时
	 */
	public dynamic static function onBuild() {};

	/**
	 * 项目缓存刷新处理
	 */
	public dynamic static function onUpdateProject() {};

	public static function init():Void {
		IpcRenderer.on("save", function() {
			onSave();
		});

		IpcRenderer.on("build", function() {
			onBuild();
		});

		IpcRenderer.on("f5", function() {
			// 刷新project，并且将布局还原到0,0
			onUpdateProject();
		});
	}
}
