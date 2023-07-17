# 编译并且自动测试electron
build:
	haxe build.hxml
	cd ElectronSource;haxe electronjs.hxml
	electron ./bin/electron/ElectronSetup.js

# 将资源上传到远程服务器，提供更新功能
upload:
	cd bin/electron; zip -o update.zip md/editor.html md/xml-editor.js atlas china game/* icons lib manifest photoshop ElectronSetup.js index.html ZIde.js && haxelib run aliyun-oss-upload /Users/rainy/Documents/Github/ZIde/bin/electron/update.zip kengsdk_tools_res:1002
            
# 编译Mac运行包
build-mac:
	cd bin/electron; npm run package-mac;