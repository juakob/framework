package com.gEngine.shaders;


import com.gEngine.painters.Painter;
import kha.Shaders;
import kha.graphics4.BlendingFactor;
import kha.graphics4.PipelineState;

/**
 * ...
 * @author Joaquin
 */
class ShMirage extends Painter
{

	public function new() 
	{
		super();
		
	}
	override function setShaders(aPipeline:PipelineState):Void 
	{
		aPipeline.vertexShader = Shaders.simple_vert;
		aPipeline.fragmentShader = Shaders.mirage_frag;
	}
	override private function setBlends(aPipeline:PipelineState) 
		{
			aPipeline.blendSource = BlendingFactor.BlendOne;
			aPipeline.blendDestination = BlendingFactor.InverseSourceAlpha;
			aPipeline.alphaBlendSource = BlendingFactor.BlendOne;
			aPipeline.alphaBlendDestination = BlendingFactor.InverseSourceAlpha;
		}
}