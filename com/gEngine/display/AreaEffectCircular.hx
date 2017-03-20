package com.gEngine.display;
import com.gEngine.painters.IPainter;
import com.helpers.Matrix;
import com.gEngine.display.IDraw;
import com.helpers.MinMax;
import com.helpers.Point;
import kha.math.FastMatrix3;
import kha.math.FastVector2;

/**
 * ...
 * @author Joaquin
 */
class AreaEffectCircular extends AreaEffect
{
	@:access(com.gEngine.GEngine.mPainter)
	public function new(aSnapShotShader:IPainter,aPrintShader:IPainter) 
	{
		super(aSnapShotShader, aPrintShader);
	}

	private override function createDrawInitialRectangle(aPainter:IPainter):Void
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
	private override function createDrawFinishRectangle(aPainter:IPainter):Void
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
	override public function getDrawArea(aValue:MinMax):Void 
	{
		aValue.mergeRec(x-width/2, y-height/2, width, height);
	}
	
	public var radio:Float=100;
	public var stroke:Float=50;
	public var numSegments:Int = 20;
	public var zoom:Float = .85;
	
	
}