package com.panelUI;

/**
 * ...
 * @author Joaquin
 */
class Transition implements ITransition
{
	private var mComponent:Component;
	private var mTime:Float;
	private var mDuration:Float;
	private var mDelay:Float;
	private var mTweenFunction:Float->Float;
	public function new (aComponent:Component,aDuration:Float,aDelay:Float=0,TweenFunction:Float->Float=null) 
	{
		mComponent = aComponent;
		mTime = -aDelay;
		mDuration = aDuration;
		mTweenFunction = TweenFunction;
		if (mTweenFunction==null) {
			mTweenFunction = Tweens.LINEAR;
		}
	}
	
	public function update(aDt:Float):Void
	{
		mTime += aDt;
		if (mTime >= 0 && mTime <= mDuration)
		{
			var s:Float = mTime / mDuration;
			compute(mTweenFunction(s));
		}
	}
	private function compute(s:Float):Void
	{
		
	}
	public function setToFinish():Void
	{
		compute(1);
	}
	public function isFinish():Bool
	{
		return(mTime > mDuration); 
	}
	
	
}

