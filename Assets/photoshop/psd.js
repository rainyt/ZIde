window.sharp = require('sharp');

window.compositeGroupOrLayer = async (group,maxwidth,maxheight,offestX,offestY) => {
    let info = group.export();
  
    let children = group.children().reverse();
  
    let img = window.sharp({
      create: {
        width: maxwidth != null ? maxwidth : info.width,
        height: maxheight != null ? maxheight : info.height,
        channels: 4,
        background: { r: 0, g: 0, b: 0, alpha: 0 }
      }
    });
    let childPngs = [];

    if(children.length == 0){
      //单张图
      children = [group];
    }

    for (let i = 0, len = children.length; i < len; i++) {
      let png = children[i].toPng();
      if(png.width == 0 || png.height == 0)
        continue;
      png.filterType = 0;
      let buf;
      let childInfo = children[i].export();
      if (children[i].isGroup()) {
        buf = await compositeGroupOrLayer(children[i]);
      } else {
        buf = await toBuf(png.pack());
      }
  
      let image = {
        input: buf,
        top: Math.round(childInfo.top - info.top + (offestY != null?offestY:0)),
        left: Math.round(childInfo.left - info.left + (offestX != null?offestX:0))
      };
  
      childPngs.push(image);
    }
    
    let buf = await toBuf(img.png().composite(childPngs));
  
    return buf;
  };

const toArray = require('stream-to-array');

const toBuf = async (stream) => {
  const parts = await toArray(stream)
  const buffers = parts.map(part => Buffer.isBuffer(part) ? part : Buffer.from(part));
  return Buffer.concat(buffers);
};

