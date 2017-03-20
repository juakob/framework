package com.helpers;
import com.helpers.Matrix;
import kha.math.FastVector2;

/**
 * ...
 * @author Joaquin
 */
class MinMax
{
	public var min:Point;
	public var max:Point;
	public function new() 
	{
		min = new Point();
		max = new Point();
	}
	public function reset():Void
	{
		min.setTo(Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY);
		max.setTo(Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY);
	}
	public function merge(aValue:MinMax):Void
	{
		if (min.x > aValue.min.x)
		{
			min.x = aValue.min.x;
		}
		if (min.y > aValue.min.y)
		{
			min.y = aValue.min.y;
		}
		
		if (max.x < aValue.max.x)
		{
			max.x = aValue.max.x;
		}
		if (max.y < aValue.max.y)
		{
			max.y = aValue.max.y;
		}
	}
	
	public function transform(mTransformation:Matrix) 
	{
		//mTransformation.
	}
	public function mergeRec(x:Float,y:Float,width:Float,height:Float):Void
	{
		if (min.x > x)
		{
			min.x = x;
		}
		if (min.y > y)
		{
			min.y =y;
		}
		
		if (max.x < x+width)
		{
			max.x =x+width;
		}
		if (max.y < y+height)
		{
			max.y = y+height;
		}
	}
	public function mergeVec(multvec:FastVector2) 
	{
		if (min.x > multvec.x)
		{
			min.x = multvec.x;
		}
		if (min.y > multvec.y)
		{
			min.y = multvec.y;
		}
		if (max.x < multvec.x)
		{
			max.x = multvec.x;
		}
		if (max.y < multvec.y)
		{
			max.y = multvec.y;
		}
		
	}
	
}