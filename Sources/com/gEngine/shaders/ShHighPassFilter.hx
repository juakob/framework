package com.gEngine.shaders;

import com.gEngine.painters.Painter;
import com.helpers.MinMax;
import kha.Shaders;
import kha.graphics4.BlendingFactor;
import kha.graphics4.PipelineState;

/**
 * ...
 * @author Joaquin
 */
class ShHighPassFilter extends Painter
{

	public function new() 
	{
		super();
		
	}
	override function setShaders(aPipeline:PipelineState):Void 
	{
		aPipeline.vertexShader = Shaders.simple_vert;
		aPipeline.fragmentShader = Shaders.HighPassFilter_frag;
	}
}