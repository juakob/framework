package com.gEngine.display.3d;
import kha.math.FastMatrix3;
import com.helpers.MinMax;
import com.helpers.Matrix;
import com.gEngine.painters.IPainter;

import com.gEngine.display.IDraw;
import com.gEngine.display.IDrawContainer;

/**
 * ...
 * @author Joaquin
 */
class Obj3D implements IDraw
{

	public function new() 
	{
		
	}
	
	/* INTERFACE com.gEngine.display.IDraw */
	
	public var parent:IDrawContainer;
	
	public var visible:Bool;
	
	public function render(batch:IPainter, transform:Matrix):Void 
	{
		
	}
	
	public function update(elapsedTime:Float):Void 
	{
		
	}
	
	public function texture():Int 
	{
		
	}
	
	public function removeFromParent():Void 
	{
		
	}
	
	public var x:Float;
	
	public var y:Float;
	
	public var z:Float;
	
	public var scaleX:Float;
	
	public var scaleY:Float;
	
	//public var pipline:
	
	public function getDrawArea(aValue:MinMax):Void 
	{
		
	}
	
	public function getTransformation(aMatrix:FastMatrix3 = null):FastMatrix3 
	{
		
	}
	
}