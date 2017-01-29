package com.fx;
import com.framework.utils.Entity;
import com.gEngine.display.Layer;

/**
 * ...
 * @author joaquin
 */
 class Emitter extends Entity 
{
	public var minVelocityX:Float=0;
	public var maxVelocityX:Float=0;
	public var minVelocityY:Float=0;
	public var maxVelocityY:Float = 0;
	
	public var minScale:Float = 1;
	public var maxScale:Float = 1;
	
	public var maxLife:Float=0;
	public var minLife:Float=0;
	
	private var mContainer:Layer;
	
	private var mPlaying:Bool;
	private var mTimePlaying:Bool;
	
	private var mTime:Float = 0;
	
	public var x(get, set):Float;
	public var y(get, set):Float;
	
	public var xRandom:Float = 0;
	public var yRandom:Float = 0;
	
	public var angularVelocityMax :Float=0;
	public var angularVelocityMin :Float = 0;
	
	public var gravity:Float=0;
	
	
	public function new() 
	{
		super();
		pool = true;
		mContainer = new Layer();
	}
	
	public function reset(layer:Layer):Void
	{
		layer.addChild(mContainer);
	}
	
	override private function limboStart():Void 
	{
		mContainer.removeFromParent();
	}
	
	public function start(emittTime:Float=0):Void
	{
		mPlaying = true;
		if (emittTime > 0)
		{
			mTimePlaying = true;
			mTime = emittTime;
		}
	}
	public function stop():Void
	{
		mPlaying = false;
		mTimePlaying = false;
	}
	
	override private function onUpdate(aDt:Float):Void 
	{
		mContainer.x = x;
		mContainer.y = y;
		if (mTimePlaying)
		{
			mTime-= aDt;
			if (mTime < 0)
			{
				stop();
			}
		}
		if (!mPlaying)
		{
			if (numAliveChildren() == 0)
			{
				die();
			}
			return;
		}
		while (numAliveChildren() != currentCapacity())
		{
			var particle:Particle = cast(recycle(Particle));
			particle.reset(xRandom-xRandom*2*Math.random(), yRandom-yRandom*2*Math.random(), minLife + maxLife * Math.random(), minVelocityX + maxVelocityX * Math.random(), minVelocityY + maxVelocityY * Math.random(), mContainer,angularVelocityMin+angularVelocityMax*Math.random(),minScale+maxScale*Math.random());
			particle.gravity = gravity;
		}
		
	}
	
	
	public function get_x():Float 
	{
		return mContainer.x;
	}
	public function set_x(aValue:Float):Float 
	{
		return mContainer.x = aValue;
	}
	public function get_y():Float 
	{
		return mContainer.y;
	}
	public function set_y(aValue:Float):Float 
	{
		return mContainer.y = aValue;
	}
	
	
}

