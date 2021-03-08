package tools.update;

import zygame.macro.ZMacroUtils;
import js.node.ChildProcess;
import sys.io.File;
import haxe.Http;

class UpdateCore {
	/**
	 * 更新地址
	 */
	public static var updateUrl:String = "http://static.kdyx.cn/kengsdk_tools_res/1002/update.zip";

	/**
	 * 热更流程
	 * @param cb 返回状态栏（0）更新完毕；（400）更新失败；（-1）更新错误
	 */
	public function new(cb:Int->Void) {
		var http = new Http(updateUrl + "?" + ZMacroUtils.buildDateTime() + Math.random());
		http.onStatus = function(data:Int) {
			if (data != 200) {
				cb(-1);
			}
		};
		http.onBytes = function(data) {
			var savePath = App.applicationPath + "/app.zip";
			trace("保存至：" + savePath);
			File.saveBytes(savePath, data);
			// 解压
			ChildProcess.exec("cd " + App.applicationPath + " && unzip -o app.zip && rm -rf app.zip", null, function(err, stdout, stderr) {
				trace(err, stdout, stderr);
				cb(err == null ? 0 : -2);
			});
		}
		http.request();
	}
}
