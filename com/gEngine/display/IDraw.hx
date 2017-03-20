package com.gEngine.display;
import com.gEngine.painters.IPainter;
import com.gEngine.painters.Painter;
import com.helpers.Matrix;
import com.helpers.MinMax;
import kha.math.FastMatrix3;


/**
 * @author Joaquin
 */

interface IDraw 
{
	public var parent:IDrawContainer;
	public var visible:Bool;
   function render(batch:IPainter, transform:Matrix):Void;
   function update(elapsedTime:Float):Void;
   function blend():Int;
   function texture():Int;
   function removeFromParent():Void;
    public var x:Float;
	public var y:Float;
	public var scaleX:Float;
	public var scaleY:Float;
	public function getDrawArea(aValue:MinMax):Void;
	public function getTransformation(aMatrix:FastMatrix3=null):FastMatrix3;
	
}