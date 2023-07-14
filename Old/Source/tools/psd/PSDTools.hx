package tools.psd;

import js.node.ChildProcess;
import tools.file.FileUtils;
import sys.FileSystem;
import haxe.io.Bytes;
import sys.io.File;
import tools.psd.PS.PSTree;
import tools.china.Py;

class PSDTools {
	public function new() {}

	/**
	 * PSD的宽度
	 */
	private var psd2width:Int = 0;

	/**
	 * PSD的高度
	 */
	private var psd2height:Int = 0;

	private var saveList:Array<String> = [];
	private var psdCount:Int = 0;
	private var psdExported:Int = 0;
	private var isCreateAtals:Bool = false;
	private var psdOutDir:String;
	private var atlasName:String;
	private var atlasSize:Int = 2048;
	private var callBack:Bool->Void;

	/**
	 * 是否将九宫图图额外分离实现
	 */
	private var outSlice9:Bool = false;

	/**
	 * 导出PSD UI文件
	 * @param psdfile PSD文件
	 * @param outdir 导出目录
	 * @param createXml 是否创建XML
	 * @param createAtlas 是否创建精灵图集
	 * @param fileName 导出文件名
	 * @param atlasSize 导出精灵图的尺寸
	 * @param createBatch 是否创建批渲染布局
	 */
	public function exportPsdUIFiles(psdfile:String, outdir:String, createXml:Bool, createAtlas:Bool, fileName:String, atlasSize:Int, createBatch:Bool,
			cb:Bool->Void, outSlice9:Bool):Void {
		// 初始化所需要的参数
		this.outSlice9 = outSlice9;
		this.callBack = cb;
		this.saveList = [];
		this.psdCount = 0;
		this.psdExported = 0;
		this.isCreateAtals = createAtlas;
		this.psdOutDir = outdir;
		this.atlasSize = atlasSize;
		trace("输出目录：" + psdOutDir);
		trace("是否创建精灵图：" + isCreateAtals);
		trace("是否创建批渲染：" + createBatch);
		trace("是否创建XML：" + createXml);
		trace("文件名：" + fileName);
		if (FileSystem.exists(psdOutDir))
			FileUtils.removeDic(psdOutDir);
		FileSystem.createDirectory(psdOutDir);
		if (createAtlas) {
			if (fileName == null) {
				var psdName:String = psdfile.substr(psdfile.lastIndexOf("/") + 1);
				psdName = psdName.substr(0, psdName.lastIndexOf("."));
				atlasName = psdName.charAt(0).toUpperCase() + psdName.substr(1);
				atlasName = Py.getFullChars(atlasName);
			} else {
				atlasName = fileName.charAt(0).toUpperCase() + fileName.substr(1) + "Atlas";
			}
		} else {
			atlasName = null;
		}
		if (createAtlas == false)
			createBatch = false;

		// 开始解析PSD文件
		var psd = PS.fromFile(psdfile);
		psd.parse();
		var a:Dynamic = {};

		var xml:String = "<ZBox width=\"100%\" height=\"100%\">\n";
		if (createBatch) {
			xml += "<TouchImageBatchsContainer src=\"" + atlasName + "\" width=\"100%\" height=\"100%\">\n";
		}

		psd2width = Std.int(psd.tree().root().width / 2);
		psd2height = Std.int(psd.tree().root().height / 2);

		trace("PSD size:", psd2width, psd2height);

		// 解析
		xml += this.parserPsGroup(psd.tree().children().reverse(), outdir, a, createBatch);
		var keys = Reflect.fields(a);
		for (key in keys) {
			var element:Array<PSTree> = Reflect.getProperty(a, key);
			// 解析最大宽高
			var mleft:Int = 9999;
			var mright:Int = 0;
			var mtop:Int = 9999;
			var mbottom:Int = 0;
			var srcData:Array<String> = [];
			for (i in 0...element.length) {
				var group:Dynamic = element[i];
				if (group.left < mleft)
					mleft = group.left;
				if (group.right > mright)
					mright = group.right;
				if (group.top < mtop)
					mtop = group.top;
				if (group.bottom > mbottom)
					mbottom = group.bottom;
				srcData.push(group.srcName);
			}
			// 计算最大尺寸
			var maxWidth:Int = mright - mleft;
			var maxHeight:Int = mbottom - mtop;
			// 计算所有图片的偏移值
			for (i2 in 0...element.length) {
				var group2:Dynamic = element[i2];
				group2.offestX = group2.left - mleft;
				group2.offestY = group2.top - mtop;
				untyped element.forEach(function(layer:Dynamic):Void {
					var savePath:String = outdir + layer.saveName + ".png";
					if (saveList.indexOf(savePath) == -1) {
						saveList.push(savePath);
						psdCount++;
						untyped window.compositeGroupOrLayer(layer, maxWidth, maxHeight, layer.offestX, layer.offestY).then(function(data:Dynamic):Void {
							File.saveBytes(this.getSavePath(savePath), Bytes.ofData(data));
							trace("保存成功", savePath);
							psdExported++;
							onPsdExported(psdExported / psdCount);
						}, function(err:Dynamic):Void {
							trace("保存失败", savePath + "\n" + err);
						});
					}
				});
				if (createBatch)
					xml += "    <BAnimation id=\"" + key.substr(key.indexOf(".") + 1) + "\" src=\"" + srcData.join(",") + "\" centerX=\""
						+ ((mleft + maxWidth / 2) - psd2width) + "\" centerY=\"" + ((mtop + maxHeight / 2) - psd2height) + "\"/>\n";
				else
					xml += "    <ZAnimation id=\"" + key.substr(key.indexOf(".") + 1) + "\" src=\"" + srcData.join(",") + "\" centerX=\""
						+ ((mleft + maxWidth / 2) - psd2width) + "\" centerY=\"" + ((mtop + maxHeight / 2) - psd2height) + "\"/>\n";
			}
		}
		if (createBatch) {
			xml += "</TouchImageBatchsContainer>\n";
		}
		xml += "</ZBox>";
		if (createXml && fileName != null) {
			var xmlSavePath:String = outdir + StringTools.replace(fileName, ".xml", "") + ".xml";
			trace("创建XML布局文件：", xmlSavePath);
			File.saveContent(xmlSavePath, xml);
			var project = Xml.parse("<project></project>");
			var app = Xml.createElement("app");
			app.set("hdwidth", "1080");
			app.set("hdheight", "1920");
			project.firstElement().insertChild(app, 0);
			var assets = Xml.createElement("assets");
			assets.set("path", "./");
			project.firstElement().insertChild(assets, 0);
			File.saveContent(outdir + "zproject.xml", project.toString());
		}
	}

