package com.entitySystem.operators;
import com.entitySystem.properties.PrRecDebugDisplay;
import entitySystem.Property;

/**
 * ...
 * @author Joaquin
 */
class OpMulFix implements Operation
{
	var varDestinationId:Int;
	var value:Float;
	
	public function new(aVarDestinationId:Int,aValue:Float) 
	{
		varDestinationId = aVarDestinationId;
		value = aValue;
		trace(aValue);
	}
	
	public function process(destination:PrRecDebugDisplay):Void 
	{
		var value:Float = Std.parseFloat(destination.getValue(varDestinationId))*value;
		destination.setValue(varDestinationId, Std.string(value));
	}
	
}