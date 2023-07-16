package app.utils;

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
		var http = new Http(updateUrl + "?" + Math.random());
		http.onStatus = function(data:Int) {
			if (data != 200) {
				cb(-1);
			}
		};
		http.onBytes = function(data) {
			var savePath = AppData.applicationPath + "/app.zip";
			trace("保存至：" + savePath);
			File.saveBytes(savePath, data);
			// 解压
			var cmd = "cd " + AppData.applicationPath + "\nunzip -o app.zip\nrm -rf app.zip";
			if (Sys.systemName() == "Windows") {
				var cdto = AppData.applicationPath.charAt(0);
				cmd = cdto.toLowerCase() + ": & ";
				cmd += "cd " + AppData.applicationPath + " & zip\\unzip.exe -o app.zip"; // & rm -f app.zip
			}
			trace("cmd=", cmd);
			var code = Sys.command(cmd);
			trace("运行结果：", Sys.systemName(), code);
			cb(code == 0 ? 0 : -2);
		}
		http.request();
	}
}
