package com.gEngine;
import com.gEngine.painters.Painter;

/**
 * ...
 * @author Joaquin
 */
class PainterGarbage
{
	public static var i(get, null):PainterGarbage;
	#if debug
	private static var initialized:Bool;
	#end
	private static function get_i():PainterGarbage
	{
		return i;
	}
	public static function init()
	{
		i = new PainterGarbage();
	}
	var painters:Array<Painter>;
	public function new() 
	{
		painters = new Array();
	}
	public function add(aPainter:Painter)
	{
		painters.push(aPainter);
	}
	public function clear()
	{
		for (painter in painters)
		{
			painter.destroy();
		}
		painters.splice(0, painters.length);
	}
}