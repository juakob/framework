package com.gEngine.shaders;

import com.TimeManager;
import com.gEngine.GEngine;
import com.gEngine.painters.Painter;
import kha.Shaders;
import kha.graphics4.ConstantLocation;
import kha.graphics4.Graphics;
import kha.graphics4.PipelineState;

/**
 * ...
 * @author Joaquin
 */
class ShRetro extends Painter
{

	public function new() 
	{
		super();
		
	}
	var mTimer:ConstantLocation;
	override function getConstantLocations(aPipeline:PipelineState) 
	{
		super.getConstantLocations(aPipeline);
		mTimer = aPipeline.getConstantLocation("time");
	}
	override function setShaders(aPipeline:PipelineState):Void 
	{
		aPipeline.vertexShader = Shaders.simpleTime_vert;
		aPipeline.fragmentShader = Shaders.rgbSplit_frag;
	}
	var time:Float=0;
	override function setParameter(g:Graphics):Void 
	{
		time+= TimeManager.delta*5;
		super.setParameter(g);
		g.setFloat4(mTimer,time,time,time,time);
	}
}