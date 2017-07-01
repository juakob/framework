package com.gEngine.shaders;

import com.gEngine.painters.Painter;
import com.helpers.MinMax;
import kha.Shaders;
import kha.graphics4.BlendingFactor;
import kha.graphics4.ConstantLocation;
import kha.graphics4.Graphics;
import kha.graphics4.PipelineState;

/**
 * ...
 * @author Joaquin
 */
class ShBlurH extends Painter
{
	var mResolutionID:ConstantLocation;
	public var mFactor:Float;
	public function new(factor:Float = 1) 
	{
		super();
		mFactor = factor;
	}
	override function setShaders(aPipeline:PipelineState):Void 
	{
		aPipeline.vertexShader = Shaders.hBlurVertexShader_vert;
		aPipeline.fragmentShader = Shaders.blurFragmentShader_frag;
	}
	override public function adjustRenderArea(aArea:MinMax):Void 
	{
		aArea.addBorderHeight(4);
		height = aArea.height();
	}
	var height:Float=720;
	override function getConstantLocations(aPipeline:PipelineState) 
	{
		super.getConstantLocations(aPipeline);
		mResolutionID=aPipeline.getConstantLocation("resolution");
	}
	override function setParameter(g:Graphics):Void 
	{
		super.setParameter(g);
		g.setFloat2(mResolutionID, 0, 1 / height*mFactor);
	}
	
}