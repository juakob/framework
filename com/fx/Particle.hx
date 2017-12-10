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
	public var animation:AnimationSprite;
	private var mX:Float=0;
	private var mY:Float=0;
	private var mLife:Float = 0;
	private var mTotalLife:Float;
	private var mVelocity:Point=new Point();
	public var gravity:Float = 100;
	public var accelerationX:Float = 0;
	public var mAngularVelocity:Float=0;
	
	public function new(aAnimation:String) 
	{
		super();
		die();
		setAnimation(aAnimation);
	}
	public function setAnimation(aAnimation:String):Void
	{
		animation = GEngine.i.getNewAnimation(aAnimation);
		//mAnimation.frameRate = 1 / 60;
		animation.Loop = false;
	}
	public function reset(x:Float, y:Float, life:Float,speedX:Float,speedY:Float,layer:Layer,angularVelocity:Float,scale:Float=1):Void
	{
		
		mX = x;
		mY = y;
		mLife =mTotalLife=  life;
		mVelocity.x = speedX;
		mVelocity.y = speedY;
		layer.addChild(animation);
		animation.x = x;
		animation.y = y;
		mAngularVelocity = angularVelocity;
		animation.scaleX = animation.scaleY = mInitialScale =  scale;
		animation.goToAndPlay(0);
		animation.Loop = false;
		animation.rotation = 0;
	}
	override private function limboStart():Void 
	{
		animation.removeFromParent();
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
			animation.scaleX = animation.scaleY =mInitialScale* mLife / mTotalLife;
		}
		
		mVelocity.y += gravity * aDt;
		mVelocity.x += accelerationX * aDt;
		mX += mVelocity.x * aDt;
		mY += mVelocity.y * aDt;
		animation.x = mX;
		animation.y = mY;
		animation.rotation += mAngularVelocity * aDt;
		
		//if (mAnimation.TotalFrames > 0)
		{
			//mAnimation.goToAndStop(Std.int((mAnimation.TotalFrames - 1) * (1-mLife / mTotalLife)));
		}
	}
	
}

