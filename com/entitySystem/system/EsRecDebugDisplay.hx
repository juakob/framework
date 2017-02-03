package com.entitySystem.system;

import com.gEngine.display.AnimationSprite;
import entitySystem.EntitySystem;
import entitySystem.Property;
import com.entitySystem.properties.PrRecDebugDisplay;
import entitySystem.PropertyNode;
import myComponents.properties.PrDisplay;

/**
 * ...
 * @author Joaquin
 */
class EsRecDebugDisplay extends EntitySystem<NdRecDebugDisplay>
{

	public function new() 
	{
		super();
		
	}
	override function onAdd(item:NdRecDebugDisplay):Void 
	{
		var properties:Array<Property> = new Array();
		for (property in item.displayData.propertysSource) 
		{
			properties.push(item.owner.get(property));
		}
		item.properties = properties;
	}
	override public function process(item:NdRecDebugDisplay):Void 
	{
		var displayData:PrRecDebugDisplay = item.displayData;
		var sprite:AnimationSprite = item.display.sprite;
		for (i in 0...displayData.varsDestination.length)
		{
			displayData.setValue(displayData.varsDestination[i], item.properties[i].getValue(displayData.varsSource[i]));
		}
		sprite.x = displayData.x;
		sprite.y = displayData.y;
		sprite.offsetX = displayData.offsetX;
		sprite.offsetY = displayData.offsetY;
		sprite.scaleX = (displayData.width/10)*displayData.scaleX;
		sprite.scaleY = (displayData.height/10)*displayData.scaleY;
	}
	
}
class NdRecDebugDisplay extends PropertyNode 
{
	public var displayData:PrRecDebugDisplay;
	@local public var properties:Array<Property>;
	public var display:PrDisplay;
}