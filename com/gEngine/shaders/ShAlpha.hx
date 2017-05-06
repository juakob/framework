package com.gEngine.shaders;

import com.gEngine.painters.Painter;
import kha.Shaders;
import kha.graphics4.BlendingFactor;
import kha.graphics4.ConstantLocation;
import kha.graphics4.Graphics;
import kha.graphics4.PipelineState;

/**
 * ...
 * @author Joaquin
 */
class ShAlpha extends Painter
{
	var mAlpha:Float=1;
	var mAlphaID:ConstantLocation;
	
	public function new(aAlpha:Float=1,aAutoDestroy:Bool=true) 
	{
		super(aAutoDestroy);
		mAlpha = aAlpha;
	}
	override function getConstantLocations(aPipeline:PipelineState) 
	{
		super.getConstantLocations(aPipeline);
		mAlphaID = aPipeline.getConstantLocation("alpha");
	}
	override function setParameter(g:Graphics):Void 
	{
		super.setParameter(g);
		g.setFloat4(mAlphaID, mAlpha,mAlpha,mAlpha,mAlpha);
	}
	override function setShaders(aPipeline:PipelineState):Void 
	{
		aPipeline.vertexShader = Shaders.alpha_vert;
		aPipeline.fragmentShader = Shaders.simpleAlpha_frag;
	}
	
}