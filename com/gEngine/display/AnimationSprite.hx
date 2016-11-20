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
	
	
}