	public function onPsdExported(pro:Float):Void {
		trace("进度：" + pro);
		if (pro == 1) {
			if (isCreateAtals) {
				// 开始导出精灵图
				var command = "neko "
					+ StringTools.replace(Sys.programPath(), "index.html", "atlas/tools.n")
					+ " \""
					+ psdOutDir
					+ "\" \""
					+ atlasName
					+ "\" "
					+ atlasSize;
				trace("command = ", command);
				ChildProcess.exec(command, null, function(err:Dynamic, stdout, stderr) {
					trace(err, stdout, stderr);
					if (err == null) {
						if (outSlice9) {
							// 单独合并九宫格图
							var atlasSlice9 = 'neko ${StringTools.replace(Sys.programPath(), "index.html", "atlas/tools.n")} ${psdOutDir}/slice9 ${atlasName}_slice9 ${atlasSize}';
							ChildProcess.exec(atlasSlice9, null, function(err:Dynamic, stdout, stderr) {
								trace(err, stdout, stderr);
								if (err == null) {
									callBack(true);
								} else {
									Alert.show("错误", err);
								}
							});
						} else {
							callBack(true);
						}
					} else {
						Alert.show("错误", err);
					}
				});
			} else {
				callBack(true);
			}
		}
	}

	public function getSavePath(path:String):String {
		if (path.indexOf("s9_") != -1 && outSlice9) {
			// 当为九宫格图时，并且希望脱离九宫格图时，请返回新的路径
			var p = path.substr(0, path.indexOf("s9_")) + "/slice9";
			if (!FileSystem.exists(p))
				FileSystem.createDirectory(p);
			return StringTools.replace(path, "s9_", "slice9/s9_");
		}
		return path;
	}

