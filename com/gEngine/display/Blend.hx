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
		blend.alphaBlendSource = BlendingFactor.BlendOne;
		blend.alphaBlendDestination = BlendingFactor.BlendZero;
		return blend;
	}
}