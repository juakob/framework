package com.gEngine.shaders;
import com.gEngine.painters.IPainter;

/**
 * ...
 * @author Joaquin
 */
class RenderPass
{
	public var renderAtEnd:Bool;
	public var filters:Array<IPainter>;
	public function new(aFilters:Array<IPainter>,aRenderAtEnd:Bool) 
	{
		filters = aFilters;
		renderAtEnd = aRenderAtEnd;
	}
	
}