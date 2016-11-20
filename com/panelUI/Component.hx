package com.panelUI;
/**
 * ...
 * @author Joaquin
 */
class Component 
{
	public var x:Float;
	public var y:Float;
	private var mScale:Float;

	
	
	public function new() 
	{
		
	}

	public function scale(value:Float):Void 
	{
		mScale = value;
	}
	
	public function setxy(x:Float, y:Float):Void
	{
		this.x = x;
		this.y = y;
	}
	
	
}
