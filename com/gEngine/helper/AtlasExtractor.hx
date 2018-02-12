package com.gEngine.helper;
import com.MyList;
import com.framework.utils.Resource.AtlasInfo;
import com.gEngine.AnimationData;
import com.gEngine.DrawArea;
import com.gEngine.Dummy;
import com.gEngine.Frame;
import com.gEngine.Label;
import com.gEngine.MaskBatch;
import com.gEngine.tempStructures.Bitmap;
import haxe.xml.Fast;
import kha.Assets;
import kha.Blob;
import kha.Image;

/**
 * ...
 * @author Joaquin
 */
class AtlasExtractor
{
	static public function extractAtlas(atlases:Array<AtlasInfo>) 
	{
		for (atlas in atlases) 
		{
			fromSparrow(atlas);
		}
		
	}
	public static function fromSparrow( atlas:AtlasInfo):Void
	{
		var text:Blob = Reflect.field(kha.Assets.blobs, atlas.data);
		var data:Fast = new haxe.xml.Fast(Xml.parse(text.readUtf8String()).firstElement());
		var image:Image = Reflect.field(kha.Assets.images, atlas.image);
		
		var frames:MyList<Frame> = new MyList();
		var names:MyList<Label> = new MyList();
		var textures:MyList<MyList<String>> = new MyList();
		var dummys:MyList<MyList<Dummy>> = new MyList();
		var maskBatch:MyList<MaskBatch> = new MyList();
		var counter:Int = 0;
		for (texture in data.nodes.SubTexture)
		{
			var name = texture.att.name;
			var trimmed = texture.has.frameX;
			var rotated = (texture.has.rotated && texture.att.rotated == "true");
			var flipX = (texture.has.flipX && texture.att.flipX == "true");
			var flipY = (texture.has.flipY && texture.att.flipY == "true");
			
			var label:Label = new Label();
			label.name = name;
			label.frame = counter;
			names.push(label);
			++counter;
			textures.push([name]);
			dummys.push(new MyList());
			
			frames.push(createFrame(-Std.parseInt(texture.att.frameX), -Std.parseInt(texture.att.frameY), Std.parseInt(texture.att.width), Std.parseInt(texture.att.height), rotated));
			//var rect = FlxRect.get(Std.parseFloat(texture.att.x), Std.parseFloat(texture.att.y), Std.parseFloat(texture.att.width), Std.parseFloat(texture.att.height));
			var bitmap:Bitmap = new Bitmap();
			bitmap.x = Std.parseInt(texture.att.x)-1;
			bitmap.y = Std.parseInt(texture.att.y)-1;
			bitmap.width = Std.parseInt(texture.att.width)+2;
			bitmap.height = Std.parseInt(texture.att.height)+2;
			bitmap.name = name;
			bitmap.image = image;
			atlas.bitmaps.push(bitmap);
			//
			//var size = if (trimmed)
			//{
				//new Rectangle(Std.parseInt(texture.att.frameX), Std.parseInt(texture.att.frameY), Std.parseInt(texture.att.frameWidth), Std.parseInt(texture.att.frameHeight));
			//}
			//else
			//{
				//new Rectangle(0, 0, rect.width, rect.height);
			//}
			//
			//var angle = rotated ? FlxFrameAngle.ANGLE_NEG_90 : FlxFrameAngle.ANGLE_0;
			//
			//var offset = FlxPoint.get(-size.left, -size.top);
			//var sourceSize = FlxPoint.get(size.width, size.height);
			//
			//if (rotated && !trimmed)
				//sourceSize.set(size.height, size.width);
			//
			//frames.addAtlasFrame(rect, sourceSize, offset, name, angle, flipX, flipY);
		}
		
		GEngine.i.addResource(atlas.name, frames, dummys, names, textures, maskBatch);
	}
	public static function createFrame( x:Int, y:Int, width:Int, height:Int, rotated:Bool):Frame
	{
		if (rotated) {
			var temp = width;
			width = height;
			height = temp;
		}
		var frame:Frame = new Frame();
		frame.alphas = new Array();
		frame.blurBatchs = new Array();
		frame.colortTransform = new Array();
		frame.vertexs = new Array();
		frame.UVs = new Array();
		frame.maskBatchs = new Array();
		frame.drawArea = new DrawArea(x , y , height / 2, width / 2);
		
		frame.UVs.push(0); frame.UVs.push(0);
		frame.UVs.push(1); frame.UVs.push(0);
		frame.UVs.push(0); frame.UVs.push(1);
		frame.UVs.push(1); frame.UVs.push(1);
		
		if (rotated) {
			frame.vertexs.push(x); frame.vertexs.push(y + height);
			frame.vertexs.push(x+width); frame.vertexs.push(y + height);
			frame.vertexs.push(x ); frame.vertexs.push(y);
			
			frame.vertexs.push(x + width); frame.vertexs.push(y );
		}else {
			frame.vertexs.push(x); frame.vertexs.push(y);
			frame.vertexs.push(x); frame.vertexs.push(y + height);
			frame.vertexs.push(x + width); frame.vertexs.push(y);
			
			frame.vertexs.push(x + width); frame.vertexs.push(y + height);
		}
		
		return frame;
	}
}