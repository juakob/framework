package com.gEngine.shaders;

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
class ShFXAA extends Painter
{
	var mResolutionID:ConstantLocation;
	public function new(aDelete:Bool,aBlend:Blend) 
	{
		super(aDelete,aBlend);
	}
	override function setShaders(aPipeline:PipelineState):Void 
	{
		aPipeline.vertexShader = Shaders.simple_vert;
		aPipeline.fragmentShader = Shaders.fxaa_frag;
	}
	override function getConstantLocations(aPipeline:PipelineState) 
	{
		super.getConstantLocations(aPipeline);
		mResolutionID=aPipeline.getConstantLocation("screenSizeInv");
	}
	override function setParameter(g:Graphics):Void 
	{
		super.setParameter(g);
		g.setFloat2(mResolutionID,1/GEngine.i.width,1/GEngine.i.height);
	}
	
}