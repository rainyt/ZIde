package base;

import feathers.controls.ButtonState;

class BaseButton extends Button {
    
    public function new() {
        super();
        this.width = 26;
		this.height = 26;
        this.backgroundSkin = null;
		this.textFormat = new TextFormat(Utils.fontName, 9, 0xa6a6a6);
		this.setSkinForState(ButtonState.UP, new RectangleSkin(SolidColor(0x252525)));
		this.setSkinForState(ButtonState.HOVER, new RectangleSkin(SolidColor(0x252525)));
		this.setSkinForState(ButtonState.DOWN, new RectangleSkin(SolidColor(0x111111)));
    }

}