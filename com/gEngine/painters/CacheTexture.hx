package com.gEngine.painters;

/**
 * ...
 * @author Joaquin
 */
class CacheTexture extends Painter
{

	public function new(aAutoDestroy:Bool=true) 
	{
		super(aAutoDestroy);
		
	}
	var totalReferences:Int = 0;
	var currentReferences:Int = 0;
	override public function releaseTexture():Bool 
	{
		if (totalReferences == currentReferences)
		{
			currentReferences = 0;
			return true;
		}
		return false;
	}
	public function addReference()
	{
		++totalReferences;
	}
	public function referenceUseFinish()
	{
		++currentReferences;
		if (releaseTexture())
		{
			GEngine.i.releaseRenderTarget(textureID);
		}
	}
}