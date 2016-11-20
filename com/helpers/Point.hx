package com.helpers;

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
}