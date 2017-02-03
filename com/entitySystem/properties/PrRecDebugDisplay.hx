package com.entitySystem.properties;

import entitySystem.Property;

/**
 * ...
 * @author Joaquin
 */
class PrRecDebugDisplay implements Property
{
	
	@ignore
	public var propertysSource:Array<Int>;
	@ignore
	public var varsDestination:Array<Int>;
	@ignore
	public var varsSource:Array<Int>;

	public var x:Float;
	public var y:Float;
	public var width:Float;
	public var height:Float;
	public var offsetX:Float;
	public var offsetY:Float;
	public var scaleX:Float;
	public var scaleY:Float;
	
	
	public function new() 
	{
		
	}
	
	public function serialize():String 
	{
		return "";
	}
	
	
	
	
	
}