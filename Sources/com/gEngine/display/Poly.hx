package com.gEngine.display;
import com.gEngine.display.BlendMode;
import com.gEngine.display.DrawMode;
import com.helpers.Point;
import hxGeomAlgo.Tess2;
import kha.math.FastMatrix3;
import com.helpers.MinMax;
import kha.FastFloat;
import com.helpers.Matrix;
import com.gEngine.painters.IPainter;
import kha.math.FastVector2;

import com.gEngine.display.IDraw;
import com.gEngine.display.IDrawContainer;

/**
 * ...
 * @author Joaquin
 */
class Poly implements IDraw
{
	var mVertexs:Array<Point>;
	var mBorder:Array<Point>;
	public var color:Int;
	public var borderColor:Int;
	public var borderWidth:Float=1;
	public var blend:BlendMode = BlendMode.Default;
	
	public var x:FastFloat=0;
	
	public var y:FastFloat=0;
	
	public var scaleX:FastFloat=1;
	
	public var scaleY:FastFloat=1;
	
	public var pivotX:FastFloat=0;
	public var pivotY:FastFloat = 0;
	
	public var offsetX:FastFloat=0;
	public var offsetY:FastFloat = 0;
	
	private var tanSkewX:FastFloat = 0;
	private var tanSkewY:FastFloat = 0;
	
	private var minMax:MinMax;
	
	public function new() 
	{
		minMax = new MinMax();
	}
	
	/* INTERFACE com.gEngine.display.IDraw */
	
	public var parent:IDrawContainer;
	
	public var visible:Bool;
	
	public function render(batch:IPainter, transform:Matrix):Void 
	{
		batch.validateBatch( -1, mVertexs.length, DrawMode.Poly, blend);
		
		x += offsetX+pivotX;
		y += offsetY+pivotY;
		
		
		var _1t = scaleX * cosAng-sinAng*tanSkewY*scaleX;
		var _2t = scaleX * sinAng+cosAng*tanSkewY*scaleX;
		var _3t = -scaleY * sinAng+cosAng*tanSkewX*scaleY;
		var _4t = scaleY * cosAng+sinAng*tanSkewX*scaleY;
		 
		var _1 = _1t*transform.a  +_2t*transform.c;//new a
		var _2 = _1t*transform.b+_2t*transform.d;//new b
		var _3 = _3t * transform.a +_4t *transform.c;//new c
		var _4 = _3t * transform.b + transform.d * _4t;//new d
	
		var _tx = x* transform.a+ y *transform.c + transform.tx;
		var _ty = x * transform.b + y * transform.d +transform.ty;
		
		

		var red:Float = ((color >> 16) & 0xFF)/255;

		var green:Float = ((color >> 8) & 0xFF)/255;

		var blue:Float = (color & 0xFF)/255;


		
		for (vertex in mVertexs) {
			
			batch.write( _tx + vertex.x * _1 + vertex.y * _3);
			batch.write( _ty + vertex.x * _2 + vertex.y * _4);
			batch.write(0);
			batch.write(red);
			batch.write(green);
			batch.write(blue);
		}
		//red = ((borderColor >> 16) & 0xFF)/255;
//
		//green = ((borderColor >> 8) & 0xFF)/255;
//
		//blue = (borderColor & 0xFF)/255;
		//for (vertex in mBorder) {
			//
			//batch.write( _tx + vertex.x * _1 + vertex.y * _3);
			//batch.write( _ty + vertex.x * _2 + vertex.y * _4);
			//batch.write(0);
			//batch.write(red);
			//batch.write(green);
			//batch.write(blue);
		//}
		
		x -= offsetX+pivotX;
		y -= offsetY+pivotY;
	}
	
	public var rotation(default, set):Float;
	
	private var cosAng:FastFloat=1;
	private var sinAng:FastFloat = 0;
	
	public function set_rotation(aValue:Float):FastFloat
	{
		if (aValue != rotation)
		{
			rotation = aValue;
			sinAng = Math.sin(aValue);
			cosAng = Math.cos(aValue);
		}
		return rotation;
	}
	
