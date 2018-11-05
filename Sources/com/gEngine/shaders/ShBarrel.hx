package com.gEngine.shaders;

import com.gEngine.painters.Painter;
import kha.Shaders;
import kha.graphics4.PipelineState;

/**
 * ...
 * @author Joaquin
 */
class ShBarrel extends Painter
{

	public function new() 
	{
		super();
		
	}
	override function setShaders(aPipeline:PipelineState):Void 
	{
		aPipeline.vertexShader = Shaders.simple_vert;
		aPipeline.fragmentShader = Shaders.barrel_frag;
	}
}