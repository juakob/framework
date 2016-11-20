package com.panelUI;
/**
 * ...
 * @author Joaquin
 */
class Scale extends Transition 
{
	private var mFrom:Float;
	private var mTo:Float;
	public function new(aComponent:Component,aFrom:Float,aTo:Float, aDuration:Float, aDelay:Float=0, TweenFunction:Float->Float=null) 
	{
		mFrom = aFrom;
		mTo = aTo;
		super(aComponent, aDuration, aDelay, TweenFunction);
	}
	override private function compute(s:Float):Void 
	{
		mComponent.scale(Tweens.LERP(s, mFrom, mTo));
	}
	
}

