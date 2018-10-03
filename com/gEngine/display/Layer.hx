package com.gEngine.display;
import com.gEngine.DrawArea;
import com.gEngine.Filter;
import com.gEngine.painters.IPainter;
import com.gEngine.painters.Painter;
import com.gEngine.display.IDraw;
import com.helpers.Matrix;
import com.helpers.MinMax;
import kha.FastFloat;
import kha.math.FastMatrix3;


/**
 * ...
 * @author Joaquin
 */
class Layer implements IDrawContainer
{
	private var mChildren:MyList<IDraw>;
	public var mTransformation:Matrix;
	private var mBlendMode:Int;
	private var mTexture:Int;
	
	public var x:FastFloat=0;
	public var y:FastFloat=0;
	
	public var scaleX:FastFloat=1;
	public var scaleY:FastFloat=1;
	
	private var mHlpMatrix:Matrix = new Matrix();
	
	public var parent:IDrawContainer;
	public var visible:Bool = true;
	public var filter:Filter;
	
	public var drawArea(default,set):MinMax;
	public var length(get, null):Int;
	
	public function new() 
	{
		mChildren = new MyList();
		mTransformation = new Matrix();
		
	}
	
	
	/* INTERFACE com.gEngine.IDraw */
	
	public function render(aPainter:IPainter, transform:Matrix):Void 
	{
		com.debug.Profiler.startMeasure("renderLayer");
		mTransformation.tx = x;
		mTransformation.ty = y;
		mTransformation.a = scaleX;
		mTransformation.d = scaleY;
		if (!visible)
		{
			return;
		}
		if (transform != null)
		{
			mHlpMatrix.setTo(mTransformation.a, mTransformation.b, mTransformation.c, mTransformation.d, mTransformation.tx, mTransformation.ty);
			mHlpMatrix.concat(transform);
		}else {
			mHlpMatrix.setTo(mTransformation.a, mTransformation.b, mTransformation.c, mTransformation.d, mTransformation.tx, mTransformation.ty);
		}
		if (drawArea != null)
		{
			aPainter.render();
			aPainter.adjustRenderArea(drawArea);
		}
		if (filter == null)
		{
			com.debug.Profiler.startMeasure("renderChildren");
			for (child in mChildren) 
			{
				child.render(aPainter,mHlpMatrix);
			}
			com.debug.Profiler.endMeasure("renderChildren");
		}else {
			
			filter.render(this, mChildren, aPainter, mHlpMatrix);
			
		}
		if (drawArea != null)
		{
			aPainter.render();
			aPainter.resetRenderArea();
		}
		com.debug.Profiler.endMeasure("renderLayer");
	}
	
	var drawAreaTemp:MinMax = new MinMax();
	public function getDrawArea(aValue:MinMax):Void
	{
		drawAreaTemp.reset();
		for (child in mChildren) 
		{
			child.getDrawArea(drawAreaTemp);
		}
		mTransformation.tx = x;
		mTransformation.ty = y;
		mTransformation.a = scaleX;
		mTransformation.d = scaleY;
		drawAreaTemp.transform(mTransformation);
		aValue.merge(drawAreaTemp);
	}
	public var playing(default,default):Bool = true;
	public function stop():Void
	{
		playing = false;
	}
	public function play():Void
	{
		playing = true;
	}
	public function update(passedTime:Float):Void 
	{
		if (playing)
		{
			for (child in mChildren) 
			{
				child.update(passedTime);
			}
		}
	}
	
	
	
	//public function get_scaleX():Float 
	//{
		//return mTransformation.a;
	//}
	//public function set_scaleX(aValue:Float):Float 
	//{
		//return mTransformation.a = aValue;
	//}
	//public function get_scaleY():Float 
	//{
		//return mTransformation.d;
	//}
	//public function set_scaleY(aValue:Float):Float 
	//{
		//return mTransformation.d = aValue;
	//}
	
	/* INTERFACE com.gEngine.display.IDraw */
	
	public function blend():Int 
	{
		return 0;
		//return Tilesheet.TILE_BLEND_NORMAL;
	}
	
	public function texture():Int 
	{
		for (child in mChildren) 
		{
			if (child.texture() != -666)
			{
				return child.texture() ;
			}
		}
		return -666;
	}
	public function addChild(aChild:IDraw):Void
	{
		aChild.parent = this;
		mChildren.push(cast aChild);
	}
	
	/* INTERFACE com.gEngine.display.IDraw */
	
	public function remove(aChild:IDraw):Void 
	{
		var counter:Int = 0;
		for (child in mChildren) 
		{
			if (child == aChild)
			{
				mChildren.splice(counter, 1);
				return;
			}
			++counter;
		}
	}
	
	public function destroy():Void
	{
		mChildren.splice(0, mChildren.length);
		mHlpMatrix = null;
		mTransformation = null;
	}
	
	/* INTERFACE com.gEngine.display.IDraw */
	
	public function removeFromParent():Void 
	{
		if (parent != null)
		{
			parent.remove(this);
		}
	}
	
	public function sortY():Void
	{
		mChildren.sort(sortYCompare);
	}
	
	/* INTERFACE com.gEngine.display.IDraw */
	
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
		transform = transform.multmat(FastMatrix3.translation(x, y));
		transform = transform.multmat(FastMatrix3.scale(scaleX, scaleY));
	//	transform = transform.multmat(FastMatrix3.rotation(rotation));
		return transform;
	}
	
	/* INTERFACE com.gEngine.display.IDrawContainer */
	
	public var offsetX:FastFloat;
	
	public var offsetY:FastFloat;
	
	public var rotation(default, set):Float;
	
	public function set_rotation(aValue:Float):FastFloat
	{
		//if (aValue != rotation)
		//{
			//rotation = aValue;
			//sinAng = Math.sin(aValue);
			//cosAng = Math.cos(aValue);
		//}
		return rotation;
	}
	
	private function sortYCompare(a:IDraw, b:IDraw):Int
	{
		if (a.y < b.y)
		{
			return -1;
		}
		if (a.y > b.y)
		{
		return 1;
		}
		return 0;
	}
	
	function set_drawArea(value:MinMax):MinMax 
	{
		trace(value.max.x );
		value.min.x = GEngine.i.width*value.min.x/GEngine.virtualWidth;
		value.min.y = GEngine.i.height*value.min.y / GEngine.virtualHeight;
		value.max.x = GEngine.i.width*value.max.x / GEngine.virtualWidth;
		value.max.y = GEngine.i.height*value.max.y/GEngine.virtualHeight;
		return drawArea = value;
	}
	
	function get_length():Int 
	{
		return mChildren.length;
	}
	
}