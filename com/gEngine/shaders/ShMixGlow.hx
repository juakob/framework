package com.gEngine.shaders;

import com.gEngine.painters.CacheTexture;
import com.gEngine.painters.Painter;
import kha.Shaders;
import kha.graphics4.ConstantLocation;
import kha.graphics4.TextureUnit;

import kha.graphics4.Graphics;
import kha.graphics4.PipelineState;

/**
 * ...
 * @author Joaquin
 */
class ShMixGlow extends Painter
{

	public var textureBaseColor:CacheTexture;
	
	var mMaskTextureID:TextureUnit;
	var mAmount:Float;
	var mAmountID:ConstantLocation;
	
	public function new(aBaseColor:CacheTexture,aAmount:Float) 
	{
		textureBaseColor = aBaseColor;
		textureBaseColor.addReference();
		super();
		
	}
	
	override function setShaders(aPipeline:PipelineState):Void 
	{
		aPipeline.vertexShader = Shaders.simple_vert;
		aPipeline.fragmentShader = Shaders.shMixGlow_frag;
	}
	override function getConstantLocations(aPipeline:PipelineState) 
	{
		super.getConstantLocations(aPipeline);
		mMaskTextureID = aPipeline.getTextureUnit("baseColor");
		//mAmountID = aPipeline.getConstantLocation("amount");
	}
	override function setParameter(g:Graphics):Void 
	{
		super.setParameter(g);
		g.setTexture(mMaskTextureID, GEngine.i.mTextures[textureBaseColor.textureID]);
		//g.setFloat(mAmountID, mAmount);
		textureBaseColor.referenceUseFinish();
	}
	
}