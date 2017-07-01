package com.gEngine.display;
import com.gEngine.display.AnimationSprite;

/**
 * ...
 * @author Joaquin
 */
class AnimationPlayer 
{
	public var currentAnimation(default,null):String;
	private var mDisplay:BasicSprite;
	private var mLoop:Bool;
	public var onEvent:String->Void;
	public var mLastFrame:Int;
	private var mNextEvent:Int = 99999999;
	private var mEvent:String;
	public function new(aDisplay:BasicSprite) 
	{
		mDisplay = aDisplay;
	}
	private function findNextEvent()
	{
		var label = mDisplay.findNextEvent();
		if (label == null)
		{
			mNextEvent = 99999999;
			return;
		}
		mNextEvent = label.frame;
		mEvent = label.name.substr(1, label.name.length - 2);
	}
	 public function update(aDt:Float):Void 
	{
		if (mNextEvent <= mDisplay.CurrentFrame)
		{
			if (onEvent!=null)
			{
				onEvent(mEvent); 
				
			}
			findNextEvent();
		}
		if (mDisplay.CurrentFrame<=lastFrame&&mDisplay.CurrentFrame>=firtsFrame) return;
		if ( currentAnimation!=null)
		{
			//if (currentLabel.charAt(0) == "[")
			//{
				//if (onEvent!=null)
				//{
					//onEvent(currentLabel.substr(1, currentLabel.length - 2));
				//}
				//return;
			//}
			if(mLoop){
				mDisplay.goToAndPlay(firtsFrame);
				findNextEvent();
			}else 
			{
				
				mDisplay.goToAndStop(lastFrame);
			}
		}
		
	}
	var firtsFrame:Int = 0;
	var lastFrame:Int = 0;
	public inline function play(aAnimation:String,aLoop:Bool=true,aForce:Bool=false):Void
	{
		if (currentAnimation != aAnimation||aForce||!mDisplay.Playing)
		{
			mLoop = aLoop;
			currentAnimation = aAnimation;
			firtsFrame = mDisplay.labelFrame(currentAnimation);
			lastFrame = mDisplay.labelEnd(currentAnimation);
			mDisplay.goToAndStop(firtsFrame);
			mDisplay.play();
			findNextEvent();
		}
	}
	public inline function interchange(aAnimation:String):Void
	{
		if (currentAnimation != aAnimation)
		{
			var delta = mDisplay.CurrentFrame-firtsFrame;
			currentAnimation = aAnimation;
			firtsFrame = mDisplay.labelFrame(currentAnimation);
			mDisplay.goToAndPlay(firtsFrame+delta);
			findNextEvent();
		}
	}
	public inline function stop():Void
	{
		mDisplay.pause();
	}
	public inline function setLoop(aLoop:Bool):Void
	{
		mDisplay.Loop = aLoop;
	}
	public inline function isComplete():Bool
	{
		return !mDisplay.Playing&&!mLoop;
	}
	public function destroy():Void 
	{
		mDisplay = null;
		onEvent = null;
	}
}
