package com.debug;
import kha.Scheduler;

/**
 * ...
 * @author Joaquin
 */
class Profiler
{

	public static var functionsTimes:Array<Array<Float>>=new Array();
	public static var functionsNames:Array<String> = new Array();
	public static var enable:Bool = false;
	
	public static function startMeasure(aName:String) {
		if(enable){
			var index = functionsNames.indexOf(aName);
			if (index < 0) {
				index = functionsNames.push(aName)-1;
				functionsTimes.push(new Array());
			}
			functionsTimes[index].push(Scheduler.realTime());
		}
	}
	
	public static function endMeasure(aName:String) {
		if(enable){
			var index = functionsNames.indexOf(aName);
			if (index < 0) {
				return;
			}
			var endIndex = functionsTimes[index].length-1;
			functionsTimes[index][endIndex] = Scheduler.realTime() - functionsTimes[index][endIndex];
		}
	}
	public static function show() {
		trace("Profiler///////////////////////////////");
		var i:Int = 0;
		for (name in functionsNames) 
		{
			var activeTime:Float = 0;
			var times:Array<Float> = functionsTimes[i];
			for (time in times) 
			{
				activeTime+= time;
			}
			trace(name+" - " + activeTime/times.length +" - %"+ (activeTime/times.length)/(1/60));
			++i;
		}
	}
	public static function clear() {
		functionsNames.splice(0, functionsNames.length);
		functionsTimes.splice(0, functionsTimes.length);
	}
	
	
}