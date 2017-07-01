package com.gEngine.shaders;

import com.gEngine.GEngine;
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
class ShHighLight extends Painter
{
	private var mTextureLigthID:TextureUnit;
	public var textureLightID:Int = 0;
	public function new() 
	{
		super();
		//alpha = 1;
		//red = green = blue = 1;
	}
	override private function setBlends(aPipeline:PipelineState) 
		{
			aPipeline.blendOperation=BlendingOperation.Max;
			super.setBlends(aPipeline);
		}
		override public function multipassBlend() 
		{
			setBlends(pipeline);
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