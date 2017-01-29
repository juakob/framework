package com.fx;

import com.framework.utils.Entity;
import com.gEngine.display.AnimationSprite;
import com.gEngine.display.Layer;
import com.gEngine.GEngine;
import com.helpers.Point;



/**
 * ...
 * @author joaquin
 */
class Particle extends Entity 
{
	private var mAnimation:AnimationSprite;
	private var mX:Float=0;
	private var mY:Float=0;
	private var mLife:Float = 0;
	private var mTotalLife:Float;
	private var mVelocity:Point=new Point();
	public var gravity:Float = 100;
	public var mAngularVelocity:Float=0;
	
	public function new(aAnimation:String) 
	{
		super();
		die();
		setAnimation(aAnimation);
	}
	public function setAnimation(animation:String):Void
	{
		mAnimation = GEngine.i.getNewAnimation(animation);
		//mAnimation.frameRate = 1 / 60;
		mAnimation.Loop = false;
	}
	public function reset(x:Float, y:Float, life:Float,speedX:Float,speedY:Float,layer:Layer,angularVelocity:Float,scale:Float=1):Void
	{
		mX = x;
		mY = y;
		mLife =mTotalLife=  life;
		mVelocity.x = speedX;
		mVelocity.y = speedY;
		layer.addChild(mAnimation);
		mAnimation.x = x;
		mAnimation.y = y;
		mAngularVelocity = angularVelocity;
		mAnimation.scaleX = mAnimation.scaleY = mInitialScale =  scale;
		mAnimation.goToAndPlay(0);
		mAnimation.Loop = false;
	}
	override private function limboStart():Void 
	{
		mAnimation.removeFromParent();
	}
	public var scaleAtDeath:Bool;
	private var mInitialScale:Float;
	override public function update(aDt:Float):Void 
	{
		mLife-= aDt;
		if (mLife < 0)
		{
			die();
			return;
		}
		if (scaleAtDeath)
		{
			mAnimation.scaleX = mAnimation.scaleY =mInitialScale* mLife / mTotalLife;
		}
		
		mVelocity.y += gravity * aDt;
		mX += mVelocity.x * aDt;
		mY += mVelocity.y * aDt;
		mAnimation.x = mX;
		mAnimation.y = mY;
		mAnimation.rotation += mAngularVelocity * aDt;
		
		//if (mAnimation.TotalFrames > 0)
		{
			//mAnimation.goToAndStop(Std.int((mAnimation.TotalFrames - 1) * (1-mLife / mTotalLife)));
		}
	}
	
}

