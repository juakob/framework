package com.entitySystem.operators;
import com.entitySystem.properties.PrRecDebugDisplay;
import entitySystem.Property;

/**
 * ...
 * @author Joaquin
 */
class OpMul extends OpSet
{

	public function new(aVarDestinationId:Int,aProperty:Property,aVarSourceId:Int) 
	{
		super(aVarDestinationId, aProperty, aVarSourceId);
	}
	
	/* INTERFACE com.entitySystem.operators.Operation */
	
	public override function process(destination:PrRecDebugDisplay):Void 
	{
		#if expose
		var value:Float = Std.parseFloat(destination.getValue(varDestinationId))*Std.parseFloat(property.getValue(varSourceId));
		destination.setValue(varDestinationId, Std.string(value));
		#end
	}
	
}