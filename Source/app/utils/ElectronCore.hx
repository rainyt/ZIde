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

	public static function init():Void {
		IpcRenderer.on("save", function() {
			onSave();
		});

		IpcRenderer.on("build", function() {
			onBuild();
		});
	}
}
