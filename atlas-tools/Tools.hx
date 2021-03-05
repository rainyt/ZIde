import js.node.ChildProcess;

@:expose
class Tools {
    
    static function main() {
    }

    public static function createAtlas(readDir:String,saveName:String):Void{
        var run = "neko "+ StringTools.replace(Sys.programPath(),"/js-debug/index.html","/tools/createAtlas.n") +" \""+readDir + "\" \"" + saveName + "\"";
        trace("开始创建图集",run);
        trace("环境路径",Sys.programPath());
        ChildProcess.exec(run,null,function(err,stdout,stderr){
            trace(err,stdout,stderr);
        });
    }

    public static function createFnt(readDir:String,saveName:String):Void{
        var run = "neko "+ StringTools.replace(Sys.programPath(),"/js-debug/index.html","/tools/createAtlas.n") +" -fnt \""+readDir + "\" \"" + saveName + "\"";
        trace("开始创建纹理字符图集",run);
        trace("环境路径",Sys.programPath());
        ChildProcess.exec(run,null,function(err,stdout,stderr){
            trace(err,stdout,stderr);
        });
    }

}