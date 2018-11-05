package com.entitySystem.operators;
import com.entitySystem.properties.PrRecDebugDisplay;
import entitySystem.Entity;

/**
 * ...
 * @author Joaquin
 */
class OpFactory
{
	
	static public function decode(link:String, displayData:PrRecDebugDisplay,owner:Entity) 
	{
		#if expose
		var linkComponents:Array<String> = link.split(",");
		if (linkComponents.length == 2)
		{
			displayData.setValue(Std.parseInt(linkComponents[0]), linkComponents[1]);
		}else
		if (linkComponents.length == 3)
		{
			displayData.operations.push(new OpSet(	Std.parseInt(linkComponents[0]),
													owner.get(Std.parseInt(linkComponents[1])), 
													Std.parseInt(linkComponents[2])
												)
										);
		}else
		{
			var varsDestinations:Array<String> = linkComponents[0].split("*");
			var propertiesSource:Array<String> = linkComponents[1].split("*");
			var varsSource:Array<String> = linkComponents[2].split("*");
			var operation:Array<String> = linkComponents[3].split("*");
			for (i in 0...varsDestinations.length)
			{
				switch operation[i]
				{
					case "mul":
						displayData.operations.push(new OpMul(	Std.parseInt(varsDestinations[i]),
													owner.get(Std.parseInt(propertiesSource[i])), 
													Std.parseInt(varsSource[i])
												)
										);
					case "mulFix":
						displayData.operations.push(new OpMulFix(	Std.parseInt(varsDestinations[i]),
													Std.parseFloat(varsSource[i])
													)
												);
										
					default:
						displayData.operations.push(new OpSet(	Std.parseInt(varsDestinations[i]),
													owner.get(Std.parseInt(propertiesSource[i])), 
													Std.parseInt(varsSource[i])
												)
										);
				}
			}
			
		}
		#end
	}
	
}