package com.framework.utils;

/**
 * ...
 * @author Joaquin
 */
class TouchButtonRound extends Entity
{
	public var x(default, default):Float;
	public var y(default, default):Float;
	public var radio(default,set ):Float;
	var sqRadio:Float;
	var touchId:Int =-1;
	public var onRelease:TouchButtonRound->Void;
	public var onTouch:TouchButtonRound->Void;
	public var userData:Dynamic;
	
	public function new(aX:Float=0,aY:Float=0,aRadio:Float=0) 
	{
		super();
		x = aX;
		y = aY;
		radio = aRadio;
	}
	
	public function set_radio(aRadio:Float):Float
	{
		radio = aRadio;
		sqRadio = aRadio * aRadio;
		return aRadio;
	}
	override public function update(aDt:Float):Void 
	{
		super.update(aDt);
		if (touchId >= 0)
		{
			if (!Input.i.touchActive(touchId) || !isTouching(touchId))
			{
				if (onRelease != null)
				{
					onRelease(this);
				}
				touchId =-1;
			}
		}else
		if(Input.i.activeTouchSpots>0) 
		{
			for (i in 0...Input.TOUCH_MAX)
			{
				if (Input.i.touchActive(i))
				{
					if (isTouching(i))
					{
						touchId = i;
						if (onTouch != null)
						{
							onTouch(this);
						}
						break;
					}
				}
			}
		}
	}
	private inline function isTouching(aId:Int):Bool
	{
		var deltaX:Float = x - Input.i.touchX(aId);
		var deltaY:Float = y - Input.i.touchY(aId);
		return deltaX * deltaX + deltaY * deltaY < sqRadio;
	}
}