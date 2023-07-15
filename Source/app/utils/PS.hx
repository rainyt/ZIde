package app.utils;

@:jsRequire("psd")
extern class PS {

	/**
	 * 根据文件解析PSD
	 * @param file 
	 * @return PS
	 */
	public static function fromFile(file:String):PS;

    /**
     * 开始解析
     */
    public function parse():Void;

    public function tree():PSTree;
}

extern class PSTree {

    public var width:Float;

    public var height:Float;

    public var name:String;

    public var left:Float;

    public var top:Float;
    
    public function isGroup():Bool;

    /**
     * 自定义储存名称
     */
    public var saveName:String;

    /**
     * 自定义索引名
     */
    public var srcName:String;

    public function forEach(cb:PSTree->Void):Void;

    public function root():PSTree;

    public function children():PSTree;

    public function reverse():PSTree;

}