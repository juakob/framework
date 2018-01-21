package com.gEngine.display;
import com.gEngine.painters.IPainter;
import com.helpers.Matrix;
import com.gEngine.display.IDraw;
import com.helpers.MinMax;
import kha.math.FastMatrix3;

/**
 * ...
 * @author Joaquin
 */
class AreaEffect implements IDraw
{
	@:access(com.gEngine.GEngine.mPainter)
	public function new(aSnapShotShader:IPainter, aPrintShader:IPainter, aSwapBuffer:Bool = false ) 
	{
		if (aSnapShotShader == null)
		{
			snapShotShader = GEngine.i.mPainter;
		}else {
			snapShotShader = aSnapShotShader;	
		}
		if (aPrintShader == null&& !swapBuffer)
		{
			printShader = GEngine.i.mPainter;
		}else {
			printShader = aPrintShader;
		}
	}
	
	/* INTERFACE com.gEngine.display.IDraw */
	private var snapShotShader:IPainter;
	private var printShader:IPainter;
	private var swapBuffer:Bool;
	
	public var parent:IDrawContainer;
	
	public var visible:Bool = true;
	public var resolution:Float = 1;
	private var screenScaleX:Float = 1;
	private var screenScaleY:Float = 1;
	
	
	public function render(aPainter:IPainter, transform:Matrix):Void 
	{
		if (!visible)
		{
			return;
		}
	
		aPainter.render();
		aPainter = snapShotShader;	
		var lastTarger:Int = GEngine.i.currentCanvasId();
		
		var renderTarget:Int = GEngine.i.getRenderTarget();
		GEngine.i.setCanvas(renderTarget);
		
		aPainter.start();
//tempBuffer  =0
		GEngine.i.renderBuffer(GEngine.backBufferId, aPainter, x, y, width, height, 1280,720, true);

		aPainter.finish();
	
		if (!swapBuffer)
		{
			aPainter = printShader;

			GEngine.i.setCanvas(lastTarger);
			aPainter.start();

			GEngine.i.renderBuffer(renderTarget, aPainter, x, y, width, height, 1280,720, false);

			aPainter.finish();
		}else {
			GEngine.i.swapBuffer(renderTarget, lastTarger);
		}
		GEngine.i.releaseRenderTarget(renderTarget);

		
		
	}
	
	
	
	public function update(elapsedTime:Float):Void 
	{
		
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
	
	/* INTERFACE com.gEngine.display.IDraw */
	
	public function getDrawArea(aValue:MinMax):Void 
	{
		aValue.mergeRec(x, y, width, height);
	}
	
	public var x:Float=0;
	
	public var y:Float=0;
	public var width:Float=1280;
	public var height:Float=720;
	
}