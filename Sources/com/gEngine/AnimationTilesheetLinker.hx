package com.gEngine;
import com.helpers.Rectangle;
import com.MyList;

/**
 * ...
 * @author Joaquin
 */
class AnimationTilesheetLinker
{
	public var image:String;
	public var UVs:MyList<Float>;
	public function new(aImage:String, aRectangle:Rectangle,aWidth:Int,aHeight:Float)
	{
		image = aImage;
		UVs = new MyList();
		//	a-- -c
		//	|   /|
		//	|  / |
		//	| /	 |
		//	b----d
		
		//a
		UVs.push(aRectangle.x / aWidth);
		UVs.push(aRectangle.y / aHeight);
		
		//b
		UVs.push(aRectangle.x / aWidth);
		UVs.push((aRectangle.y+aRectangle.height) / aHeight);
		
		//c
		UVs.push((aRectangle.x +aRectangle.width)/ aWidth);
		UVs.push(aRectangle.y / aHeight);
		
		//d
		UVs.push((aRectangle.x +aRectangle.width)/ aWidth);
		UVs.push((aRectangle.y+aRectangle.height) / aHeight);
		
	}	
	public inline function getUWidth():Float
	{
		return UVs[4] - UVs[0];
	}
	public inline function getVHeight():Float
	{
		return UVs[3] - UVs[1];
	}
	public inline function getUStart():Float
	{
		return UVs[0];
	}
	public  function getVStart():Float
	{
		return UVs[1];
	}
	
}