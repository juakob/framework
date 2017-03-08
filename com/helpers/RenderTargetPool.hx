package com.helpers;
import com.gEngine.painters.RenderTarget;
import kha.Image;

/**
 * ...
 * @author Joaquin
 */
class RenderTargetPool
{
	private var targets:Array<ImageProx>;
	public function new() 
	{
		targets = new Array();
	}
	
	public function getFreeImageId():Int
	{
		for (target in targets) 
		{
			if (!target.inUse)
			{
				target.inUse = true;
				return target.textureId;
			}
		}
		return -1;//need to create a new Target
	}
	public function addRenderTarget(aId:Int)
	{
		targets.push(new ImageProx(aId));
	}
	
	public function release(aId:Int) 
	{
		for (target in targets) 
		{
			if (target.textureId == aId)
			{
				target.inUse = false;
				return;
			}
		}
		throw "error";
	}
}
class ImageProx
{
	public var inUse:Bool;
	public var textureId:Int;
	public function new(aId:Int)
	{
		inUse = true;
		textureId =aId;
	}
}