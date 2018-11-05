package com.helpers;

/**
 * ...
 * @author Joaquin
 */
class Rectangle
{
	public var x:Float;
	public var y:Float;
	public var width:Float;
	public var height:Float;
	public function new(aX:Float=0, aY:Float=0, aWidth:Float=0, aHeight:Float=0 ) 
	{
		x = aX;
		y = aY;
		width = aWidth;
		height = aHeight;
	}
	public function clone():Rectangle
	{
		return new Rectangle(x, y, width, height);
	}
	
	public  function contains(mouseX:Float, mouseY:Float):Bool
	{
		return mouseX > x && mouseX < x + width && mouseY > y && mouseY < y + height;
	}
}