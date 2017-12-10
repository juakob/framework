package com.gEngine.shaders;

import com.TimeManager;
import com.gEngine.GEngine;
import com.gEngine.display.Blend;
import com.gEngine.painters.Painter;
import kha.Shaders;
import kha.graphics4.ConstantLocation;
import kha.graphics4.Graphics;
import kha.graphics4.PipelineState;

/**
 * ...
 * @author Joaquin
 */
class ShRgbSplit extends Painter
{
	var resolutionID:ConstantLocation;
	var resX:Float;
	var resY:Float;
	public function new() 
	{
		super(true,Blend.blendMultipass());
		resX = 2 / GEngine.i.realWidth;
		resY = 2 / GEngine.i.realHeight;
	}
	override function setShaders(aPipeline:PipelineState):Void 
	{
		aPipeline.vertexShader = Shaders.simple_vert;
		aPipeline.fragmentShader = Shaders.simpleRgbSplit_frag;
	}
	override function getConstantLocations(aPipeline:PipelineState) 
	{
		super.getConstantLocations(aPipeline);
		resolutionID = aPipeline.getConstantLocation("resolution");
		
	}
	override function setParameter(g:Graphics):Void 
	{
		super.setParameter(g);
		g.setFloat2(resolutionID, resX, resY);
	}
}