package com.gEngine;
import com.MyList;

/**
 * ...
 * @author Joaquin
 */
class AnimationData
{
	public var name:String;
	public var texturesID:Int = -1;
	public var frames:MyList<Frame>;
	public var dummys:MyList < MyList<Dummy> > ;
	public var labels:MyList <Label > ;
	public function new() 
	{
		
	}
	
	public function clone() 
	{
		var cl = new AnimationData();
		cl.name = name;
		cl.texturesID = texturesID;
		cl.frames = new MyList();
		for (frame in frames) 
		{
			cl.frames.push(frame.clone());
		}
		cl.dummys = new MyList();
		for (frameDummy in dummys) 
		{
			var dummys:MyList<Dummy> = new MyList();
			for (dummy in frameDummy) 
			{
				dummys.push(dummy.clone());
			}
		}
		cl.labels = new MyList();
		for (label in labels) 
		{
			cl.labels.push(label.clone());
		}
		
		return cl;
	}
	
	
}