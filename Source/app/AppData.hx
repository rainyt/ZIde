package app;

class AppData {
	/**
	 * 当前项目
	 */
	public static var currentProject:data.ZProjectData;

	public static var applicationPath:String;

	public static function init():Void {
		applicationPath = Sys.programPath();
		applicationPath = StringTools.replace(applicationPath, "\\", "/");
		applicationPath = applicationPath.substr(0, applicationPath.lastIndexOf("/"));
	}
}
