package com.entitySystem;
#if expose
import com.entitySystem.operators.OpFactory;
import com.entitySystem.properties.PrRecDebugDisplay;
import com.entitySystem.system.EsRecDebugDisplay;
import com.gEngine.GEngine;
import entitySystem.Entity;
import entitySystem.EntityChild;
import entitySystem.Message;
import entitySystem.SystemManager.ES;
import entitySystem.listeners.RsCallFunctionPassMessage;
import myComponents.properties.PrAnimation;
#end
/**
 * ...
 * @author Joaquin
 */
class AddDebugRec
{

	public static function addDebugRec(aDisplayGroup:Int) 
	{
		#if expose
		ES.i.add(new EsRecDebugDisplay());
		var entity:Entity = new Entity();
		ES.i.subscribeEntity(entity, Msg.id("showMeta"), RsCallFunctionPassMessage.ID, 
		function(aMessage:Message) {
			
			var prdisplay:PrAnimation = new PrAnimation();
			prdisplay.sprite = GEngine.i.getNewAnimation("recDebug");
			prdisplay.sprite.recenter();

			var child:EntityChild = new EntityChild(aMessage.from);
			child.add(prdisplay);
			
			var displayData:PrRecDebugDisplay = new PrRecDebugDisplay();
			child.add(displayData);
			var metadataRaw:String = aMessage.data;
			var links:Array<String> = metadataRaw.split("?");
			links.pop();//last empty
			links.shift();//first rec word
			for (link in links) 
			{
				OpFactory.decode(link, displayData, child);
			}
			
			
			ES.i.addEntity(child, EsRecDebugDisplay.ID);
			ES.i.addEntity(child, aDisplayGroup);
		}
		,true);
		#end
	}
	
}