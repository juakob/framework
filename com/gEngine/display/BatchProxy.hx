package com.gEngine.display;
import com.MyList;
import kha.arrays.Float32Array;


/**
 * ...
 * @author Joaquin
 */

class BatchProxy
{
	private var pool:MyList<Batch>;
	private var inUse:Int = 0;
	private var current:Batch;
	public var toDraw(get,null):Float32Array;
	public var counter(get,set):Int;
	public var texture(get,set):Int;
	public var blendMode(get,set):Int;
	
	public function new() 
	{
		current = new Batch();
		pool = new MyList();
		pool.push(current);
	}
	
	public function reset():Void
	{
		inUse = 0;
		change();
	}
	public function change():Void
	{
		
		if (pool.length <= inUse)
		{
			pool.push(new Batch());
		}
		current = pool[inUse];
		current.reset();
		++inUse;
	}
	
	//getters
	public function get_toDraw():Float32Array
	{
		return current.toDraw;
	}
	public function get_counter():Int
	{
		return current.counter;
	}
	public function get_texture():Int
	{
		return current.texture;
	}
	public function get_blendMode():Int
	{
		return current.blendMode;
	}
	
	public function set_counter(aValue:Int):Int
	{
		current.counter = aValue;
		return current.counter;
	}
	public function set_texture(aValue:Int):Int
	{
		current.texture = aValue;
		return current.texture;
	}
	public function set_blendMode(aValue:Int):Int
	{
		current.blendMode = aValue;
		return current.blendMode;
	}
}