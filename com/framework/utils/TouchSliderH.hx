package com.framework.utils;
import com.gEngine.display.Layer;

/**
 * ...
 * @author Joaquin
 */
class TouchSliderH extends Entity
{
	public var width:Float;
	public var height:Float;
	public var x:Float;
	public var y:Float;
	public var display:Layer;
	public var scrollLimit:Float =-1;
	public var scrollStart:Float = 0;
	public var slotSize:Float=1;
	
	public function new(aX:Float,aY:Float,aWidth:Float,aHeight:Float) 
	{
		super();
		width = aWidth;
		height = aHeight;
		velocities = new Array();
		for (i in 0...REC_POSITIONS_NUM) 
		{
			velocities.push(0);
		}
		display = new Layer();
		x = aX;
		y = aY;
	}
	var captureMovement:Bool;
	var velocities:Array<Float>;
	var	posIndex:Int=0;
	static inline var REC_POSITIONS_NUM:Int = 3;
	var offset:Float;
	var velocity:Float=0;
	var friction:Float=0.95;
	var slotVel:Float = 0;
	var lock:Bool;
	override function onUpdate(aDt:Float):Void 
	{
		if (Input.i.isMousePressed())
		{
			var mouseX:Float = Input.i.getMouseX();
			var mouseY:Float = Input.i.getMouseY();
			if (mouseX < right() && mouseX > left() && mouseY > top() && mouseY < bottom())
			{
				captureMovement = true;
				offset = display.x - mouseX;
			}
			for (i in 0...REC_POSITIONS_NUM) 
			{
				velocities[i]=0;
			}
		}
		
		if (captureMovement)
		{
			var nextPos:Float = Input.i.getMouseX() + offset;
			posIndex = (++posIndex) % REC_POSITIONS_NUM;
			velocities[posIndex] = (nextPos - display.x)/aDt;
			display.x = nextPos;
			velocity = 0;
			slotVel = 0;
			lock = false;
			
		}else
		if (!lock)
		{
			var delta:Float = (display.x / slotSize) - Std.int(display.x / slotSize);
			var absDelta:Float = Math.abs(delta);
		
			if (Math.abs(velocity)<1000&&(absDelta<0.03||absDelta>0.97))
			{
				slotVel = 0;
				lock = true;
				velocity = 0;
				if (absDelta > 0.5)
				{
					display.x = Std.int(display.x / slotSize-1)*slotSize ;
				}else {
					display.x = Std.int(display.x / slotSize)*slotSize;
				}
			}else
			if(delta!=0){
				if (absDelta > 0.5)
				{
					slotVel -= 1000*aDt ;
				}else {
					slotVel += 1000*aDt ;
				}
				
				if (slotVel < -500)
				{
					slotVel = -500;
				}else if (slotVel > 500)
				{
					slotVel = 500;
				}
			
			}
		}
		if(Input.i.isMouseReleased())
		{
			for (delta in velocities) 
			{
				velocity += delta;
			}
			velocity /= REC_POSITIONS_NUM;
			captureMovement = false;
		}
		
		display.x += (velocity+slotVel )* aDt;
		velocity = velocity * friction;
		
		if (display.x > scrollStart)
		{
			display.x = scrollStart;
			slotVel=velocity = 0;
		}else
		if (scrollLimit > 0 &&-display.x > scrollLimit)
		{
			display.x =-scrollLimit;
			slotVel=velocity = 0;
		}
	}
	inline function  left():Float
	{
		return x;
	}
	inline function  right():Float
	{
		return x+width;
	}
	inline function  top():Float
	{
		return y;
	}
	inline function  bottom():Float
	{
		return y+height;
	}
	public function scroll():Float
	{
		return -display.x;
	}
}