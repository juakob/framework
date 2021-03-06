package com.gEngine.shaders;

import com.gEngine.GEngine;
import com.gEngine.display.Blend;
import com.gEngine.painters.Painter;
import kha.Shaders;
import kha.graphics4.BlendingFactor;
import kha.graphics4.BlendingOperation;
import kha.graphics4.Graphics;
import kha.graphics4.PipelineState;
import kha.graphics4.TextureUnit;

/**
 * ...
 * @author Joaquin
 */
class ShAdd extends Painter
{
	private var mTextureLigthID:TextureUnit;
	public var textureLightID:Int = 0;
	public function new() 
	{
		super();
		//alpha = 1;
		//red = green = blue = 1;
	}
	override private function setBlends(aPipeline:PipelineState,aBlend:Blend) 
		{
			aPipeline.blendSource = BlendingFactor.BlendOne;
			aPipeline.blendDestination = BlendingFactor.BlendOne;
			aPipeline.alphaBlendSource = BlendingFactor.BlendOne;
			aPipeline.alphaBlendDestination = BlendingFactor.BlendZero;
		}
		
	//override function setShaders(aPipeline:PipelineState):Void 
	//{
		//aPipeline.vertexShader = Shaders.simple_vert;
		//aPipeline.fragmentShader = Shaders.simpleLight_frag;
	//}
	//override function getConstantLocations(aPipeline:PipelineState) 
	//{
		//super.getConstantLocations(aPipeline);
		//mTextureLigthID = aPipeline.getTextureUnit("tex2");
	//}
	//override function setParameter(g:Graphics):Void 
	//{
		//super.setParameter(g);
		//g.setTexture(mTextureLigthID, GEngine.i.mTextures[textureLightID]);
	//}
	
}