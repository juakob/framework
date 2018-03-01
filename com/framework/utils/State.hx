package com.framework.utils;

import com.framework.Simulation;
import com.gEngine.GEngine;
import kha.Canvas;
import kha.Framebuffer;


/**
 * ...
 * @author joaquin
 */
class State extends Entity 
{
	public function new() 
	{
		super();
	}
	public function load(aResources:Resource):Void{
		
	}
	public function init():Void {
		
	}
	public function changeState(state:State):Void{
		Simulation.i.changeState(state);
	}
	public function draw(aFramebuffer:Canvas):Void
	{
		
	}
	
	public function onActivate() 
	{
		
	}
	
	public function onDesactivate() 
	{
		
	}
	override public function destroy():Void 
	{
		super.destroy();
		GEngine.i.destroy();
	}
}