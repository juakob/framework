package com.gEngine;
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
		super();
		
	}
	override function setBlends(aPipeline:PipelineState) 
	{
		aPipeline.blendSource = BlendingFactor.BlendOne;
		aPipeline.blendDestination = BlendingFactor.BlendZero;
	}
}