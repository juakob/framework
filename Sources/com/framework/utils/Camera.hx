package com.framework.utils;
import com.helpers.FastPoint;

/**
 * ...
 * @author joaquin
 */
 class Camera
{
	private var mTargetPos:FastPoint;
	private var mPosition:FastPoint;
	
	public var mMin:FastPoint;
	private var mMax:FastPoint;
	
	private var mScreenWidth:Float;
	private var mScreenHeight:Float;
	
	public var scale:Float = 1;
	public var scaleX:Float=1;
	public var scaleY:Float = 1;
	public var angle:Float = 1;
	public var angleInverse:Float = 1;
	
	private var mTime:Float;
	private var mMaxShakeX:Float;
	private var mMaxShakeY:Float;
	private var mTotalTime:Float;
	private var mShakeInterval:Float=0;
	private var mLastShake:Float=0;
	
	public function new(screenWidth:Float = 0,screenHeight:Float=0 ) 
	{
		mTargetPos = new FastPoint();
		mPosition = new FastPoint();
		mScreenWidth = screenWidth;
		mScreenHeight = screenHeight;
		
	}
	
	public function limits(minX:Float, maxX:Float, minY:Float, maxY:Float):Void
	{
		mMin = new FastPoint(minX, minY);
		mMax = new FastPoint(maxX, maxY);
		if (mMax.x - mMin.x < mScreenWidth*scale)
		{
			mMax.x = mMin.x + mScreenWidth*scale;
		}
		if (mMax.y - mMin.y < mScreenHeight*scale)
		{
			mMax.y = mMin.y + mScreenHeight*scale;
		}
	}
	public function setTarget(x:Float, y:Float):Void
	{
		mTargetPos.setTo(x-mScreenWidth*0.5, (y-mScreenHeight*0.5*angleInverse));
	}
	public function goTo(x:Float, y:Float):Void
	{
		mPosition.setTo(x-mScreenWidth*0.5, (y-mScreenHeight*0.5*angleInverse));
	}
	public inline function worldToCameraX(x:Float):Float
	{
		return ((x - mPosition.x)-mScreenWidth/2)*scaleX+mScreenWidth/2;
	}
	public inline function worldToCameraY(y:Float):Float
	{
		return (((y - mPosition.y)-mScreenHeight)*scaleY+mScreenHeight)*angle;
	}
	public inline function screenToWorldX(x:Float):Float
	{
		return (x -mScreenWidth/2)*1/scaleX + mScreenWidth/2+ mPosition.x;
	}
	public inline function screenToWorldY(y:Float):Float
	{
		return ((y-mScreenHeight/2)*1/scaleY+mScreenHeight/2)*angleInverse+mPosition.y;
	}
	public var maxSeparationFromTarget:Float = 100 * 100;
	public function update(aDt:Float):Void 
	{
		//mPosition.x = (mPosition.x + mTargetPos.x) * 0.5 ;
		//mPosition.y = (mPosition.y + mTargetPos.y) * 0.5 ;
		
		//mPosition.x = (mPosition.x + mTargetPos.x) * 0.5 ;
		//mPosition.y = (mPosition.y + mTargetPos.y) * 0.5 ;
		
		//mPosition.x = (mPosition.x + mTargetPos.x) * 0.5 ;
		//mPosition.y = (mPosition.y + mTargetPos.y) * 0.5 ;
		mPosition.x = mTargetPos.x ;
		mPosition.y = mTargetPos.y ;
		
		var deltaX:Float = mPosition.x - mTargetPos.x;
		var deltaY:Float = mPosition.y - mTargetPos.y;
		if (deltaX * deltaX + deltaY * deltaY > maxSeparationFromTarget*maxSeparationFromTarget)
		{
			var length:Float = Math.sqrt(deltaX * deltaX + deltaY * deltaY);
			mPosition.x = mTargetPos.x + (deltaX / length)*maxSeparationFromTarget;
			mPosition.y = mTargetPos.y + (deltaY / length)*maxSeparationFromTarget;
		}
		
		adjustToLimits();
		if (mTime > 0)
			{
				mTime-= aDt;
				mLastShake += aDt;
				if (mLastShake >= mShakeInterval)
				{
					mLastShake = 0;
					var s:Float = mTime / mTotalTime;
					
					mPosition.x += mMaxShakeX*s * 2 - Math.random() * mMaxShakeX;
					mPosition.y += mMaxShakeY*s * 2 - Math.random() * mMaxShakeY;
				}
			}
	}
	
	public function isVisible(aX:Float, aY:Float,radio:Float=0):Bool 
	{
		aX = worldToCameraX(aX);
		aY = worldToCameraY(aY);
		return !(aX + radio<0||aX-radio>mScreenWidth*scale||aY+radio<0||aY-radio>mScreenHeight*scale*angleInverse);
		//return aX+radio > mPosition.x && aX-radio < mPosition.x + mScreenWidth*scale && aY+radio > mPosition.y && aY-radio < mPosition.y + mScreenHeight*scale;
	}
	
	public inline function  screenHeight():Float 
	{
		return mScreenHeight ;
	}
	
	public inline function  screenWidth():Float 
	{
		return mScreenWidth ;
	}
	public inline function  cameraCenterX():Float
	{
		return mPosition.x + mScreenWidth * 0.5 * scale;
	}
	public inline function  cameraCenterY():Float
	{
		return mPosition.y + mScreenHeight * 0.5 * scale;
	}
	private function adjustToLimits():Void
	{
		if (mMin!=null)
		{
			if (mPosition.x < mMin.x)
			{
				mPosition.x = mMin.x;
			}else if (mPosition.x+mScreenWidth*scale > mMax.x)
			{
				mPosition.x = mMax.x - mScreenWidth*scale;
			}
			
			if (mPosition.y < mMin.y)
			{
				mPosition.y = mMin.y;
			}else if (mPosition.y+mScreenHeight*scale*angleInverse > mMax.y)
			{
				mPosition.y = (mMax.y - mScreenHeight*scale*angleInverse);
			}
		}
	}
	
	public function shake(aTime:Float=-1, aMaxX:Float=10, aMaxY:Float=10,aShakeInterval:Float=0.1):Void
		{
			mTime =mTotalTime= aTime;
			if (mTime < 0)
			{
				mTime =Math.POSITIVE_INFINITY;
			}
			mMaxShakeX = aMaxX;
			mMaxShakeY = aMaxY;
			mShakeInterval = aShakeInterval;
		}
		public function stopShake():Void
		{
			mTime =mTotalTime= 0;
		}
}
