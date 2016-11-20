package com.framework.utils;
//import com.framework.utils.Input.TouchInfo;
import com.gEngine.display.AnimationSprite;
import com.gEngine.display.IDraw;
import com.gEngine.display.Layer;
import com.gEngine.GEngine;
import com.helpers.Point;
import com.helpers.Rectangle;
import kha.math.FastVector2;


/**
 * ...
 * @author ...
 */
class SimpleButton extends Entity
{
	private var mArea:Rectangle;
	
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var width(get, set):Float;
	public var height(get, set):Float;
	public var offset(default, null):Point;
	public var visible(get, set):Bool;
	public var isPress(default, null):Bool;
	
	
	
	public var onClick:SimpleButton->Void;
	
	public var userData:Dynamic;
	public var camera:Camera;
		
	public var display(default,null):AnimationSprite;
	
	public function new(aLayer:Layer ,sprite:AnimationSprite=null) 
	{
		mArea = new Rectangle();
		offset = new Point();
		
		if (sprite == null)
		{
		display = GEngine.i.getNewAnimation("dummy_blue");
		aLayer.addChild(display);
		}else {
		display = sprite;	
		display.goToAndStop(display.labelFrame("hit"));
		mArea = display.calculateBounds();
		display.player.play("up");
		
		}
		
		super();
	}
	
	private var oneFrameDelay:Bool;
	override public function update(aDt:Float):Void 
	{
		isPress = false;
		if (oneFrameDelay &&onClick!=null)
		{
			onClick(this);
			oneFrameDelay = false;
		}else {
			display.scaleX = 1;
			display.scaleY = 1;
		}
		if (press())
		{
			isPress = true;
			display.scaleX = 2;
			display.scaleY = 2;
			oneFrameDelay = true;
		}
		
		super.update(aDt);
		
		//display.x = mArea.x + offset.x;
		//display.y = mArea.y + offset.y;
	}
	public var multitouch:Bool;
	//var touchPoint:TouchInfo;
	var isTouching:Bool;
	var touchId:Int;
	function press():Bool
	{
		//if (multitouch)
		//{
			//if (isTouching && touchPoint.inUse && touchPoint.id == touchId)
			//{
				//return false;
			//}
			//isTouching = false;
			//
			//var numClicks = Input.inst.numberClicks() ;
			//for (i in 0...numClicks)
			//{
				//touchPoint = Input.inst.getTouchPoint(i);
				//if (mArea.contains(touchPoint.x, touchPoint.y))
				//{
					//isTouching = true;
					//touchId = touchPoint.id ;
					//return true;
				//}
			//}
			//return false;
		//}
		if (Input.inst.isMousePressed())
		{
			var matrix = display.getTransformation().inverse();
		var mousePos = matrix.multvec(new FastVector2(Input.inst.getMouseX(), Input.inst.getMouseY()));
	//	if (camera == null)
		
		return  mArea.contains(mousePos.x, mousePos.y);
		}
		return false;
	//	return Input.inst.isMousePressed() && mArea.contains(camera.screenToWorldX(Input.inst.getMouseX()), camera.screenToWorldY(Input.inst.getMouseY()));
	}
	
	
	private function set_x(aX:Float):Float
	{
		display.x = aX;
		
		return aX;
	}
	private function get_x():Float
	{
		return display.x;
	}
	
	private function set_visible(aVisible:Bool):Bool
	{
		display.visible = aVisible;
		
		return display.visible;
	}
	private function get_visible():Bool
	{
		return display.visible;
	}
	
	private function set_y(aY:Float):Float
	{
		display.y = aY;
		return aY;
	}
	private function get_y():Float
	{
		return display.y;
	}
	
	private function set_width(aWidth:Float):Float
	{
		mArea.width = aWidth;
		display.scaleX = aWidth / 10;
		return aWidth;
	}
	private function get_width():Float
	{
		return mArea.width;
	}
	
	private function set_height(aHeight:Float):Float
	{
		mArea.height = aHeight;
		display.scaleY = aHeight / 10;
		return aHeight;
	}
	private function get_height():Float
	{
		return mArea.height;
	}
	override function onDestroy():Void 
	{
		display.removeFromParent();
		onClick = null;
		super.onDestroy();
	}
}