package com.gEngine.display;
import com.gEngine.AnimationData;
import com.helpers.Point;
import kha.FastFloat;

/**
 * ...
 * @author Joaquin
 */
class LineSprite{
	var A:Point;
	var B:Point;
	var C:Point;
	var D:Point;
	
	var uvA:Point;
	var uvB:Point;
	var uvC:Point;
	var uvD:Point;
	
	var v:MyList<FastFloat>;
	var uv:MyList<FastFloat>;
	
	var spriteWidth:Float;
	var spriteHeight:Float;
	public var overlap:Float = 3;
	public var offset:Float = 20;
	
	public var display:BasicSprite;
	inline public function new(display:BasicSprite) {
		this.display = display;
		this.display.stop();
		init();
	}
	function init():Void
	{
		var data:AnimationData = display.animationData();
		v = data.frames[0].vertexs;
		uv = data.frames[0].UVs;
		A = new Point(v[0], v[1]);
		B = new Point(v[4], v[5]);
		C = new Point(v[2], v[3]);
		D = new Point(v[6], v[7]);
		
		uvA = new Point(uv[0], uv[1]);
		uvB = new Point(uv[4], uv[5]);
		uvC = new Point(uv[2], uv[3]);
		uvD = new Point(uv[6], uv[7]);
		
		spriteWidth = Math.abs(A.x - B.x);
		if (spriteWidth == 0) throw A+","+B+","+C+","+D;
		spriteHeight = Math.abs(A.y - C.y);
	}
	
