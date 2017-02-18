package com.entitySystem.operators;
import com.entitySystem.properties.PrRecDebugDisplay;
import entitySystem.Property;

/**
 * ...
 * @author Joaquin
 */
class OpSet implements Operation
{
	var varDestinationId:Int;
	var property:Property;
	var varSourceId:Int;
	
	public function new(aVarDestinationId:Int,aProperty:Property,aVarSourceId:Int) 
	{
		varDestinationId = aVarDestinationId;
		property = aProperty;
		varSourceId = aVarSourceId;
	}
	
	/* INTERFACE com.entitySystem.operators.Operation */
	
	public function process(destination:PrRecDebugDisplay):Void 
	{
		destination.setValue(varDestinationId, property.getValue(varSourceId));
	}
	
}