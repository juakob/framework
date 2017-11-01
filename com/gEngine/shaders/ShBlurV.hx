package com.gEngine.shaders;

import com.gEngine.display.Blend;
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
class ShBlurV extends Painter
{
	var mResolutionID:ConstantLocation;
	public var mFactor:Float;
	public function new(factor:Float = 1,aBlend:Blend) 
	{
		super(true,aBlend);
		mFactor = factor;
	}
	override function setShaders(aPipeline:PipelineState):Void 
	{
		aPipeline.vertexShader = Shaders.hBlurVertexShader_vert;
		aPipeline.fragmentShader = Shaders.blurFragmentShader_frag;
	}
	override public function adjustRenderArea(aArea:MinMax):Void 
	{
		aArea.addBorderWidth(4);
		width = aArea.width();
	}
	var width:Float=1280;
	override function getConstantLocations(aPipeline:PipelineState) 
	{
		super.getConstantLocations(aPipeline);
		mResolutionID=aPipeline.getConstantLocation("resolution");
	}
	override function setParameter(g:Graphics):Void 
	{
		super.setParameter(g);
		g.setFloat2(mResolutionID, 1/width*mFactor,0);
	}
	
}