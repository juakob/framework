package com.gEngine.painters;
import com.helpers.MinMax;

/**
 * ...
 * @author Joaquin
 */
class SpritePainter implements IPainter
{

	var simplePainer:Painter;
	var alphaPainter:PainterAlpha;
	var colorPainter:PainterColorTransform;
	var maskPainter:PainterMaskSimple;
	var currentPainter:IPainter;
	var usingAlpha:Bool;
	var usingColor:Bool;
	var usingMask:Bool;
	public var resolution:Float = 1;
	public var textureID:Int = 0;
	
	public function new(aAutoDelete:Bool) 
	{
		currentPainter =simplePainer = new Painter(aAutoDelete);
		alphaPainter = new PainterAlpha(aAutoDelete);
		colorPainter = new PainterColorTransform(aAutoDelete);
		maskPainter = new PainterMaskSimple(aAutoDelete);
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
	
	public function validateBatch(aTexture:Int, aSize:Int, aAlpha:Bool, aColorTransform:Bool,aMask:Bool):Void 
	{
		
		if (usingAlpha != aAlpha||usingColor!=aColorTransform||usingMask!=aMask)
		{
			
			if (currentPainter.vertexCount() > 0)
			{
			currentPainter.render();
			
			}
			usingAlpha = aAlpha;
			usingColor = aColorTransform;
			usingMask = aMask;
			if (aColorTransform)
			{
				currentPainter = colorPainter;
				colorPainter.textureID = aTexture;
			}else
			if (aAlpha)
			{
				currentPainter = alphaPainter;
				alphaPainter.textureID = aTexture;
			}else
			if (usingMask)
			{
				currentPainter = maskPainter;
				alphaPainter.textureID = aTexture;
			}
			else {
				currentPainter = simplePainer;
				simplePainer.textureID = aTexture;
			}
		}
		currentPainter.validateBatch(aTexture, aSize, aAlpha, aColorTransform,aMask);
		
		
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
	
	/* INTERFACE com.gEngine.painters.IPainter */
	
	public function adjustRenderArea(aArea:MinMax):Void 
	{
		
	}
	
}