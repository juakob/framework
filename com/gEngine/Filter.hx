package com.gEngine;
import com.MyList;
import com.gEngine.display.IDraw;
import com.gEngine.painters.IPainter;
import com.gEngine.painters.Painter;
import com.helpers.Matrix;

/**
 * ...
 * @author Joaquin
 */
class Filter
{
	private var filters:Array<IPainter>;
	public function new(aFilters:Array<IPainter>) 
	{
		filters = aFilters;
	}
	
	public function render(aDisplay:MyList<IDraw>,aPainter:IPainter,aMatrix:Matrix):Void
	{
		if (filters.length == 0)
		{
			return;
		}
		aPainter.render();
		aPainter.finish();
		
		var finishTarget:Int = GEngine.i.currentCanvasId();
		var workTargetId:Int = GEngine.i.getRenderTarget();
		
		GEngine.i.setCanvas(workTargetId);
		GEngine.i.currentCanvas().g2.begin(true,0);
		GEngine.i.currentCanvas().g2.end();
		for (display in aDisplay) 
		{
			display.render(aPainter, aMatrix);
		}
		aPainter.render();
		aPainter.finish();
		for (i in 0...(filters.length-1)) //dont iterate over the last one
		{
			var sourceImg = workTargetId;
			workTargetId = GEngine.i.getRenderTarget();
			
			GEngine.i.setCanvas(workTargetId);
			var filter:IPainter = filters[i];
			GEngine.i.renderBuffer(sourceImg, filter, 0, 0, 0, 0, 1280, 720, true);
			if (filter.releaseTexture()) GEngine.i.releaseRenderTarget(sourceImg);
		}
		GEngine.i.setCanvas(finishTarget);
		var filter:IPainter = filters[filters.length - 1];
		GEngine.i.renderBuffer(workTargetId, filter, 0, 0, 0, 0, 1280, 720, false);
		if (filter.releaseTexture())GEngine.i.releaseRenderTarget(workTargetId);
	}
}