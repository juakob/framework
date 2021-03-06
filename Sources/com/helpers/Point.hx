package com.helpers;
import kha.FastFloat;

/**
 * ...
 * @author Joaquin
 */
class Point
{
	public var x:Float;
	public var y:Float;
	
	public function new(aX:Float=0,aY:Float=0) 
	{
		x = aX;
		y = aY;
	}
	public function clone():Point
	{
		return new Point(x, y);
	}
	
	public inline function setTo(aX:Float=0,aY:Float=0):Void
	{
		x = aX;
		y = aY;
	}
	public inline function length():Float {
		return Math.sqrt(x * x + y * y);
	}
	public inline function normalize():Void {
			var length = length();
			x /= length;
			y /= length;
	}
	
	public static inline function Lerp(A:Float,B:Float,s:Float ):Float {
			return A * (1 - s) + B * s;
	}
	public static inline function Length(A:Point, B:Point ):Float {
		var deltaX:Float = A.x - B.x;
		var deltaY:Float = A.y - B.y;
		return Math.sqrt(deltaX * deltaX + deltaY * deltaY);
	}
	
}