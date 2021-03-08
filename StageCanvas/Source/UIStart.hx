import zygame.utils.Lib;
import js.Browser;
import openfl.events.MouseEvent;
import zygame.display.batch.ImageBatchs;
import zygame.display.batch.TouchImageBatchsContainer;
import zygame.components.ZBuilder;
import zygame.components.ZBuilder.Builder;
import zygame.utils.ZAssets;
import zygame.core.Start;
import data.ZProjectData;

class UIStart extends Start {
	private var _project:ZProjectData;

	private var _assets:ZAssets = new ZAssets();

	private var _build:Builder;

	public var filesConfig:Array<Dynamic> = [];

	public dynamic function onFileChanged(files:Array<Dynamic>):Void {}

	public function new() {
		super(1080, 600, false);
		untyped window.uiContext = this.stage;
		untyped window.uiStart = this;
		this.stage.color = 0x373737;
		ZBuilder.bindAssets(_assets);
		Browser.window.addEventListener("click", function(e) {
			stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
		});
	}

	public function openFile(xmlData:String, project:data.ZProjectData):Void {
		_project = project;
		while (this.numChildren > 0) {
			this.removeChildAt(0);
		}
		if (_build != null) {
			_build.disposeView();
		}
		try {
			trace("开始编译");
			var xml = Xml.parse(xmlData);
			proessAssets(xml, function(bool) {
				// 判断是否为批渲染对象
				var child = xml.firstElement();
				var className:String = child.nodeName;
				var isTile:Bool = false;
				@:privateAccess var c = ZBuilder.classMaps.get(className);
				isTile = #if cpp false #else (c != null && c.toString().indexOf("zygame_display_batch") != -1) #end;
				var swidth:Float = child.exists("swidth") ? Std.parseFloat(child.get("swidth")) : Start.current.getStageWidth();
				var sheight:Float = child.exists("sheight") ? Std.parseFloat(child.get("sheight")) : Start.current.getStageHeight();
				if (isTile) {
					var atlas = findTextureAtlasName(child);
					if (atlas != null) {
						var nativeTilemap = new ImageBatchs(@:privateAccess ZBuilder.getBaseTextureAtlas(atlas.split(":")[0]), Std.int(swidth),
							Std.int(sheight));
						this.addChild(nativeTilemap);
						_build = ZBuilder.build(xml, nativeTilemap);
					} else
						trace("需要指定精灵表！");
				} else {
					_build = ZBuilder.build(xml, this);
				}
			});
		} catch (e:Dynamic) {
			trace("预览失败：", e);
		}
	}

	private function findTextureAtlasName(child:Xml):String {
		if (child.exists("src")) {
			return child.get("src");
		} else {
			for (item in child.elements()) {
				var value = findTextureAtlasName(item);
				if (value != null)
					return value;
			}
		}
		return null;
	}

	public function proessAssets(xml:Xml, cb:Bool->Void) {
		var needAssets:Array<String> = [];
		this.findXmlAssets(xml.firstElement(), needAssets);
		trace("所需加载资源：", needAssets);
		var isload:Bool = false;
		for (s in needAssets) {
			if (_assets.getBitmapData(s) == null && _assets.getTextureAtlas(s) == null && _assets.getTextAtlas(s) == null) {
				isload = true;
			}
		}
		filesConfig = [];
		if (isload) {
			_assets.unloadAll();
			for (file in needAssets) {
				var png:String = this._project.pngFiles.get(file);
				var xfile:String = this._project.xmlFiles.get(file);
				var jfile:String = this._project.jsonFiles.get(file);
				var afile:String = this._project.atlasFiles.get(file);
				if (png != null && afile != null) {
					// Spine格式
					trace("载入Spine", png, afile);
					filesConfig.push({
						file: png
					});
					filesConfig.push({
						file: afile
					});
					_assets.loadSpineTextAlats([png], afile);
				} else if (png != null && xfile != null) {
					// 图集格式
					trace("载入图集", png, xfile);
					filesConfig.push({
						file: png
					});
					filesConfig.push({
						file: xfile
					});
					_assets.loadTextures(png, xfile);
				} else if (png != null) {
					// 单图格式
					trace("载入单图", png);
					filesConfig.push({
						file: png
					});
					_assets.loadFile(png);
				}
				if (jfile != null) {
					// JSON格式
					trace("载入JSON", jfile);
					filesConfig.push({
						file: jfile
					});
					_assets.loadFile(jfile);
				}
			}
			_assets.start(function(f) {
				if (f == 1) {
					cb(true);
					onFileChanged(filesConfig);
				}
			}, function(data) {
				cb(false);
				onFileChanged(filesConfig);
			});
		} else {
			cb(true);
			onFileChanged(filesConfig);
		}
	}

	/**
	 * 递归查询资源
	 * @param xml
	 * @param array
	 */
	private function findXmlAssets(xml:Xml, array:Array<String>):Void {
		for (item in xml.elements()) {
			if (item.exists("src")) {
				var src = item.get("src");
				var path:String = "";
				if (src.indexOf(",") != -1) {
					// 多图协议
					var a = src.split(",");
					for (key => value in a) {
						if (value.indexOf(":") != -1) {
							// 图集协议
							path = value.substr(0, value.indexOf(":"));
						} else {
							// 图集、或者整张图片
							path = value;
						}
						if (array.indexOf(path) == -1) {
							array.push(path);
						}
					}
					continue;
				} else if (src.indexOf(":") != -1) {
					// 图集协议
					var datas = src.split(":");
					path = datas[0];
					// 可能是JSON格式
					if (array.indexOf(datas[1]) == -1) {
						// 排除BImage和ZImage，这两个是使用图集，没有JSON可能性
						if(item.nodeName != "BImage" && item.nodeName != "ZImage")
							array.push(datas[1]);
					}
				} else {
					// 图集、或者整张图片
					path = src;
				}
				if (array.indexOf(path) == -1) {
					array.push(path);
				}
			}
			findXmlAssets(item, array);
		}
	}
}
