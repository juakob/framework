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
	
}