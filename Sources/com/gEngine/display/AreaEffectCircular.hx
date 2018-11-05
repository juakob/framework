package com.gEngine.display;
import com.gEngine.display.IDrawContainer;
import com.gEngine.painters.IPainter;
import com.helpers.Matrix;
import com.gEngine.display.IDraw;
import com.helpers.MinMax;
import com.helpers.FastPoint;
import kha.math.FastMatrix3;
import kha.math.FastVector2;

/**
 * ...
 * @author Joaquin
 */
class AreaEffectCircular implements IDraw
{
	private var snapShotShader:IPainter;
	private var printShader:IPainter;
	
	@:access(com.gEngine.GEngine.mPainter)
	public function new(aSnapShotShader:IPainter,aPrintShader:IPainter) 
	{
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
	private  function createDrawFinishRectangle(aPainter:IPainter):Void
	{
		var screenWidth = GEngine.i.realWidth ;
		var screenHeight = GEngine.i.realHeight ;
		var faceWidth:Float = width / 10;
		var faceHeigth:Float = height / 10;
		
		
		var leftDirection:FastVector2=new FastVector2();
		var rigthDirection:FastVector2=new  FastVector2();
		var increments = Math.PI*2 / numSegments;
		var currentAngle:Float = 0;
		var outsideRadio:Float = radio + stroke / 2;
		var insideRadio:Float = radio;
		var centerX:Float = x;
		var centerY:Float = y;
		
		for (i in 0...numSegments)
		{
			leftDirection.x = Math.sin(currentAngle);
			leftDirection.y = Math.cos(currentAngle);
			currentAngle+= increments;
			rigthDirection.x = Math.sin(currentAngle);
			rigthDirection.y = Math.cos(currentAngle);
			
			aPainter.write(centerX+leftDirection.x * outsideRadio);
			aPainter.write(centerY+leftDirection.y * outsideRadio);
			aPainter.write((centerX+leftDirection.x * outsideRadio*zoom)/screenWidth);
			aPainter.write((centerY+leftDirection.y * outsideRadio*zoom)/screenHeight);
			
			aPainter.write(centerX+rigthDirection.x * outsideRadio);
			aPainter.write(centerY+rigthDirection.y * outsideRadio);
			aPainter.write((centerX+rigthDirection.x * outsideRadio*zoom)/screenWidth);
			aPainter.write((centerY+rigthDirection.y * outsideRadio*zoom)/screenHeight);
			
			aPainter.write(centerX+leftDirection.x * insideRadio);
			aPainter.write(centerY+leftDirection.y * insideRadio);
			aPainter.write((centerX+leftDirection.x * insideRadio)/screenWidth);
			aPainter.write((centerY+leftDirection.y * insideRadio)/screenHeight);
			
			aPainter.write(centerX+rigthDirection.x * insideRadio);
			aPainter.write(centerY+rigthDirection.y * insideRadio);
			aPainter.write((centerX+rigthDirection.x * insideRadio)/screenWidth);
			aPainter.write((centerY + rigthDirection.y * insideRadio) / screenHeight);
			
			///
			insideRadio = outsideRadio;
			outsideRadio = radio+stroke;
			aPainter.write(centerX+leftDirection.x * outsideRadio);
			aPainter.write(centerY+leftDirection.y * outsideRadio);
			aPainter.write((centerX+leftDirection.x * outsideRadio)/screenWidth);
			aPainter.write((centerY+leftDirection.y * outsideRadio)/screenHeight);
			
			aPainter.write(centerX+rigthDirection.x * outsideRadio);
			aPainter.write(centerY+rigthDirection.y * outsideRadio);
			aPainter.write((centerX+rigthDirection.x * outsideRadio)/screenWidth);
			aPainter.write((centerY+rigthDirection.y * outsideRadio)/screenHeight);
			
			aPainter.write(centerX+leftDirection.x * insideRadio);
			aPainter.write(centerY+leftDirection.y * insideRadio);
			aPainter.write((centerX+leftDirection.x * insideRadio*zoom)/screenWidth);
			aPainter.write((centerY+leftDirection.y * insideRadio*zoom)/screenHeight);
			
			aPainter.write(centerX+rigthDirection.x * insideRadio);
			aPainter.write(centerY+rigthDirection.y * insideRadio);
			aPainter.write((centerX+rigthDirection.x * insideRadio*zoom)/screenWidth);
			aPainter.write((centerY + rigthDirection.y * insideRadio * zoom) / screenHeight);
			
			outsideRadio = insideRadio;
			insideRadio = radio;
			
		}
		
	}
	 public function getDrawArea(aValue:MinMax):Void 
	{
		aValue.mergeRec(x-width/2, y-height/2, width, height);
	}
	
	/* INTERFACE com.gEngine.display.IDraw */
	
	public var parent:IDrawContainer;
	
	public var visible:Bool;
	
	public function render(batch:IPainter, transform:Matrix):Void 
	{
		if (!visible)
		{
			return;
		}
		batch.render();
		
		var finalTarget:Int = GEngine.i.currentCanvasId();
		var tempTexture:Int = GEngine.i.getRenderTarget();
		GEngine.i.setCanvas(tempTexture);
		var zoomTemp:Float = zoom;
		var strokeTemp:Float = stroke;
		var radioTemp:Float = radio;
		snapShotShader.textureID = GEngine.backBufferId;
		zoom = 1;
		stroke+= 1;
		radio -= 1;
		createDrawFinishRectangle(snapShotShader);
		zoom = zoomTemp;
		stroke = strokeTemp;
		radio = radioTemp;
		snapShotShader.render(true);
		
		GEngine.i.setCanvas(finalTarget);
		printShader.textureID = tempTexture;
		createDrawFinishRectangle(printShader);
		printShader.render();
		
		GEngine.i.releaseRenderTarget(tempTexture);
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
	
	public var x:Float;
	
	public var y:Float;
	
	public var scaleX:Float;
	
	public var scaleY:Float;
	
	public function getTransformation(aMatrix:FastMatrix3 = null):FastMatrix3 
	{
		throw "not implemented copy code from basicsprite";
	}
	
	public var radio:Float=100;
	public var stroke:Float=50;
	public var numSegments:Int = 20;
	public var zoom:Float = .85;
	public var width:Float = 1;
	public var height:Float = 1;
	public var resolution:Float = 1;
	
}