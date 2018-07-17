package com.gEngine.shaders;

import com.gEngine.display.Blend;
import com.gEngine.painters.CacheTexture;
import com.gEngine.painters.Painter;
import kha.Shaders;
import kha.graphics4.BlendingFactor;
import kha.graphics4.PipelineState;

/**
 * ...
 * @author Joaquin
 */
class ShInverseMask extends ShMask
{

	public function new(aMask:CacheTexture,aBlend:Blend) 
	{
		super(aMask,aBlend);
		
	}
	override function setShaders(aPipeline:PipelineState):Void 
	{
		aPipeline.vertexShader = Shaders.shMask_vert;
		aPipeline.fragmentShader = Shaders.shInverseMask_frag;
	}
	
}