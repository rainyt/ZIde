# ZIde
Zygameui的UI可视化编辑器

## 编译
可以进行自行编译，编译前提：
- 1、补全所需的库、如electron、electron-packager等。
- 2、使用Electron编译一次。
- 3、使用生成EXE、或者生成MAC进行生成最终可用包。

## 支持功能
- 支持zygameui的所有渲染特性（同步最新版本11.0.7）。
- 可视化XML立即渲染。
- Ctrl+B（Command+B）可进行快速编译界面。

## WINDOW
- Window版本需要手动为app运行`npm install`来确保库的完整性。
- 需要在app目录下放置zip/unzip.exe命令行工具，以便允许Zide进行更新操作。
- 需要在app/node_moudle下重新安装完整的`sharp`环境，以便允许Zide进行PSD导出操作。