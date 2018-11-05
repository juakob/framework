package com.panelUI;
import com.MyList;
/**
 * ...
 * @author Joaquin
 */
class ParalelTransition implements ITransition 
{
	
	private var mTransitions:MyList<ITransition>;
	public function new() 
	{
		mTransitions = new MyList<ITransition>();
	}
	public function addTransition(aTransition:ITransition):Void
	{
		mTransitions.push(aTransition);
	}
	public function update(aDt:Float):Void
	{
		var transition:ITransition;
		var pos:Int = 0;
		for (i in 0...mTransitions.length) 
		{
			transition = mTransitions[pos];
			transition.update(aDt);
			if (transition.isFinish())
			{
				transition.setToFinish();
				mTransitions.splice(pos, 1);
				continue;
			}
			++pos;
		}
	}
	
	/* INTERFACE PanelUI.ITransition */
	
	public function isFinish():Bool
	{
		return mTransitions.length==0;
	}
	
	public function setToFinish():Void 
	{
		
	}
	
}

