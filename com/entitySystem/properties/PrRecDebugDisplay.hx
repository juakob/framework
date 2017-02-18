package com.entitySystem.properties;

import com.entitySystem.operators.Operation;
import entitySystem.Property;

/**
 * ...
 * @author Joaquin
 */
class PrRecDebugDisplay implements Property
{
	
	@ignore
	public var operations:Array<Operation>;

	public var x:Float=0;
	public var y:Float=0;
	public var width:Float=10;
	public var height:Float=10;
	public var offsetX:Float=0;
	public var offsetY:Float=0;
	public var scaleX:Float=1;
	public var scaleY:Float=1;
	
	
	public function new() 
	{
		operations = new Array();
	}
	
	public function serialize():String 
	{
		return "";
	}
	
	
	
	
	
}