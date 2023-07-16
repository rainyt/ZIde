# 编译并且自动测试electron
build:
	haxe build.hxml
	cd ElectronSource;haxe electronjs.hxml
	electron ./bin/electron/ElectronSetup.js

upload:
	cd bin/electron && zip -o update.zip md/editor.html md/xml-editor.js atlas china game/* icons lib manifest photoshop ElectronSetup.js index.html ZIde.js && haxelib run aliyun-oss-upload /Users/rainy/Documents/Github/ZIde/bin/electron/update.zip kengsdk_tools_res:1002
            