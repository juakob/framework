package com.gEngine.painters;

/**
 * ...
 * @author Joaquin
 */
class RenderTarget
{
	public var currentReferenceCount:Int = 0;
	public var totalReferenceCount:Int = 0;
	public var textureId:Int =-1;
	public function new() 
	{
		
	}
	public function reset():Void
	{
		currentReferenceCount = 0;
		textureId =-1;
	}
	
}