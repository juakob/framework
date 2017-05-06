package com.gEngine.display.extra;

import com.gEngine.AnimationData;
import com.gEngine.display.AnimationSprite;

/**
 * ...
 * @author Joaquin
 */
class AnimationSpriteClone extends AnimationSprite
{

	public function new(aAnimationData:AnimationData) 
	{
		super(aAnimationData);
		stop();
	}
	public var cloneParent:BasicSprite;
	override function update(aDt:Float)
	{
		CurrentFrame = cloneParent.CurrentFrame;
	}
	
}