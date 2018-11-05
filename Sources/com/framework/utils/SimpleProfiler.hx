package com.framework.utils;

/**
 * ...
 * @author Joaquin
 */
class SimpleProfiler
{

	private static var times:Array<Float> = new Array();
	private static var eventName:Array<String> = new Array();
	private static var totalTimes:Array<Float> = new Array();
	private static var eventStack:Array<Int> = new Array();
	
	public static function start(aTag:String)
	{
		var index = eventName.indexOf(aTag);
		if (index < 0)
		{
			eventStack.push(eventName.push(aTag)-1);
			totalTimes.push(0);
		}else {
			eventStack.push(index);
		}
		#if flash
		times.push(flash.Lib.getTimer()/1000);
		#elseif !js
		times.push(Sys.cpuTime());
		#end
		
	}
	public static function end()
	{
		#if flash
		var delta = (flash.Lib.getTimer() / 1000 - times.pop());
		totalTimes[eventStack.pop()] += delta;
		#elseif !js
		var delta = (Sys.cpuTime() - times.pop());
		totalTimes[eventStack.pop()] += delta;
		#end
		
	}
	
	public static function show() {
	
		for (i in 0...eventName.length)
		{
			trace("event: " + eventName[i] + " time: " + totalTimes[i]);
		}
		eventName.splice(0, eventName.length);
		totalTimes.splice(0, totalTimes.length);
	}
	
}