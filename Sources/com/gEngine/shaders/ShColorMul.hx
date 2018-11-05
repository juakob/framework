package com.gEngine.shaders;

import com.gEngine.painters.Painter;
import kha.Color;
import kha.Shaders;
import kha.graphics4.Graphics;
import kha.graphics4.PipelineState;
import kha.math.FastVector4;

/**
 * ...
 * @author Joaquin
 */
class ShColorMul extends Painter
{
	var mColorMulID:kha.graphics4.ConstantLocation;
	var color:FastVector4;
	public function new(aColor:FastVector4,aAutoDestroy:Bool=true) 
	{
		super(aAutoDestroy);
		//pre multiply
		aColor.x *= aColor.w;
		aColor.y *= aColor.w;
		aColor.z *= aColor.w;
		color = aColor;
	}
	override function setShaders(aPipeline:PipelineState):Void 
	{
		aPipeline.vertexShader = Shaders.simple_vert;
		aPipeline.fragmentShader = Shaders.multiplyColor_frag;
	}
	override function getConstantLocations(aPipeline:PipelineState) 
	{
		super.getConstantLocations(aPipeline);
		mColorMulID = aPipeline.getConstantLocation("colorMul");
	}
	override function setParameter(g:Graphics):Void 
	{
		super.setParameter(g);
		g.setVector4(mColorMulID, color);
	}
}