package com.framework.utils;
import com.gEngine.GEngine;
import com.gEngine.display.AnimationSprite;
import com.gEngine.display.Layer;

/**
 * ...
 * @author Joaquin
 */
class ProgressionBar
{

	var display:AnimationSprite;
	public function new(aDisplay:AnimationSprite,s:Float=1) 
	{
		display = aDisplay;
		
		set(s);
	}
	public function set(s:Float)
	{
		display.goToAndStop(Std.int(99 * s));
	}
}