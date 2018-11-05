package com.gEngine.shaders;

import com.gEngine.GEngine;
import com.gEngine.display.Blend;
import com.gEngine.painters.CacheTexture;
import com.gEngine.painters.Painter;
import kha.Shaders;
import kha.graphics4.BlendingFactor;
import kha.graphics4.Graphics;
import kha.graphics4.PipelineState;
import kha.graphics4.TextureUnit;


/**
 * ...
 * @author Joaquin
 */
class ShMaxBlend extends Painter
{
	public var textureMask:CacheTexture;
	var mMaskTextureID:TextureUnit;
	public function new(aMask:CacheTexture) 
	{
		textureMask = aMask;
		textureMask.addReference();
		super();
		
	}
	override private function setBlends(aPipeline:PipelineState,aBlend:Blend) 
		{
			aPipeline.blendSource = BlendingFactor.BlendOne;
			aPipeline.blendDestination = BlendingFactor.BlendZero;
			aPipeline.alphaBlendSource = BlendingFactor.InverseDestinationAlpha;
			aPipeline.alphaBlendDestination = BlendingFactor.InverseDestinationAlpha;
		}
		override public function start() 
		{
			
		}
	override function setShaders(aPipeline:PipelineState):Void 
	{
		aPipeline.vertexShader = Shaders.shMask_vert;
		aPipeline.fragmentShader = Shaders.shMaxBlend_frag;
	}
	override function getConstantLocations(aPipeline:PipelineState) 
	{
		super.getConstantLocations(aPipeline);
		mMaskTextureID = aPipeline.getTextureUnit("mask");
	}
	override function setParameter(g:Graphics):Void 
	{
		super.setParameter(g);
		g.setTexture(mMaskTextureID, GEngine.i.mTextures[textureMask.textureID]);
		textureMask.referenceUseFinish();
	}
	
	
}