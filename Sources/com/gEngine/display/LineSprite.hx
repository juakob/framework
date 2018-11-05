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
	public var overlap:Float = 4;
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
		
		spriteWidth = Math.abs(A.x - B.x)*0.5;
		if (spriteWidth == 0) throw A+","+B+","+C+","+D;
		spriteHeight = Math.abs(A.y - C.y)*0.5;
	}
	
	public function makePath(paths:Array<Point>):Array<Point> {
		v.splice(0, v.length);
		uv.splice(0, uv.length);
		while (offset < 0) offset += spriteWidth;
		offset = offset % spriteWidth;
		var intersectionPoints:Array<Point> = new Array();
		var vector1:Point = new Point();
		var vector2:Point = new Point();
		var interior:Point = new Point();
		var newPoints:Array<Point> = new Array();
		for (i in 0...paths.length) 
		{
			var lastIndex = (i - 1) % (paths.length);
			if (lastIndex < 0) lastIndex = paths.length - 1;
			var last:Point = paths[lastIndex ];
			var next:Point = paths[(i + 1) % (paths.length)];
			var current:Point = paths[i];
			
			vector1.setTo(last.x - current.x, last.y - current.y);
			vector1.normalize();
			vector2.setTo(next.x - current.x, next.y - current.y);
			vector2.normalize();
			
			interior.setTo((vector1.x + vector2.x) / 2, (vector1.y + vector2.y) / 2);
			interior.normalize();
			newPoints.push(new Point(current.x - interior.x * spriteHeight/2, current.y - interior.y * spriteHeight/2));
			interior.x *= spriteHeight/2;
			interior.y *= spriteHeight/2;
			interior.x += current.x;
			interior.y += current.y;
			intersectionPoints.push(interior.clone());
		}
		paths = newPoints;
		for (i in 0...paths.length) {
			var next:Point = paths[(i + 1) % (paths.length)];
			var current:Point = paths[i];
			var indexOffset:Int = v.length;
			offset = makeLine(current.clone(), next.clone());
			var intersection1 = intersectionPoints[i];
			var intersection2 = intersectionPoints[(i + 1) % (intersectionPoints.length)];
			v[indexOffset + 4] = intersection1.x;
			v[indexOffset + 5] = intersection1.y;
			//trace(intersection1);
			v[v.length - 2] = intersection2.x;
			v[v.length - 1] = intersection2.y;
		}
		return intersectionPoints;
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