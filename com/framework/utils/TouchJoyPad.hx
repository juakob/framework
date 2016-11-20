package com.framework.utils;
import com.framework.utils.Input.TouchInfo;
import com.gEngine.display.AnimationSprite;
import com.gEngine.display.Layer;
import com.gEngine.GEngine;

/**
 * ...
 * @author Joaquin
 */
class TouchJoyPad extends Entity
{
	var x:Float;
	var y:Float;
	public var normX(default,null):Float;
	public var normY(default,null):Float;
	var radio:Float;
	var radioSq:Float;
	var display:AnimationSprite;
	var touch:TouchInfo;
	var touchId:Int;
	var isTouching:Bool;
	
	public function new(aX:Float,aY:Float,aRadio:Float,aLayer:Layer) 
	{
		super();
		x = aX;
		y = aY;
		radio = aRadio;
		radioSq = aRadio * aRadio;
		display = GEngine.i.getNewAnimation("dummy_blue");
		display.x = x;
		display.y = y;
		display.scaleX = 40 / 10;
		display.scaleY = 40 / 10;
		aLayer.addChild(display);
	}
	override function onUpdate(aDt:Float):Void 
	{
		if (isTouching)
		{
			if (touch.inUse && touch.id == touchId)
			{
				calculateDelta();
			}else {
				isTouching = false;	
				normX = 0;
				normY = 0;
				display.x = x;
				display.y = y;
			}
		}else {
			var touchPoints = Input.inst.numberClicks();
			for (i in 0...touchPoints) 
			{
				touch = Input.inst.getTouchPoint(i);
				var deltaX = touch.x - x;
				var deltaY = touch.y - y;
				if (deltaX * deltaX + deltaY * deltaY < radioSq)
				{
					calculateDelta();
					isTouching = true;
					break;
				}
			}
		}
		super.onUpdate(aDt);
	}
	private inline function calculateDelta():Void
	{
		var deltaX = touch.x - x;
		var deltaY = touch.y - y;
		var length = Math.sqrt(deltaX * deltaX + deltaY * deltaY);
		
		if (length > radio)
		{
		display.x = x+normX*radio;
		display.y = y + normY * radio;
		normX = deltaX / length;
		normY = deltaY / length;
		}else {
			display.x = x+normX*length;
			display.y = y + normY * length;
			normX = deltaX / radio;
			normY = deltaY / radio;
		}
	}
	override function onDestroy():Void 
	{
	
		 super.onDestroy();
	}
}