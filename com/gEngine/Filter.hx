package com.gEngine;
import com.MyList;
import com.gEngine.display.IDraw;
import com.gEngine.display.Layer;
import com.gEngine.painters.IPainter;
import com.gEngine.painters.Painter;
import com.gEngine.shaders.RenderPass;
import com.gEngine.shaders.ShDontRender;
import com.gEngine.shaders.ShRender;
import com.helpers.Matrix;
import com.helpers.MinMax;
import kha.Color;
import kha.FastFloat;

/**
 * ...
 * @author Joaquin
 */
class Filter
{
	private var renderPass:Array<RenderPass>;
	var red:FastFloat = 0;
	var green:FastFloat = 0;
	var blue:FastFloat = 0;
	var alpha:FastFloat = 0;
	var cropScreen:Bool;
	var drawArea:MinMax;
	public function new(aFilters:Array<IPainter>,r:FastFloat=0,g:FastFloat=0,b:FastFloat=0,a:FastFloat=0,aCropScreen:Bool=true) 
	{
		red = r;
		green = g;
		blue = b;
		alpha = a;
		cropScreen = aCropScreen;
		renderPass = new Array();
		drawArea = new MinMax();
		if (!cropScreen)
		{
			drawArea.min.setTo(0, 0);
			drawArea.max.setTo(1280, 720);
		}
		var passFilters:Array<IPainter> = new Array();
		
		for (filter in aFilters) 
		{
			if (Std.is(filter, ShRender))
			{
				renderPass.push(new RenderPass(passFilters, true));
				passFilters = new Array();
				continue;
			}
			if (Std.is(filter, ShDontRender))
			{
				renderPass.push(new RenderPass(passFilters, false));
				passFilters = new Array();
				continue;
			}
			passFilters.push(filter);
		}
		if (passFilters.length != 0)
		{
			renderPass.push(new RenderPass(passFilters, true));
		}
		
		for (renderPass in renderPass) 
		{
			var length:Int = renderPass.filters.length;
			if (renderPass.renderAtEnd)
			{
				length -= 1;
			}
			for (i in 0...length) 
			{
			//	aFilters[i].multipassBlend();
			}
		}
	}
	
	public function render(aLayer:Layer,aDisplay:MyList<IDraw>,aPainter:IPainter,aMatrix:Matrix):Void
	{
		if (renderPass.length == 0)
		{
			return;
		}
		aPainter.render();
		aPainter.finish();
		
		var finishTarget:Int = GEngine.i.currentCanvasId();
		var workTargetId:Int = GEngine.i.getRenderTarget();
		
		GEngine.i.setCanvas(workTargetId);
		GEngine.i.currentCanvas().g2.scissor(0, 0, GEngine.i.width, GEngine.i.height);
		GEngine.i.currentCanvas().g2.begin(true,Color.fromFloats(red,green,blue,alpha));
		GEngine.i.currentCanvas().g2.end();
		GEngine.i.currentCanvas().g2.disableScissor();
		
		if (cropScreen)
		{
		drawArea.reset();
		}
		//aPainter.multipassBlend();
		for (display in aDisplay) 
		{
			display.render(aPainter, aMatrix);
		}
		aLayer.getDrawArea(drawArea);
		
		//drawArea.transform(aMatrix);	
		aPainter.render();
		aPainter.finish();
		//aPainter.defaultBlend();
		
	
		var counter:Int = renderPass.length;
		for (renderPass in renderPass) 
		{
			--counter;
			var filters:Array<IPainter> = renderPass.filters;
			var resolution:Float = 1;
			var length:Int;
			if (renderPass.renderAtEnd)
			{
				length = filters.length - 1;//dont iterate over the last one
			}else {
				length= filters.length ;
			}
			for (i in 0...length) 
			{
				var sourceImg = workTargetId;
				workTargetId = GEngine.i.getRenderTarget();
				
				GEngine.i.setCanvas(workTargetId);
				var filter:IPainter = filters[i];
				filter.adjustRenderArea(drawArea);
				GEngine.i.renderBuffer(sourceImg, filter, drawArea.min.x * resolution, drawArea.min.y * resolution, drawArea.width() * resolution, drawArea.height() * resolution, 1280, 720, true, filter.resolution);
				resolution *= filter.resolution;
				if (filter.releaseTexture()) GEngine.i.releaseRenderTarget(sourceImg);
			}
			if (renderPass.renderAtEnd)
			{
				GEngine.i.setCanvas(finishTarget);
				var filter:IPainter = filters[filters.length - 1];
				filter.adjustRenderArea(drawArea);
				GEngine.i.renderBuffer(workTargetId, filter,drawArea.min.x, drawArea.min.y,drawArea.width(), drawArea.height(), 1280/resolution, 720/resolution, false);
				if (filter.releaseTexture()&&counter==0) GEngine.i.releaseRenderTarget(workTargetId);
			}
		}
	}
}