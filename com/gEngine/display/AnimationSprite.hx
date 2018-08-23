package com.gEngine.display;
import com.gEngine.AnimationData;


class AnimationSprite extends BasicSprite
{
	public var player(default, null):AnimationPlayer;
	
	public function new(aAnimationData:AnimationData):Void
	{
		super(aAnimationData);
		#if debug
		if (aAnimationData.dummys.length != aAnimationData.frames.length)
		{
			throw "Internal Error, dummy count diferent to frame count";
		}
		#end
		player = new AnimationPlayer(this);
	}
	override public function update(passedTime:Float):Void
	{
		super.update(passedTime);
		player.update(passedTime);
	
	}
	override public function clone():BasicSprite
	{
		var cl:AnimationSprite = new AnimationSprite(mAnimationData);
		cl.scaleX = scaleX;
		cl.scaleY = scaleY;
		cl.colorAdd(addRed, addGreen, addBlue, addAlpha);
		return cl;
	}
	
}

