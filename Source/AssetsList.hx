import base.FilterText;
import openfl.Lib;
import sys.io.File;
import openfl.events.Event;
import openfl.events.MouseEvent;
import feathers.controls.ToggleButtonState;
import feathers.text.TextFormat;
import feathers.utils.DisplayObjectRecycler;
import feathers.controls.dataRenderers.ItemRenderer;
import feathers.data.ArrayCollection;
import feathers.controls.ListView;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import feathers.skins.RectangleSkin;
import feathers.controls.LayoutGroup;

/**
 * 资源列表管理器，会自动筛选出可用的XML文件列表
 */
class AssetsList extends LayoutGroup {
	public function new() {
		super();
		this.width = 200;
		this.backgroundSkin = new RectangleSkin(SolidColor(0x252525));
		this.layoutData = new AnchorLayoutData(36, null, 0, 50);
		this.layout = new AnchorLayout();

		// 筛选功能
		var f = new FilterText();
		this.addChild(f);
		f.layoutData = new AnchorLayoutData(0, 0, null, 0);

		var list = new ListView();
		list.backgroundSkin = null;
		list.itemRendererRecycler = DisplayObjectRecycler.withClass(AssetsListItem);
		this.addChild(list);
		list.itemToText = (data) -> data.name;
		list.layoutData = AnchorLayoutData.fill();
		cast(list.layoutData, AnchorLayoutData).top = 32;
		cast(list.layoutData, AnchorLayoutData).bottom = 20;
		Utils.listener.addEventListener("assetsProess", function(e) {
			f.bindData(App.currentProject.builderFiles);
			list.dataProvider = new ArrayCollection(App.currentProject.builderFiles);
		});
		list.doubleClickEnabled = true;
		list.addEventListener(Event.CHANGE, function(e) {
			if (list.selectedItem == null)
				return;
			trace("显示文件：" + list.selectedItem.path);
			App.currentEditPath = list.selectedItem.path;
			var xmlData = File.getContent(list.selectedItem.path);
			Editor.current.setEditorData(xmlData);
			StageCavans.current.getStart().openFile(xmlData, App.currentProject);
		});

		f.onFilter = function(data) {
			if (data.path.toLowerCase().indexOf(f.text.toLowerCase()) == -1)
				return false;
			return true;
		}
		f.onFiltered = function(data) {
			list.dataProvider = new ArrayCollection(data);
		}
	}
}

class AssetsListItem extends ItemRenderer {
	public function new() {
		super();
		this.backgroundSkin = new RectangleSkin(SolidColor(0x2a2a2a));
		this.textFormat = new TextFormat(Utils.fontName, 12, 0xcccccc);
		this.setSkinForState(ToggleButtonState.UP(true), new RectangleSkin(SolidColor(0x373737)));
		this.setSkinForState(ToggleButtonState.DOWN(true), new RectangleSkin(SolidColor(0x474747)));
		this.setSkinForState(ToggleButtonState.HOVER(true), new RectangleSkin(SolidColor(0x373737)));
		this.setSkinForState(ToggleButtonState.UP(false), new RectangleSkin(SolidColor(0x2a2a2a)));
		this.setSkinForState(ToggleButtonState.DOWN(false), new RectangleSkin(SolidColor(0x3a3a3a)));
		this.setSkinForState(ToggleButtonState.HOVER(false), new RectangleSkin(SolidColor(0x2a2a2a)));
	}
}
