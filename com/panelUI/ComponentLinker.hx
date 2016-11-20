package com.panelUI;
import com.gEngine.display.IDraw;

/**
 * ...
 * @author Joaquin
 */
class ComponentLinker extends Component 
{
	private var display:IDraw;
	
	public function new(displayObject:IDraw) 
	{
		super();
		display = displayObject;
	}
	override public function setxy(x:Float, y:Float):Void 
	{
		super.setxy(x, y);
		display.x = x;
		display.y = y;
	}
	override public function scale(value:Float):Void 
	{
		super.scale(value);
		display.scaleX = display.scaleY = value;
	}
	
}
