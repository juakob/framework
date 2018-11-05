package com.helpers;
import kha.FastFloat;

/**
 * ...
 * @author Joaquin
 */
class FastPoint
{
	public var x:FastFloat;
	public var y:FastFloat;
	
	public function new(aX:FastFloat=0,aY:FastFloat=0) 
	{
		x = aX;
		y = aY;
	}
	public function clone():FastPoint
	{
		return new FastPoint(x, y);
	}
	
	public inline function setTo(aX:FastFloat=0,aY:FastFloat=0):Void
	{
		x = aX;
		y = aY;
	}
}