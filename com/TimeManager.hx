package com;

/**
 * ...
 * @author Joaquin
 */
class TimeManager
{

	public static var delta(default, null):Float;
	public static var time(default, null):Float = 0;
	public static var realDelta(default, null):Float;
	
	public static function setDelta(aDelta:Float,aRealTime:Float):Void
	{
		delta = aDelta;
		time = aRealTime;
		realDelta = aDelta;
	}
	
}