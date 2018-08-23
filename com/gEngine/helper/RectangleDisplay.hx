package com.gEngine.helper;
import com.MyList;
import com.gEngine.AnimationData;
import com.gEngine.DrawArea;
import com.gEngine.Frame;
import com.gEngine.display.AnimationSprite;
import com.gEngine.display.BasicSprite;

/**
 * ...
 * @author Joaquin
 */
class RectangleDisplay extends AnimationSprite
{
	public static var data:AnimationData;
	public static function init(aTextureID:Int):Void
	{
		data = new AnimationData();
		data.name = "rec?";
		data.dummys = new MyList();
		var frame:Frame = new Frame();
		frame.drawArea = new DrawArea(0, 0, 1, 1);
		frame.vertexs = [0, 0, 1, 0, 0, 1, 1, 1];
		frame.UVs = [0, 0, 1, 0, 0, 1, 1, 1];
		frame.maskBatchs = new MyList();
		frame.blurBatchs = new MyList();
		frame.alphas = new MyList();
		frame.colortTransform = new MyList();
		data.frames = [frame];
		data.texturesID = aTextureID;
		
		
	}
	public function new() {
		super(data);	
	}
	
	public function setColor(r:Int, g:Int, b:Int)
	{
		colorAdd(r / 255, g / 255, b / 255, 1);
	}
}