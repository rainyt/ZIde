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

class AssetsList extends LayoutGroup {
	public function new() {
		super();
		this.width = 200;
		this.backgroundSkin = new RectangleSkin(SolidColor(0x252525));
		this.layoutData = new AnchorLayoutData(36, null, 0, 50);
		this.layout = new AnchorLayout();
		var list = new ListView();
		list.backgroundSkin = null;
		list.itemRendererRecycler = DisplayObjectRecycler.withClass(AssetsListItem);
		this.addChild(list);
		list.itemToText = (data) -> data.name;
		list.layoutData = AnchorLayoutData.fill();
		Utils.listener.addEventListener("assetsProess", function(e) {
			list.dataProvider = new ArrayCollection(App.currentProject.builderFiles);
		});
        list.doubleClickEnabled = true;
		list.addEventListener(Event.CHANGE, function(e) {
			trace("显示文件：" + list.selectedItem.path);
			App.currentEditPath = list.selectedItem.path;
			var xmlData = File.getContent(list.selectedItem.path);
			Editor.current.setEditorData(xmlData);
            StageCavans.current.getStart().openFile(xmlData, App.currentProject);
		});
	}
}

class AssetsListItem extends ItemRenderer {
	public function new() {
		super();
		this.backgroundSkin = new RectangleSkin(SolidColor(0x2a2a2a));
		this.backgroundSkin.width = 200;
		this.textFormat = new TextFormat(Utils.fontName, 12, 0xcccccc);
		this.setSkinForState(ToggleButtonState.UP(true), new RectangleSkin(SolidColor(0x373737)));
		this.setSkinForState(ToggleButtonState.DOWN(true), new RectangleSkin(SolidColor(0x474747)));
		this.setSkinForState(ToggleButtonState.HOVER(true), new RectangleSkin(SolidColor(0x373737)));
		this.setSkinForState(ToggleButtonState.UP(false), new RectangleSkin(SolidColor(0x2a2a2a)));
		this.setSkinForState(ToggleButtonState.DOWN(false), new RectangleSkin(SolidColor(0x3a3a3a)));
		this.setSkinForState(ToggleButtonState.HOVER(false), new RectangleSkin(SolidColor(0x2a2a2a)));
	}
}
