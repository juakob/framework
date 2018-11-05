package com.gEngine.painters;
import com.gEngine.display.Blend;
import com.gEngine.display.BlendMode;
import com.gEngine.display.DrawMode;
import com.helpers.MinMax;
import kha.arrays.Float32Array;
import kha.graphics4.MipMapFilter;
import kha.graphics4.TextureFilter;
import kha.graphics4.VertexBuffer;

/**
 * ...
 * @author Joaquin
 */
class SpritePainter implements IPainter
{
	var currentPainter:IPainter;
	var drawMode:DrawMode = DrawMode.Default;
	var blend:BlendMode=BlendMode.Default;
	
	public var resolution:Float = 1;
	public var textureID:Int = 0;
	
	var painters:Array<Array<IPainter>>;
	var renderArea:MinMax;
	public var filter:TextureFilter = TextureFilter.LinearFilter;
	public var mipMapFilter:MipMapFilter = MipMapFilter.LinearMipFilter;
	public function new(aAutoDelete:Bool) 
	{
		var defaultBlend:Blend = Blend.blendDefault();
		var multipassBlend:Blend = Blend.blendMultipass();
		var AddBlend:Blend = Blend.blendAdd();
		
		var simplePainters:Array<IPainter> = [	
												new Painter(aAutoDelete, defaultBlend),
												new Painter(aAutoDelete, multipassBlend),
												new Painter(aAutoDelete, AddBlend)
											 ];
		
												
		var alphaPainters:Array<IPainter> = [	
												new PainterAlpha(aAutoDelete, defaultBlend), 
												new PainterAlpha(aAutoDelete, multipassBlend),
												new PainterAlpha(aAutoDelete, AddBlend)
											];
											
		var colorPainters:Array<IPainter> = [
												new PainterColorTransform(aAutoDelete, defaultBlend),
												new PainterColorTransform(aAutoDelete, multipassBlend),
												new PainterColorTransform(aAutoDelete, AddBlend)
											];
		var maskPainters:Array<IPainter> =  [
												new PainterMaskSimple(aAutoDelete, defaultBlend),
												new PainterMaskSimple(aAutoDelete, multipassBlend),
												new PainterMaskSimple(aAutoDelete, AddBlend)
											];
											
		var polyPainters:Array<IPainter> =  [
												new ShapePainter(aAutoDelete, defaultBlend),
												new ShapePainter(aAutoDelete, multipassBlend),
												new ShapePainter(aAutoDelete, AddBlend)
											];

		painters = [simplePainters,alphaPainters,colorPainters,maskPainters,polyPainters];
		
		currentPainter = painters[cast DrawMode.Default][cast BlendMode.Default];
	}

	
	/* INTERFACE com.gEngine.painters.IPainter */
	
	public function write(aValue:Float):Void 
	{
		currentPainter.write(aValue);
	}
	
	public function start():Void 
	{
		currentPainter.start();
	}
	
	public function finish():Void 
	{
		currentPainter.finish();
	}
	
	public function render(clear:Bool = false):Void 
	{
		currentPainter.filter = filter;
		currentPainter.mipMapFilter =  mipMapFilter;
		currentPainter.render(clear);
	}
	
	public function validateBatch(aTexture:Int, aSize:Int, aDrawMode:DrawMode,aBlend:BlendMode,aTextureFilter:TextureFilter,aMipMapFilter:MipMapFilter):Void 
	{
		if (drawMode!=aDrawMode||blend!=aBlend||filter!=aTextureFilter||mipMapFilter!=aMipMapFilter)
		{
			if (currentPainter.vertexCount() > 0)
			{
				if (renderArea != null)
				{
					currentPainter.filter = filter;
					currentPainter.mipMapFilter =  mipMapFilter;
					currentPainter.adjustRenderArea(renderArea);
					currentPainter.render();
					currentPainter.resetRenderArea();
				}else {
					currentPainter.render();
				}
				
			}
			drawMode = aDrawMode;
			blend = aBlend;
			
			currentPainter = painters[cast aDrawMode][cast aBlend];
			filter = aTextureFilter;
			currentPainter.filter = filter;
			mipMapFilter =  aMipMapFilter;
			currentPainter.mipMapFilter =  mipMapFilter;
			currentPainter.textureID = aTexture;
			
			
		}
		currentPainter.validateBatch(aTexture, aSize, aDrawMode, aBlend,aTextureFilter,aMipMapFilter);
		
		
	}
	
	/* INTERFACE com.gEngine.painters.IPainter */
	
	public function vertexCount():Int 
	{
		return currentPainter.vertexCount();
	}
	
	/* INTERFACE com.gEngine.painters.IPainter */
	
	public function releaseTexture():Bool 
	{
		return true;
	}
	
	
	public function adjustRenderArea(aArea:MinMax):Void 
	{
		renderArea = aArea;
		currentPainter.adjustRenderArea(aArea);
	}
	
	/* INTERFACE com.gEngine.painters.IPainter */
	
	public function resetRenderArea():Void 
	{
		renderArea = null;
		currentPainter.resetRenderArea();
	}
	
	/* INTERFACE com.gEngine.painters.IPainter */
	
	public function getVertexBuffer():Float32Array 
	{
		return currentPainter.getVertexBuffer();
	}
	
	public function getVertexDataCounter():Int 
	{
		return currentPainter.getVertexDataCounter();
	}
	
	public function setVertexDataCounter(aData:Int):Void 
	{
		currentPainter.setVertexDataCounter(aData);
	}
	
	
}