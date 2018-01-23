package com.framework.utils;
import kha.input.Gamepad;

/**
 * ...
 * @author Joaquin
 */
class JoystickProxy
{
	var buttons:Array<Float>;
	var axes:Array<Float>;
	var pressed:Array<Int>;
	var released:Array<Int>;
	
	var gamepad:Gamepad;
	public function new(aId:Int) 
	{
		buttons = new Array();
		axes = new Array();
		pressed = new Array();
		released = new Array();
		
		gamepad = Gamepad.get(aId);
		gamepad.notify(onAxis, onButton);
		//add more than needed just to be safe
		for (i in 0...20) 
		{
			buttons.push(0);
		}
		for (i in 0...7) 
		{
			axes.push(0);
		}
	}
	function onAxis(aId:Int,aValue:Float) 
	{
		axes[aId] = aValue;
	}
	function onButton(aId:Int,aValue:Float) 
	{
		buttons[aId] = aValue;
		if (aValue == 0)
		{
			released.push(aId);
		}else {
			pressed.push(aId);
		}
	}
	public function update() 
	{
		released.splice(0, released.length);
		pressed.splice(0, pressed.length);
	}
	public function buttonPressed(aId:Int):Bool
	{
		for (i in pressed) 
		{
			if (i == aId) return true;
		}
		return false;
	}
	public function buttonReleased(aId:Int):Bool
	{
		for (i in released) 
		{
			if (i == aId) return true;
		}
		return false;
	}
	public function buttonDown(aId:Int):Bool {
		return buttons[aId]==1;
	}
	public function axis(aId:Int):Float {
		return axes[aId];
	}
}