package com.gEngine.display;
import com.gEngine.painters.IPainter;
import com.helpers.Matrix;
import com.gEngine.display.IDraw;
import com.helpers.Point;
import kha.math.FastMatrix3;
import kha.math.FastVector2;

/**
 * ...
 * @author Joaquin
 */
class AreaEffectCircular implements IDraw
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
		width = height = (radio + stroke) * 2;
		aPainter.render();
		aPainter = snapShotShader;	
		aPainter.textureID = 0;//tempBuffer
		GEngine.i.changeToTemp();
		//GEngine.i.manualUnMirror = true;
		
		aPainter.start();
		createDrawInitialRectangle(aPainter);

		aPainter.render(true);
		aPainter.finish();
		//GEngine.i.temp = true;
		//GEngine.i.manualUnMirror = false;
		//GEngine.i.manualUnMirror = true;
		aPainter = printShader;
		aPainter.textureID = 1;//tempBuffer
		GEngine.i.changeToBuffer();
		aPainter.start();
		//createFullRectangle(aPainter);
		createDrawFinishRectangle(aPainter);
		//createDrawInverseRectangle(aPainter);
		//GEngine.i.manualMirror = true;
		aPainter.render();
		aPainter.finish();
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
	
	private inline function createDrawInitialRectangle(aPainter:IPainter):Void
	{
		var screenWidth = GEngine.i.realWidth *screenScaleX;
		var screenHeight = GEngine.i.realHeight * screenScaleY;
		x -= width / 2;
		y -= height / 2;
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
		aPainter.write((y + height) / screenHeight);
		x += width / 2;
		y += height / 2;
	}
	private  function createDrawFinishRectangle(aPainter:IPainter):Void
	{
		var screenWidth = GEngine.i.realWidth *screenScaleX;
		var screenHeight = GEngine.i.realHeight * screenScaleY;
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
	public var width:Float=0;
	public var height:Float=0;
	public var radio:Float=100;
	public var stroke:Float=50;
	public var numSegments:Int = 20;
	public var zoom:Float = .85;
	
	
}