package com.gEngine.display;
import com.gEngine.painters.IPainter;
import com.gEngine.painters.Painter;
import com.helpers.Matrix;
import com.MyList;
import kha.arrays.Float32Array;


/**
 * ...
 * @author Joaquin
 */
class Stage
{
	public var mLayer:Layer;
	private var mMatrix:Matrix;
	public var x(get, set):Float;
	public var y(get, set):Float;
	
	public function new() 
	{
		mLayer = new Layer();
		mMatrix = new Matrix(1,0,0,1);
	}
	public function update(elapsedTime:Float):Void
	{
		mLayer.update(elapsedTime);
	}
	public function render(aPainter:IPainter):Void
	{
		mLayer.render(aPainter,mMatrix);
		if (aPainter.vertexCount() > 0)
		{
			aPainter.render();
		}
	
	}
	public function addChild(mChild:IDraw):Void
	{
		mLayer.addChild(mChild);
	}
	
	 function get_y():Float
	{
		return mMatrix.ty;
	}
	 function set_y(aValue:Float):Float
	{
		return mMatrix.ty=aValue;
	}
	 function get_x():Float
	{
		return mMatrix.tx;
	}
	 function set_x(aValue:Float):Float
	{
		return mMatrix.tx=aValue;
	}
}