package com.panelUI ;
import com.MyList;

/**
 * ...
 * @author Joaquin
 */
class SequenceTransition implements ITransition 
{
	private var mTransitions:MyList<ITransition>;
	private var mCurrentTransition:ITransition;
	public function new() 
	{
		mTransitions = new MyList<ITransition>();
	}

	public function add(aTransition:ITransition):Void
	{
		if (mCurrentTransition == null)
		{
			mCurrentTransition = aTransition;
		}else{
			mTransitions.push(aTransition);
		}
	}
	public function update(aDt:Float):Void 
	{
		if (mCurrentTransition != null)
		{
			mCurrentTransition.update(aDt);
			if (mCurrentTransition.isFinish())
			{
				mCurrentTransition.setToFinish();
				mCurrentTransition = mTransitions.shift();
			}
		}
	}
	
	public function isFinish():Bool
	{
		return mCurrentTransition == null;
	}
	
	public function setToFinish():Void 
	{
		
	}
	
}