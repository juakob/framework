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
			switch atlas.type {
				case AtlasType.SpriteSheet: fromSpriteSheet(atlas);
				case AtlasType.Sparrow: fromSparrow(atlas);
				
			}
		}
		
	}
	public static function fromSpriteSheet( atlas:AtlasInfo):Void
	{
		
		var image:Image = Reflect.field(kha.Assets.images, atlas.image);
		var spritesCount:Int = Std.int(image.width / atlas.spriteWidth) * Std.int(image.height / atlas.spriteHeight);
		
		var frames:MyList<Frame> = new MyList();
		var names:MyList<Label> = new MyList();
		var textures:MyList<MyList<String>> = new MyList();
		var dummys:MyList<MyList<Dummy>> = new MyList();
		var maskBatch:MyList<MaskBatch> = new MyList();

		for (counter in 0...spritesCount)
		{
			var list:MyList<String> = new MyList();
			list.push(atlas.name+counter);
			textures.push(list);
			dummys.push(new MyList());
			var x = (counter%Std.int(image.width/ atlas.spriteWidth))*atlas.spriteWidth;
			var y = Std.int(counter * atlas.spriteWidth / image.width)*atlas.spriteHeight;
			frames.push(createFrame(0, 0, atlas.spriteWidth, atlas.spriteHeight, false));
			
			var bitmap:Bitmap = new Bitmap();
			bitmap.x = x-1;
			bitmap.y = y-1;
			bitmap.width = atlas.spriteWidth+2;
			bitmap.height = atlas.spriteHeight+2;
			bitmap.name = atlas.name+counter;
			bitmap.image = image;
			atlas.bitmaps.push(bitmap);
		}
		
		GEngine.i.addResource(atlas.name, frames, dummys, names, textures, maskBatch);
	}
	public static function fromSparrow( atlas:AtlasInfo):Void
	{
		/* var text:Blob = Reflect.field(kha.Assets.blobs, atlas.data);
		var data:Access = new Access(Xml.parse(text.toString()).firstElement());
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
			var names:MyList<String> = new MyList();
			names.push(name);
			textures.push(names);
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
		}
		
		GEngine.i.addResource(atlas.name, frames, dummys, names, textures, maskBatch); */
	}
	public static function createFrame( x:Int, y:Int, width:Int, height:Int, rotated:Bool):Frame
	{
		if (rotated) {
			var temp = width;
			width = height;
			height = temp;
		}
		var frame:Frame = new Frame();
		frame.alphas = new MyList();
		frame.blurBatchs = new MyList();
		frame.colortTransform = new MyList();
		frame.vertexs = new MyList();
		frame.UVs = new MyList();
		frame.maskBatchs = new MyList();
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