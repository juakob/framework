package com.gEngine.shaders;


import com.gEngine.display.Blend;
import com.gEngine.painters.Painter;
import kha.Shaders;
import kha.graphics4.BlendingFactor;
import kha.graphics4.Graphics;
import kha.graphics4.PipelineState;

/**
 * ...
 * @author Joaquin
 */
class ShMirage extends Painter
{
	var time:kha.graphics4.ConstantLocation;
	
	public function new() 
	{
		super(true);
		
	}
	override function setShaders(aPipeline:PipelineState):Void 
	{
		aPipeline.vertexShader = Shaders.simple_vert;
		aPipeline.fragmentShader = Shaders.mirage_frag;
	}
	override function getConstantLocations(aPipeline:PipelineState) 
	{
		super.getConstantLocations(aPipeline);
		time = aPipeline.getConstantLocation("time");
	}
	override function setParameter(g:Graphics):Void 
	{
		super.setParameter(g);
		g.setFloat(time, TimeManager.time*2);
	}
	override private function setBlends(aPipeline:PipelineState,aBlend:Blend) 
		{
			aPipeline.blendSource = BlendingFactor.BlendOne;
			aPipeline.blendDestination = BlendingFactor.BlendZero;
			aPipeline.alphaBlendSource = BlendingFactor.BlendOne;
			aPipeline.alphaBlendDestination = BlendingFactor.BlendZero;
		}
}