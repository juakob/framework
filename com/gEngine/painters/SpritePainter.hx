package com.gEngine.painters;
import com.gEngine.display.Blend;
import com.gEngine.display.BlendMode;
import com.gEngine.display.DrawMode;
import com.helpers.MinMax;

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

		painters = [simplePainters,alphaPainters,colorPainters,maskPainters];
		
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
		currentPainter.render(clear);
	}
	
	public function validateBatch(aTexture:Int, aSize:Int, aDrawMode:DrawMode,aBlend:BlendMode):Void 
	{
		if (drawMode!=aDrawMode||blend!=aBlend)
		{
			
			if (currentPainter.vertexCount() > 0)
			{
			currentPainter.render();
			
			}
			drawMode = aDrawMode;
			blend = aBlend;
			currentPainter = painters[cast aDrawMode][cast aBlend];
			currentPainter.textureID = aTexture;
			
		}
		currentPainter.validateBatch(aTexture, aSize, aDrawMode, aBlend);
		
		
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
		
	}
	
}