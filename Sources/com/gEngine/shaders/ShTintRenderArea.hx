package com.gEngine.shaders;

import com.gEngine.display.Blend;
import com.gEngine.painters.Painter;
import kha.Shaders;
import kha.graphics4.PipelineState;

/**
 * ...
 * @author Joaquin
 */
class ShTintRenderArea extends Painter
{

	public function new(aAutoDestroy:Bool=true,blend:Blend) 
	{
		super(aAutoDestroy,blend);
		
	}
	override function setShaders(aPipeline:PipelineState):Void 
	{
		aPipeline.vertexShader = Shaders.simple_vert;
		aPipeline.fragmentShader = Shaders.renderAreaTint_frag;
	}
}