	public function makePath(paths:Array<Point>) {
		v.splice(0, v.length);
		uv.splice(0, uv.length);
		while (offset < 0) offset += spriteWidth;
		offset = offset % spriteWidth;
		var amountOfPaths:Int = Math.floor(paths.length / 2);
		for (i in 0...amountOfPaths) {
			offset=makeLine(paths[i * 2], paths[i * 2 + 1]);
		}
	}
	 function makeLine(aStart:Point,aEnd:Point):Float {
		
		var totalLength = Point.Length(aStart, aEnd)+offset;
		
		var originalStart = aStart.clone();
		aStart.setTo(aStart.x - aEnd.x, aStart.y - aEnd.y);
		aStart.normalize();
		aStart.x = aStart.x * totalLength + aEnd.x;
		aStart.y = aStart.y * totalLength + aEnd.y;
		var offsetStart = aStart.clone();
		
		var iterations:Int = Math.ceil(totalLength / spriteWidth);
		var trueEnd:Point = aEnd.clone();
		aEnd.setTo(aEnd.x - aStart.x, aEnd.y - aStart.y);
		aEnd.normalize();
		aEnd.x = aEnd.x * (iterations * spriteWidth) + aStart.x;
		aEnd.y = aEnd.y * (iterations * spriteWidth) + aStart.y;
		var perpendicular = new Point( -(aEnd.y - aStart.y), aEnd.x - aStart.x);
		perpendicular.normalize();
		perpendicular.x *= spriteHeight;
		perpendicular.y *= spriteHeight;
		var normalOverlap = overlap / (iterations * spriteWidth);
		
		
		for (i in 0...iterations) 
		{
			var s = (i / iterations) -normalOverlap;
			var s2 = ((i + 1) / iterations) ;
			if (i == 0) {
				if(i==(iterations-1)){
					v.push(originalStart.x);	v.push(originalStart.y);
					v.push(Point.Lerp(aStart.x, trueEnd.x, s2));	v.push(Point.Lerp(aStart.y, trueEnd.y, s2));
					v.push(originalStart.x+perpendicular.x);	v.push(originalStart.y+perpendicular.y);
					v.push(Point.Lerp(aStart.x+perpendicular.x, trueEnd.x+perpendicular.x, s2));	v.push(Point.Lerp(aStart.y+perpendicular.y, trueEnd.y+perpendicular.y, s2));
					s = (totalLength / spriteWidth) - (iterations-1);
					s2 = (offset / spriteWidth);
					uv.push(Point.Lerp(uvA.x, uvB.x, s2));	uv.push(Point.Lerp(uvA.y, uvB.y, s2));
					uv.push(Point.Lerp(uvA.x, uvB.x, s)); uv.push(Point.Lerp(uvA.y, uvB.y, s));
					uv.push(Point.Lerp(uvC.x, uvD.x, s2));	uv.push(Point.Lerp(uvC.y, uvD.y, s2));
					uv.push(Point.Lerp(uvC.x, uvD.x, s)); uv.push(Point.Lerp(uvC.y, uvD.y, s));
					
				}else {
					v.push(originalStart.x);	v.push(originalStart.y);
					v.push(Point.Lerp(aStart.x, aEnd.x, s2));	v.push(Point.Lerp(aStart.y, aEnd.y, s2));
					v.push(originalStart.x+perpendicular.x);	v.push(originalStart.y+perpendicular.y);
					v.push(Point.Lerp(aStart.x+perpendicular.x, aEnd.x+perpendicular.x, s2));	v.push(Point.Lerp(aStart.y+perpendicular.y, aEnd.y+perpendicular.y, s2));
					s2 = (offset / spriteWidth);
					uv.push(Point.Lerp(uvA.x, uvB.x, s2));	uv.push(Point.Lerp(uvA.y, uvB.y, s2));
					uv.push(uvB.x);	uv.push(uvB.y);
					uv.push(Point.Lerp(uvC.x, uvD.x, s2));	uv.push(Point.Lerp(uvC.y, uvD.y, s2));
					uv.push(uvD.x);	uv.push(uvD.y);
				}
				
				
			}else
			if(i==(iterations-1)){
				v.push(Point.Lerp(aStart.x, aEnd.x, s));	v.push(Point.Lerp(aStart.y, aEnd.y, s));
				v.push(Point.Lerp(aStart.x, trueEnd.x, s2));	v.push(Point.Lerp(aStart.y, trueEnd.y, s2));
				v.push(Point.Lerp(aStart.x+perpendicular.x, aEnd.x+perpendicular.x, s));	v.push(Point.Lerp(aStart.y+perpendicular.y, aEnd.y+perpendicular.y, s));
				v.push(Point.Lerp(aStart.x+perpendicular.x, trueEnd.x+perpendicular.x, s2));	v.push(Point.Lerp(aStart.y+perpendicular.y, trueEnd.y+perpendicular.y, s2));
				
				s = (totalLength / spriteWidth) - (iterations-1);
			
				uv.push(uvA.x);	uv.push(uvA.y);
				uv.push(Point.Lerp(uvA.x, uvB.x, s)); uv.push(Point.Lerp(uvA.y, uvB.y, s));
				uv.push(uvC.x);	uv.push(uvC.y);
				uv.push(Point.Lerp(uvC.x, uvD.x, s)); uv.push(Point.Lerp(uvC.y, uvD.y, s));
				return s * spriteWidth;
			}else{
				v.push(Point.Lerp(aStart.x, aEnd.x, s));	v.push(Point.Lerp(aStart.y, aEnd.y, s));
				v.push(Point.Lerp(aStart.x, aEnd.x, s2));	v.push(Point.Lerp(aStart.y, aEnd.y, s2));
				v.push(Point.Lerp(aStart.x+perpendicular.x, aEnd.x+perpendicular.x, s));	v.push(Point.Lerp(aStart.y+perpendicular.y, aEnd.y+perpendicular.y, s));
				v.push(Point.Lerp(aStart.x+perpendicular.x, aEnd.x+perpendicular.x, s2));	v.push(Point.Lerp(aStart.y+perpendicular.y, aEnd.y+perpendicular.y, s2));
				
				uv.push(uvA.x);	uv.push(uvA.y);
				uv.push(uvB.x);	uv.push(uvB.y);
				uv.push(uvC.x);	uv.push(uvC.y);
				uv.push(uvD.x);	uv.push(uvD.y);
			}
		}	
		return 0;
	}
}