package com.gEngine.display;
import kha.graphics4.BlendingFactor;

/**
 * ...
 * @author Joaquin
 */

class Blend
{
	public var blendSource:BlendingFactor;
	public var blendDestination:BlendingFactor;
	public var alphaBlendSource:BlendingFactor;
	public var alphaBlendDestination:BlendingFactor;
	public function new() 
	{
		
	}
	public static function blendAdd():Blend
	{
		var blend:Blend = new Blend();
		blend.blendSource = BlendingFactor.SourceAlpha;
		blend.blendDestination = BlendingFactor.BlendOne;
		blend.alphaBlendSource = BlendingFactor.SourceAlpha;
		blend.alphaBlendDestination = BlendingFactor.BlendOne;
		return blend;
	}
	public static function blendMultiply():Blend
	{
		var blend:Blend = new Blend();
		blend.blendSource = BlendingFactor.SourceAlpha;
		blend.blendDestination = BlendingFactor.SourceColor;
		blend.alphaBlendSource = BlendingFactor.SourceAlpha;
		blend.alphaBlendDestination = BlendingFactor.SourceAlpha;
		return blend;
	}
	public static function blendMultipass():Blend
	{
		var blend:Blend = new Blend();
		blend.blendSource = BlendingFactor.BlendOne;
		blend.blendDestination = BlendingFactor.BlendZero;
		blend.alphaBlendSource = BlendingFactor.BlendOne;
		blend.alphaBlendDestination = BlendingFactor.BlendZero;
		return blend;
	}
	public static function blendDefault():Blend
	{
		var blend:Blend = new Blend();
		blend.blendSource = BlendingFactor.BlendOne;
		blend.blendDestination = BlendingFactor.InverseSourceAlpha;
		blend.alphaBlendSource = BlendingFactor.BlendOne;
		blend.alphaBlendDestination = BlendingFactor.InverseSourceAlpha;
		return blend;
	}
	
	public static function blendNone():Blend
	{
		var blend:Blend = new Blend();
		blend.blendSource = BlendingFactor.BlendOne;
		blend.blendDestination = BlendingFactor.BlendZero;
		blend.alphaBlendSource = BlendingFactor.BlendOne;
		blend.alphaBlendDestination = BlendingFactor.BlendZero;
		return blend;
	}
}