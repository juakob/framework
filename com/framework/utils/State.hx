package com.framework.utils;

import com.framework.Simulation;
import com.gEngine.GEngine;
import kha.Canvas;
import kha.Color;
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
	public function stageColor(r:Float=0,g:Float=0,b:Float=0,a:Float=1) {
		GEngine.i.clearColor = Color.fromFloats(r, g, b, a);
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