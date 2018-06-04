package com.panelUI ;
import com.helpers.FastPoint;
/**
 * ...
 * @author Joaquin
 */
class Translate extends Transition 
{
	private var mFrom:FastPoint;
	private var mTo:FastPoint;
	public function new (aComponent:Component,aFrom:FastPoint,aTo:FastPoint,aDuration:Float,aDelay:Float=0,TweenFunction:Float->Float=null)
	{
		mFrom = aFrom;
		mTo = aTo;
		super(aComponent, aDuration, aDelay, TweenFunction);
	}
	override function compute(s:Float):Void 
	{
		mComponent.setxy(Tweens.LERP(s, mFrom.x, mTo.x), Tweens.LERP(s, mFrom.y, mTo.y));
	}
	
}

