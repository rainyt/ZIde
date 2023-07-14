package tools.file;


import sys.FileSystem;
import sys.io.File;

class FileUtils {
	public static function createDir(dir:String):Void {
		if (!FileSystem.exists(dir)) {
			FileSystem.createDirectory(dir);
		}
	}

	public static function copyFile(file:String, copyTo:String):Void {
		if (!FileSystem.exists(file)) {
			trace("copyDic 路径不存在：" + file);
			return;
		}
		var dir:String = copyTo.substr(0, copyTo.lastIndexOf("/"));
		if (!FileSystem.exists(dir)) {
			FileSystem.createDirectory(dir);
		}
		if (FileSystem.exists(copyTo) && !FileSystem.isDirectory(copyTo))
			FileSystem.deleteFile(copyTo);
		File.copy(file, copyTo);
	}

	/**
	 * 拷贝文件夹
	 * @param path
	 * @param copyTo
	 * @param igone 可在这里设置多个忽略文件
	 */
	public static function copyDic(dic:String, copyTo:String, igone:Array<String> = null):Void {
		if (!FileSystem.exists(dic)) {
			trace("copyDic 路径不存在：" + dic);
			return;
		}
		var dicName:String = dic.substr(dic.lastIndexOf("/") + 1);
		FileSystem.createDirectory(copyTo + "/" + dicName);
		var list:Array<String> = FileSystem.readDirectory(dic);
		for (file in list) {
			var file2:String = dic + "/" + file;
			if (FileSystem.isDirectory(file2)) {
				copyDic(file2, copyTo + "/" + dicName, igone);
			} else {
				if (igone == null || !getIsIgone(file, igone)) {
					try {
						File.copy(file2, copyTo + "/" + dicName);
					} catch (e:Dynamic) {
						trace("Warring:" + file2, e);
					}
				}
			}
		}
	}

	private static function getIsIgone(file:String, igone:Array<String>):Bool {
		for (i in igone) {
			if (file.indexOf(i) != -1)
				return true;
		}
		return false;
	}

	/**
	 * 删除文件夹
	 * @param dic
	 */
	public static function removeDic(dic:String):Void {
		if (!FileSystem.exists(dic))
			return;
		var list:Array<String> = FileSystem.readDirectory(dic);
		for (file in list) {
			file = dic + "/" + file;
			if (FileSystem.isDirectory(file)) {
				removeDic(file);
			} else {
				FileSystem.deleteFile(file);
			}
		}
		FileSystem.deleteDirectory(dic);
	}

	/**
	 * 删除空文件夹
	 * @param dic
	 */
	public static function removeNoneDic(dic:String):Bool {
		if (!FileSystem.exists(dic))
			return false;
		var isCanDelDic:Bool = true;
		var list:Array<String> = FileSystem.readDirectory(dic);
		for (file in list) {
			file = dic + "/" + file;
			if (FileSystem.isDirectory(file)) {
				if (!removeNoneDic(file))
					isCanDelDic = false;
			} else {
				isCanDelDic = false;
			}
		}
		if (isCanDelDic)
			FileSystem.deleteDirectory(dic);
		return isCanDelDic;
	}

	/**
	 * 判断文件是否为二进制
	 * @param file
	 * @return Bool
	 */
	public static function isBinary(file:String):Bool {
        if(FileSystem.isDirectory(file))
            return false;
        var bytes = File.getBytes(file);
        if(bytes.get(0) == 0 && bytes.get(1) == 0 && bytes.get(2) == 0 && bytes.get(3) == 0)
            return true;
        return false;
	}
}
