package com.gEngine;
import com.gEngine.display.Blend;
import com.gEngine.painters.Painter;
import kha.graphics4.BlendingFactor;
import kha.graphics4.PipelineState;

/**
 * ...
 * @author Joaquin
 */
class PainterNoBlend extends Painter
{

	public function new() 
	{
		super(true,Blend.blendNone());
		
	}
	override function setBlends(aPipeline:PipelineState,aBlend:Blend) 
	{
		aPipeline.blendSource = BlendingFactor.BlendOne;
		aPipeline.blendDestination = BlendingFactor.BlendZero;
		
	}
}