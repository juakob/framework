package com.gEngine.display;
import com.MyList;
import kha.arrays.Float32Array;

/**
 * ...
 * @author Joaquin
 */
@:allow(Stage)
class Batch
{
	public var toDraw:Float32Array;
	public var counter:Int=0;
	public var texture:Int=0;
	public var blendMode:Int = 0;
	public var renderMode:Int = 0;
	public function new() 
	{

	}
	public function reset()
	{
		counter = 0;
		texture = -1;
		blendMode = 0;
	}
	public  function write(aValue:Float):Void
	{
		toDraw.set(counter, aValue);
		++counter;
	}
	public function destroy():Void
	{
		//toDraw = null;
	}
	
	
}