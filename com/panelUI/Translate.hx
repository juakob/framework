package com.panelUI ;
import com.helpers.Point;
/**
 * ...
 * @author Joaquin
 */
class Translate extends Transition 
{
	private var mFrom:Point;
	private var mTo:Point;
	public function new (aComponent:Component,aFrom:Point,aTo:Point,aDuration:Float,aDelay:Float=0,TweenFunction:Float->Float=null)
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