	public function update(elapsedTime:Float):Void 
	{
		
	}
	
	public function texture():Int 
	{
		return -1;
	}
	
	public function removeFromParent():Void 
	{
		if (parent != null) parent.remove(this);
	}
	
	public function setVertexs(aVertexs:Array<Point>):Void {
		minMax.reset();
		for (vertex in aVertexs) 
		{
			minMax.mergeVec(new FastVector2(vertex.x, vertex.y));
		}
		var array:Array<Float> = new Array();
		for (vertex in aVertexs) 
		{
			array.push(vertex.x);
			array.push(vertex.y);
		}
		var res = Tess2.tesselate([array], null, ResultType.POLYGONS, 3);
		var triangles = Tess2.convertResult(res.vertices, res.elements, ResultType.POLYGONS, 3);
		var display = new Poly();
		var points = new Array<Point>();
		for(tri in triangles){
			for (point in tri) {
				points.push(new Point(point.x, point.y));	
			}
		}
		mVertexs = points;
		
		
		//mBorder = new Array();
		//var vector1:Point = new Point();
		//var vector2:Point = new Point();
		//var interior:Point = new Point();
		//for (i in 0...aVertexs.length) 
		//{
			//var lastIndex = (i - 1) % (aVertexs.length);
			//if (lastIndex < 0) lastIndex = aVertexs.length - 1;
			//var last:Point = aVertexs[lastIndex ];
			//var next:Point = aVertexs[(i + 1) % (aVertexs.length)];
			//var current:Point = aVertexs[i];
			//vector1.setTo(last.x - current.x, last.y - current.y);
			//vector1.normalize();
			//vector2.setTo(next.x - current.x, next.y - current.y);
			//vector2.normalize();
			//
			//interior.setTo((vector1.x + vector2.x) / 2, (vector1.y + vector2.y) / 2);
			//interior.normalize();
			//interior.x *= borderWidth;
			//interior.y *= borderWidth;
			//interior.x += current.x;
			//interior.y += current.y;
			//
			//mBorder.push(interior.clone());
			//
			//mBorder.push(interior.clone());
			//mBorder.push(current.clone());
			//mBorder.push(next.clone());
			//
			//mBorder.push(interior.clone());
			//mBorder.push(next.clone());
		//}
		//mBorder.push(mBorder.shift());
		
	}
	
	
	public function getDrawArea(aValue:MinMax):Void 
	{
		var a = scaleX * cosAng-sinAng*tanSkewY*scaleX;
		var b = scaleX * sinAng+cosAng*tanSkewY*scaleX;
		var c = -scaleY * sinAng+cosAng*tanSkewX*scaleY;
		var d = scaleY * cosAng + sinAng * tanSkewX * scaleY;
		
		var x = this.x+offsetX+pivotX;
		var y = this.y + offsetY + pivotY;
		
		
		
		var matrix:FastMatrix3 = new FastMatrix3(a, c, x, b, d, y, 0, 0, 1);
		aValue.mergeVec(matrix.multvec(new FastVector2(   minMax.min.x, minMax.min.y)));
		aValue.mergeVec(matrix.multvec(new FastVector2(   minMax.max.x, minMax.max.y)));
		aValue.mergeVec(matrix.multvec(new FastVector2(   minMax.max.x, minMax.min.y)));
		aValue.mergeVec(matrix.multvec(new FastVector2(   minMax.min.x, minMax.max.y)));
	}
	
	public function getTransformation(transform:FastMatrix3 = null):FastMatrix3 
	{
		if (parent != null)
		{
			transform = parent.getTransformation(transform);
		}
		if (transform == null)
		{
			transform = FastMatrix3.identity();
		}
		
		transform = transform.multmat(FastMatrix3.translation(x+pivotX+offsetX, y+pivotY+offsetY));
		transform = transform.multmat(FastMatrix3.scale(scaleX, scaleY));
		transform = transform.multmat(FastMatrix3.rotation(rotation));
		return transform;
	}
	
	
}