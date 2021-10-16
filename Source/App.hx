import data.ZProjectData;

/**
 * 应用数据引用管理
 */
class App {
	public static var applicationPath:String;

	/**
	 * 当前项目目录
	 */
	public static var currentProject:ZProjectData;

	/**
	 * 当前编辑目录
	 */
	public static var currentEditPath:String;

	public static function init():Void {
		applicationPath = Sys.programPath();
		applicationPath = StringTools.replace(applicationPath, "\\", "/");
		applicationPath = applicationPath.substr(0, applicationPath.lastIndexOf("/"));
		trace("applicationPath=" + applicationPath);
	}
}
