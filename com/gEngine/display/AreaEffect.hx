package com.gEngine.display;
import com.gEngine.painters.IPainter;
import com.helpers.Matrix;
import com.gEngine.display.IDraw;
import kha.math.FastMatrix3;

/**
 * ...
 * @author Joaquin
 */
class AreaEffect implements IDraw
{
	@:access(com.gEngine.GEngine.mPainter)
	public function new(aSnapShotShader:IPainter,aPrintShader:IPainter) 
	{
		screenScaleX = 1/GEngine.i.scaleWidth;
		screenScaleY = 1/GEngine.i.scaleHeigth;
		if (aSnapShotShader == null)
		{
			snapShotShader = GEngine.i.mPainter;
		}else {
			snapShotShader = aSnapShotShader;	
		}
		if (aPrintShader == null)
		{
			printShader = GEngine.i.mPainter;
		}else {
			printShader = aPrintShader;
		}
	}
	
	/* INTERFACE com.gEngine.display.IDraw */
	private var snapShotShader:IPainter;
	private var printShader:IPainter;
	
	public var parent:IDrawContainer;
	
	public var visible:Bool = true;
	public var resolution:Float = 1;
	private var screenScaleX:Float = 1;
	private var screenScaleY:Float=1;
	
	public function render(aPainter:IPainter, transform:Matrix):Void 
	{
		if (!visible)
		{
			return;
		}
	
		aPainter.render();
		aPainter = snapShotShader;	
		var lastTarger:Int = GEngine.i.currentCanvasId();
		aPainter.textureID = 0;//tempBuffer
		var renderTarger:Int = GEngine.i.getRenderTarget();
		GEngine.i.setCanvas(renderTarger);
		//GEngine.i.changeToTemp();
		//GEngine.i.manualUnMirror = true;
		
		aPainter.start();
		createDrawInitialRectangle(aPainter);

		aPainter.render(true);
		aPainter.finish();
		//GEngine.i.temp = true;
		//GEngine.i.manualUnMirror = false;
		//GEngine.i.manualUnMirror = true;
		aPainter = printShader;
		aPainter.textureID = renderTarger;//tempBuffer
		GEngine.i.setCanvas(lastTarger);
		aPainter.start();
		//createFullRectangle(aPainter);
		createDrawFinishRectangle(aPainter);
		//createDrawInverseRectangle(aPainter);
		//GEngine.i.manualMirror = true;
		aPainter.render();
		aPainter.finish();
		GEngine.i.releaseRenderTarget(renderTarger);
		GEngine.i.temp = false;
		
		
	}
	
	function createFullRectangle(aPainter:IPainter) 
	{
		aPainter.write(0);
		aPainter.write(0);
		aPainter.write(0);
		aPainter.write(0);
		
		aPainter.write(1280);
		aPainter.write(0);
		aPainter.write(1);
		aPainter.write(0);
		
		aPainter.write(0);
		aPainter.write(720);
		aPainter.write(0);
		aPainter.write(1);
		
		aPainter.write(1280);
		aPainter.write(720);
		aPainter.write(1);
		aPainter.write(1);
	}
	
	private inline function createDrawInitialRectangle(aPainter):Void
	{
		var screenWidth = GEngine.i.realWidth *screenScaleX;
		var screenHeight = GEngine.i.realHeight*screenScaleY;
		aPainter.write(x);
		aPainter.write(y);
		aPainter.write(x/screenWidth);
		aPainter.write(y/screenHeight);
		
		aPainter.write((x+width*resolution));
		aPainter.write(y);
		aPainter.write(((x+width))/screenWidth);
		aPainter.write(y/screenHeight);
		
		aPainter.write(x);
		aPainter.write(y+height*resolution);
		aPainter.write(x/screenWidth);
		aPainter.write((y+height)/screenHeight);
		
		aPainter.write((x+width*resolution));
		aPainter.write(y+height*resolution);
		aPainter.write(((x+width))/screenWidth);
		aPainter.write((y+height)/screenHeight);
	}
	private inline function createDrawFinishRectangle(aPainter):Void
	{
		var screenWidth = GEngine.i.realWidth *screenScaleX;
		var screenHeight = GEngine.i.realHeight*screenScaleY;
		aPainter.write(x);
		aPainter.write(y);
		aPainter.write(x/screenWidth);
		aPainter.write(y/screenHeight);
		
		aPainter.write((x+width));
		aPainter.write(y);
		aPainter.write(((x+width*resolution))/screenWidth);
		aPainter.write(y/screenHeight);
		
		aPainter.write(x);
		aPainter.write(y+height);
		aPainter.write(x/screenWidth);
		aPainter.write((y+height*resolution)/screenHeight);
		
		aPainter.write((x+width));
		aPainter.write(y+height);
		aPainter.write(((x+width*resolution))/screenWidth);
		aPainter.write((y+height*resolution)/screenHeight);
	}
	
	public function update(elapsedTime:Float):Void 
	{
		
	}
	
	public function blend():Int 
	{
		return 0;
	}
	
	public function texture():Int 
	{
		return -666;
	}

	public function removeFromParent():Void 
	{
		parent.remove(this);
		parent = null;
	}
	
	/* INTERFACE com.gEngine.display.IDraw */
	
	public var scaleX:Float;
	
	public var scaleY:Float;
	
	public function getTransformation(aMatrix:FastMatrix3 = null):FastMatrix3 
	{
		throw "not implemented copy code from basicsprite";
	}
	
	public var x:Float=0;
	
	public var y:Float=0;
	public var width:Float=1280;
	public var height:Float=720;
	
}