	public function parserPsGroup(layerChildren:PSTree, outdir:String, a:Dynamic, createBatch:Bool):String {
		var xml:String = "";
		var lastXml:String = null;
		layerChildren.forEach(function(layer:PSTree):Void {
			var id:String = layer.name.indexOf(".") == -1 ? null : layer.name.substr(layer.name.indexOf(".") + 1);
			if (layer.name.indexOf("@fnt") != -1) {
				// 保存fnt
				layer.saveName = Py.getFullChars(layer.name.substr(0, layer.name.indexOf("@")));
				var savePath2:String = outdir + layer.saveName + ".png";
				var saveFntContentPath:String = outdir + layer.saveName + ".fnt";
				if (saveList.indexOf(savePath2) == -1) {
					saveList.push(savePath2);
					psdCount++;
					untyped window.compositeGroupOrLayer(layer, maxWidth, maxHeight, offestX, offestY).then(function(data:Dynamic):Void {
						File.saveBytes(this.getSavePath(savePath2), Bytes.ofData(data));
						trace("保存成功", savePath2);
						psdExported++;
						onPsdExported(psdExported / psdCount);
						// 保存文字列表
						File.saveContent(saveFntContentPath, id);
						if (!isCreateAtals)
							window["Tools"].createFnt(psdOutDir, atlasName);
					}, function(err:Dynamic):Void {
						trace("保存失败", savePath2 + "\n" + err);
					});
				}
			} else if (layer.name.indexOf("@img") != -1 || layer.name.indexOf("@btn") != -1) {
				var maxWidth:Int = null;
				var maxHeight:Int = null;
				var offestX:Dynamic = null;
				var offestY:Dynamic = null;
				// 单图，不需要保留空白区域
				if (layer.name.indexOf("#") != -1) {
					var size:Array<String> = layer.name.substr(layer.name.indexOf("#") + 1, layer.name.indexOf("@") - layer.name.indexOf("#")).split("x");
					maxWidth = Std.parseInt(size[0]);
					maxHeight = Std.parseInt(size[1]);
					offestX = (maxWidth - layer.width) / 2;
					offestY = (maxHeight - layer.height) / 2;
					trace("自定义尺寸", maxWidth, maxHeight, offestX, offestY);
					layer.saveName = Py.getFullChars(layer.name.substr(0, layer.name.indexOf("#")));
					layer.srcName = (atlasName != null ? atlasName + ":" : "") + layer.saveName;
				} else {
					layer.saveName = Py.getFullChars(layer.name.substr(0, layer.name.indexOf("@")));
					layer.srcName = (atlasName != null ? atlasName + ":" : "") + layer.saveName;
				}
				var savePath:String = outdir + layer.saveName + ".png";
				if (saveList.indexOf(savePath) == -1) {
					saveList.push(savePath);
					psdCount++;
					untyped window.compositeGroupOrLayer(layer, maxWidth, maxHeight, offestX, offestY).then(function(data:Dynamic):Void {
						File.saveBytes(this.getSavePath(savePath), Bytes.ofData(data));
						trace("保存成功", savePath);
						psdExported++;
						onPsdExported(psdExported / psdCount);
					}, function(err:Dynamic):Void {
						trace("保存失败", savePath + "\n" + err);
					});
				}
				if (layer.name.indexOf("@img.content") != -1
					&& (lastXml.indexOf("<ZButton") != -1 || lastXml.indexOf("<BButton") != -1 || lastXml.indexOf("<BScale9Button") != -1)) {
					// 上下文绑定
					lastXml += "content=\"" + layer.srcName + "\"/>\n";
					xml += lastXml;
					lastXml = null;
					return;
				} else if (lastXml != null) {
					lastXml += "/>\n";
					xml += lastXml;
					lastXml = null;
				}
				if (createBatch)
					lastXml = "    <"
						+ (layer.name.indexOf("@img") != -1 ? (layer.saveName.indexOf("s9_") == 0 ? "BScale9Image width=\""
							+ layer.width
							+ "\" height=\""
							+ layer.height
							+ "\"" : "BImage") : (layer.saveName.indexOf("s9_") == 0 ? "BScale9Button width=\""
								+ layer.width
								+ "\" height=\""
								+ layer.height
								+ "\"" : "BButton"))
						+ (id == null ? "" : " id=\"" + id + "\"")
						+ " src=\""
						+ layer.srcName
						+ "\" centerX=\""
						+ ((layer.left + layer.width / 2) - psd2width)
						+ "\" centerY=\""
						+ ((layer.top + layer.height / 2) - psd2height)
						+ "\" ";
				else
					lastXml = "    <"
						+ (layer.name.indexOf("@img") != -1 ? "ZImage" : "ZButton")
						+ (id == null ? "" : " id=\"" + id + "\"")
						+ " src=\""
						+ layer.srcName
						+ "\" centerX=\""
						+ ((layer.left + layer.width / 2) - psd2width)
						+ "\" centerY=\""
						+ ((layer.top + layer.height / 2) - psd2height)
						+ "\" ";
			} else if (layer.name.indexOf("@a") != -1) {
				// 动画文件，需要保留空白区域
				var animeId:String = layer.name.substr(layer.name.lastIndexOf("@") + 1);
				if (!Reflect.hasField(a, animeId)) {
					Reflect.setProperty(a, animeId, []);
				}
				Reflect.getProperty(a, animeId).push(layer);
				layer.saveName = Py.getFullChars(layer.name.substr(0, layer.name.indexOf("@")));
				layer.srcName = (atlasName != null ? atlasName + ":" : "") + layer.saveName;
			} else if (layer.isGroup()) {
				var isNeedBox:Bool = layer.name.indexOf("@box") != -1;
				// 是一个组，判断是否需要容器包含
				if (isNeedBox) {
					if (lastXml != null)
						xml += lastXml + "/>\n";
					lastXml = (createBatch ? "<BBox " : "<ZBox ") + (id != null ? "id=\"" + id + "\" " : "") + "width=\"100%\" height=\"100%\">\n";
					var xml2:String = parserPsGroup(layer.children().reverse(), outdir, a, createBatch);
					if (xml2 != null)
						lastXml += xml2;
					lastXml += (createBatch ? "</BBox>" : "</ZBox>") + "\n";
					if (lastXml != null)
						xml += lastXml;
					lastXml = null;
				}
			}
		});
		if (lastXml != null)
			xml += lastXml + "/>\n";
		return xml;
	}
}
