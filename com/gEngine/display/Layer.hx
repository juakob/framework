package com.gEngine.display;
import com.gEngine.painters.IPainter;
import com.gEngine.painters.Painter;
import com.gEngine.display.IDraw;
import com.helpers.Matrix;
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
	
	public var x:Float=0;
	public var y:Float=0;
	
	public var scaleX:Float=1;
	public var scaleY:Float=1;
	
	private var mHlpMatrix:Matrix = new Matrix();
	
	public var parent:IDrawContainer;
	public var visible:Bool = true;
	public var painter:IPainter;
	
	public function new() 
	{
		mChildren = new MyList();
		mTransformation = new Matrix();
	}
	
	
	/* INTERFACE com.gEngine.IDraw */
	
	public function render(aPainter:IPainter, transform:Matrix):Void 
	{
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
		if (painter == null)
		{
			for (child in mChildren) 
			{
				child.render(aPainter,mHlpMatrix);
			}
		}else {
			aPainter.render();
			aPainter.finish();
			aPainter = painter;	
			aPainter.start();
			for (child in mChildren) 
			{
				child.render(aPainter,mHlpMatrix);
			}
			aPainter.render();
			aPainter.finish();
		}
		
		
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
		mChildren.push(aChild);
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
	
}