# 编译并且自动测试electron
build:
	haxe build.hxml
	electron ./bin/electron/ElectronSetup.js