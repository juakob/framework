package com.gEngine.display;
import com.gEngine.AnimationData;
import com.gEngine.Frame;
import com.gEngine.MaskBatch;
import com.gEngine.painters.IPainter;
import com.gEngine.painters.Painter;
import com.gEngine.display.IDraw;
import com.gEngine.Dummy;
import com.gEngine.Label;
import com.helpers.Matrix;
import com.MyList;
import com.helpers.Rectangle;
import kha.math.FastMatrix3;



class BasicSprite implements IDraw
{
	
	public var x:Float=0;
	public var y:Float=0;
	public var scaleX:Float;
	public var scaleY:Float;
	public var rotation(default, set):Float;
	
	private var cosAng:Float;
	private var sinAng:Float;
	
	private var pivotX:Float=0;
	private var pivotY:Float=0;
	
	public var offsetX:Float=0;
	public var offsetY:Float=0;
	
	private var mAnimationData:AnimationData;
	
	public var TotalFrames(default, null):Int;
	private var mTileSheetId:Int;
	
	
	public var Blend:Int;
	
	public var parent:IDrawContainer;
	public var visible:Bool = true;
	
	public var alpha:Float = 1;
	
	public var skewX(default,set):Float = 0;
	public var skewY(default,set):Float = 0;
	
	private var tanSkewX:Float = 0;
	private var tanSkewY:Float = 0;
	
	private var transRed:Float = 0;
	private var transGreen:Float = 0;
	private var transBlue:Float = 0;
	private var transAlpha:Float = 0;
	
	private var mTextureId:Int =-1;
	
	/** Creates a regular polygon with the specified redius, number of edges, and color. */
	public function new (aAnimationData:AnimationData)
	{
		mAnimationData = aAnimationData;

		
		TotalFrames = aAnimationData.frames.length;
		

		#if debug
		if (TotalFrames > 1000) {
			throw "error";
		}
		#end

		Blend = 0;//Tilesheet.TILE_BLEND_NORMAL;
		scaleX = 1;
		scaleY = 1;
		rotation = 0;
		cosAng = Math.cos(rotation);
		sinAng = Math.sin(rotation);
		
		mTextureId = aAnimationData.texturesID;
	}
	
	
	public function recenter():Void
	{
		var rec=calculateBounds();
		pivotX = rec.x + rec.width / 2;
		pivotY= rec.y + rec.height / 2;
		//x = aX;
		//y = aY;
		//
	}
	
	
	private var mDefaultFrameDuration:Float=0;
	public var TotalTime(default,null):Float=0;
	private var mCurrentTime:Float=0;
	public var CurrentFrame(default,default):Int=0;
	public var Loop(default,default):Bool=true;
	public var Playing(default,null):Bool=true;
	private var previousFrame:Int;
	private var mFrameSkiped:Int;
	public var frameRate:Float = 1 / 30;
	
	 // playback methods
	
	public function play():Void
	{
		Playing = true;
	 //  mCurrentTime = 0;
	}
	
	public function pause():Void
	{
		Playing = false;
	}
	
	public function stop():Void
	{
		Playing = false;
		CurrentFrame = 0;
	}
	public function set_rotation(aValue:Float):Float
	{
		if (aValue != rotation)
		{
			rotation = aValue;
			sinAng = Math.sin(aValue);
			cosAng = Math.cos(aValue);
		}
		return rotation;
	}
	
	
	// IAnimatable
	
	/** @inheritDoc */
	public function update(passedTime:Float):Void
	{
		previousFrame = CurrentFrame;
		var finalFrame:Int;

		var breakAfterFrame:Bool = false;
		
		mFrameSkiped = 0;
		#if debug
			if (CurrentFrame == TotalFrames)
			{
				throw "Error()";
			}
		#end
		if (Playing && passedTime > 0.0) 
		{	
	
			mCurrentTime += passedTime;
			
			if (mCurrentTime >= frameRate)
			{
				mFrameSkiped = Std.int(mCurrentTime / frameRate);
				mCurrentTime -= frameRate*mFrameSkiped;
				CurrentFrame += mFrameSkiped;
				//mFrameSkiped -= 1;
				if (CurrentFrame >=TotalFrames )
				{
					if (Loop)
					{
						CurrentFrame =CurrentFrame%(TotalFrames);
					}
					else
					{
					CurrentFrame = TotalFrames - 1;
						Playing = false;
					}
				}
				#if debug
					if (CurrentFrame == TotalFrames)
					{
						throw "Error()";
					}
				#end
				
			}
		}
		#if debug
		else {
			
				if (CurrentFrame == TotalFrames)
				{
					throw "Error()";
				}
			
		}
		
		
			if (CurrentFrame == TotalFrames)
			{
				throw "Error()";
			}
		#end
		
			
	  
	   
	}
	public inline function frameDiferent():Bool
	{
		return previousFrame != CurrentFrame;
	}
	
	public function isComplete():Bool 
	{
		return !Loop && CurrentFrame == TotalFrames-1;
	}
	
	
	 public function set_CurrentFrame(frame:Int):Int
	{
		CurrentFrame = frame;
		//#if debug
		//{
			//if (CurrentFrame == TotalFrames)
			//{
				//throw new Error("The frame is out of range");
			//}
		//}
		//#end
		return CurrentFrame;
	}
	
	public function goToAndStop(frame:Int):Void
	{
		#if debug
			if (frame == -1)
			{
				throw "negative frame";
			}
			if (CurrentFrame == TotalFrames)
			{
				throw "Error";
			}
		#end
		CurrentFrame = frame;
		Playing = false;
	}
	public function goToAndPlay(frame:Int):Void
	{
		#if debug
			if (frame == -1)
			{
				throw "negative frame";
			}
			if (CurrentFrame == TotalFrames)
			{
				throw "Error";
			}
		#end
		CurrentFrame = frame;
		Playing = true;
	}
	
	public function hasDummy(name:String):Bool 
	{
		
		var dummys:MyList<Dummy> = mAnimationData.dummys[CurrentFrame];
		for(dummy in dummys)
		{
			if (dummy.name == name)
			{
				return true;
			}
		}
		return false;
	}
	public function getDummy(name:String):Dummy 
	{
		var dummys:MyList<Dummy> =  mAnimationData.dummys[CurrentFrame];
		for(dummy in dummys)
		{
			if (dummy.name == name)
			{
				return dummy;
			}
		}
		throw "dummy " + name + " not found";
	}
	private var sDummys:MyList<Dummy>=new MyList<Dummy>();
	public function getDummys(name:String) :MyList<Dummy>
	{
		sDummys.splice(0, sDummys.length);
		
		var dummys:MyList<Dummy> =  mAnimationData.dummys[CurrentFrame];
		for(dummy in dummys)
		{
			if (dummy.name == name)
			{
				sDummys.push( dummy);
			}
		}
		return sDummys;
	}
	
	public function currentLabel():String 
	{
		var frame:Int;
		
		for(label in mAnimationData.labels)
		{
			frame = label.frame;
			if ( frame>= CurrentFrame-mFrameSkiped&&frame<=CurrentFrame) {
				return label.name;
			}
			if (frame > CurrentFrame)
			{
				return null;
			}
		}
		return null;
	}
	public function labelEnd(label:String,start:Int=0):Int
	{
		var Lables = mAnimationData.labels;
		for (i in start...Lables.length-1) //dont analyze last label
		{
			if (Lables[i].name == label) {
				if (i == Lables.length)
				{
					return TotalFrames-1;
				}
				if (Lables[i + 1].name.charAt(0) == "[") return labelEnd(Lables[i + 1].name, i + 1);
				
				return Lables[i + 1].frame-1;
				
			}
		}
		if (Lables[Lables.length - 1].name == label)
		{
			return TotalFrames-1;
		}
		return -1;
	}
	public function labelFrame(aLabel:String):Int
	{
		for (label in mAnimationData.labels) 
		{
			if (label.name == aLabel) {
				return label.frame;
			}
		}
		return -1;
	}
	
	public function labelFrameAt(frame:Int):String 
	{
		for (label in mAnimationData.labels) 
		{
			if (label.frame == frame) {
				return label.name;
			}
			if (label.frame > frame)
			{
				return null;
			}
		}
		return null;
	}
	
	public function hasLabel(aLabel:String):Bool 
	{
		for (label in mAnimationData.labels) 
		{
			if (label.name == aLabel)
			{
				return true;
			}
		}
		return false;
	}
	var bounds:Rectangle;
	public function calculateBounds():Rectangle
	{
		var frame = mAnimationData.frames[CurrentFrame];
		var counter:Int = Std.int(frame.vertexs.length / 2);
		if (counter == 0) return new Rectangle();
		var vertexX:Float;
		var minX:Float = Math.POSITIVE_INFINITY;
		var maxX:Float = Math.NEGATIVE_INFINITY;
		var vertexY:Float;
		var minY:Float = Math.POSITIVE_INFINITY;
		var maxY:Float = Math.NEGATIVE_INFINITY;
		var vertexs = frame.vertexs;
		for ( i in 0...counter)
		{
			vertexX = vertexs[i * 2 + 0];
			vertexY = vertexs[i * 2 + 1];
			if (vertexX > maxX) maxX = vertexX;
			if (vertexX < minX) minX = vertexX;
			if (vertexY > maxY) maxY = vertexY;
			if (vertexY < minY) minY = vertexY;
		}
		return new Rectangle(minX+x-pivotX-offsetX, minY+y-pivotY-offsetY, maxX - minX, maxY - minY);
	}
	public function render(painter:IPainter,transform:Matrix):Void
	{
		if (!visible)
		{
			return;
		}	
		x += offsetX+pivotX;
		y += offsetY+pivotY;
		
		
		var _1t = scaleX * cosAng-sinAng*tanSkewY*scaleX;
		var _2t = scaleX * sinAng+cosAng*tanSkewY*scaleX;
		var _3t = -scaleY * sinAng+cosAng*tanSkewX*scaleY;
		var _4t = scaleY * cosAng+sinAng*tanSkewX*scaleY;
		 
		var _1:Float = _1t*transform.a  +_2t*transform.c;//new a
		var _2:Float = _1t*transform.b+_2t*transform.d;//new b
		var _3:Float = _3t * transform.a +_4t *transform.c;//new c
		var _4:Float = _3t * transform.b + transform.d * _4t;//new d
	
		var _tx:Float = x* transform.a+ y *transform.c + transform.tx;
		var _ty:Float = x * transform.b + y * transform.d +transform.ty;
		
		var vertexX:Float;
		var vertexY:Float;
		
		
		var frame = mAnimationData.frames[CurrentFrame];
		
		var vertexs = frame.vertexs;
		var uvs = frame.UVs;
		var alphas = frame.alphas;
		var colorTrans = frame.colortTransform;
		var staffToDraw:Int = Std.int(vertexs.length / 8) + frame.maskBatchs.length;
		var counter:Int = 0;
		var maskCounter:Int = 0;
		var normalCounter:Int = 0;
		var drawMask:Bool=false;
		do {
			if (frame.maskBatchs.length == 0)
			{
				counter = Std.int(vertexs.length / 8);
			}else {
				if (drawMask)
				{
					drawMask = false;
					--staffToDraw;
					
					var maskBatch:MaskBatch = frame.maskBatchs[maskCounter];
					painter.validateBatch(mTextureId, Std.int(maskBatch.vertex.length/2), false,false,true);
					
					var polygons:MyList<Float> = maskBatch.vertex;
					var polyUvs:MyList<Float> = maskBatch.uvs;
					var maskUvs:MyList<Float> = maskBatch.maskUvs;
					
					var vertex0:Int = 0;
					for (vertexCount in maskBatch.vertexCount) 
					{
						var trianglesCount:Int = vertexCount-2;
						for(i in 0...trianglesCount)
						{
							vertexX = polygons[vertex0]-pivotX;
							vertexY = polygons[vertex0+1]-pivotY;
							painter.write( _tx + vertexX * _1 + vertexY * _3);
							painter.write( _ty + vertexX * _2 + vertexY * _4);
							painter.write(polyUvs[vertex0]);
							painter.write(polyUvs[vertex0+1]);
							painter.write(maskUvs[vertex0+0]);
							painter.write(maskUvs[vertex0+1]);
							
							
							vertexX = polygons[vertex0+i*2  + 2]-pivotX;
							vertexY = polygons[vertex0+i*2  + 3]-pivotY;
							painter.write( _tx + vertexX * _1 + vertexY * _3);
							painter.write( _ty + vertexX * _2 + vertexY * _4);
							painter.write(polyUvs[vertex0+i*2  + 2]);
							painter.write(polyUvs[vertex0+i*2  + 3]);
							painter.write(maskUvs[vertex0+i*2  + 2]);
							painter.write(maskUvs[vertex0+i*2 + 3]);
							
							vertexX = polygons[vertex0+i*2 + 4]-pivotX;
							vertexY = polygons[vertex0+i*2 + 5]-pivotY;
							painter.write( _tx + vertexX * _1 + vertexY * _3);
							painter.write( _ty + vertexX * _2 + vertexY * _4);
							painter.write(polyUvs[vertex0+i*2 + 4]);
							painter.write(polyUvs[vertex0+i*2 + 5]);
							painter.write(maskUvs[vertex0+i*2 + 4]);
							painter.write(maskUvs[vertex0+i*2 + 5]);
							
							
						}
						vertex0 += vertexCount * 2;
					}
					++maskCounter;
				}
				
				if (frame.maskBatchs.length > maskCounter)
				{
					counter = frame.maskBatchs[maskCounter].start-normalCounter;
					drawMask = true;
					
				}else {
					counter = Std.int(vertexs.length / 8);
				}
				
			}
			painter.validateBatch(mTextureId, Std.int(frame.vertexs.length / 8 + frame.UVs.length / 8), alphas.length != 0, colorTrans.length!=0,false);
			
			
			if (colorTrans.length!=0)
			{
				var redMul, blueMul , greenMul,alphaMul:Float;
				var redAdd, blueAdd , greenAdd,alphaAdd:Float;
				for ( i in normalCounter...counter)
					{
						redMul = colorTrans[i*8];
						greenMul = colorTrans[i * 8 + 1];
						blueMul = colorTrans[i * 8 + 2];
						alphaMul = colorTrans[i*8 + 3];
						
						redAdd = colorTrans[i*8 +4];
						greenAdd = colorTrans[i * 8 + 5];
						blueAdd = colorTrans[i * 8 + 6] ;
						alphaAdd = colorTrans[i*8 + 7];
						
						vertexX = vertexs[i * 8 + 0]-pivotX;
						vertexY = vertexs[i * 8 + 1]-pivotY;
						painter.write( _tx + vertexX * _1 + vertexY * _3);
						painter.write( _ty + vertexX * _2 + vertexY * _4);
						painter.write(uvs[i * 8 + 0]);
						painter.write(uvs[i * 8 + 1]);
						painter.write(redMul);
						painter.write(greenMul);
						painter.write(blueMul);
						painter.write(alphaMul);
						painter.write(redAdd);
						painter.write(greenAdd);
						painter.write(blueAdd);
						painter.write(alphaAdd);
						
						
						vertexX = vertexs[i * 8 + 2]-pivotX;
						vertexY = vertexs[i * 8 + 3]-pivotY;
						painter.write( _tx + vertexX * _1 + vertexY * _3);
						painter.write( _ty + vertexX * _2 + vertexY * _4);
						painter.write(uvs[i * 8 + 2]);
						painter.write(uvs[i * 8 + 3]);
						painter.write(redMul);
						painter.write(greenMul);
						painter.write(blueMul);
						painter.write(alphaMul);
						painter.write(redAdd);
						painter.write(greenAdd);
						painter.write(blueAdd);
						painter.write(alphaAdd);
						
						vertexX = vertexs[i * 8 + 4]-pivotX;
						vertexY = vertexs[i * 8 + 5]-pivotY;
						painter.write( _tx + vertexX * _1 + vertexY * _3);
						painter.write( _ty + vertexX * _2 + vertexY * _4);
						painter.write(uvs[i * 8 + 4]);
						painter.write(uvs[i * 8 + 5]);
						painter.write(redMul);
						painter.write(greenMul);
						painter.write(blueMul);
						painter.write(alphaMul);
						painter.write(redAdd);
						painter.write(greenAdd);
						painter.write(blueAdd);
						painter.write(alphaAdd);
						
						vertexX = vertexs[i * 8 + 6]-pivotX;
						vertexY = vertexs[i * 8 + 7]-pivotY;
						painter.write( _tx + vertexX * _1 + vertexY * _3);
						painter.write( _ty + vertexX * _2 + vertexY * _4);
						painter.write(uvs[i * 8 + 6]);
						painter.write(uvs[i * 8 + 7]);
						painter.write(redMul);
						painter.write(greenMul);
						painter.write(blueMul);
						painter.write(alphaMul);
						painter.write(redAdd);
						painter.write(greenAdd);
						painter.write(blueAdd);
						painter.write(alphaAdd);
					}
			}else
			if (alphas.length == 0)
			{
				for ( i in normalCounter...counter)
				{
					vertexX = vertexs[i * 8 + 0]-pivotX;
					vertexY = vertexs[i * 8 + 1]-pivotY;
					painter.write( _tx + vertexX * _1 + vertexY * _3);
					painter.write( _ty + vertexX * _2 + vertexY * _4);
					painter.write(uvs[i * 8 + 0]);
					painter.write(uvs[i * 8 + 1]);
					
					vertexX = vertexs[i * 8 + 2]-pivotX;
					vertexY = vertexs[i * 8 + 3]-pivotY;
					painter.write( _tx + vertexX * _1 + vertexY * _3);
					painter.write( _ty + vertexX * _2 + vertexY * _4);
					painter.write(uvs[i * 8 + 2]);
					painter.write(uvs[i * 8 + 3]);
					
					vertexX = vertexs[i * 8 + 4]-pivotX;
					vertexY = vertexs[i * 8 + 5]-pivotY;
					painter.write( _tx + vertexX * _1 + vertexY * _3);
					painter.write( _ty + vertexX * _2 + vertexY * _4);
					painter.write(uvs[i * 8 + 4]);
					painter.write(uvs[i * 8 + 5]);
					
					
					vertexX = vertexs[i * 8 + 6]-pivotX;
					vertexY = vertexs[i * 8 + 7]-pivotY;
					painter.write( _tx + vertexX * _1 + vertexY * _3);
					painter.write( _ty + vertexX * _2 + vertexY * _4);
					painter.write(uvs[i * 8 + 6]);
					painter.write(uvs[i * 8 + 7]);
					
				}
			}else {
					for ( i in normalCounter...counter)
					{
						vertexX = vertexs[i * 8 + 0]-pivotX;
						vertexY = vertexs[i * 8 + 1]-pivotY;
						painter.write( _tx + vertexX * _1 + vertexY * _3);
						painter.write( _ty + vertexX * _2 + vertexY * _4);
						painter.write(uvs[i * 8 + 0]);
						painter.write(uvs[i * 8 + 1]);
						painter.write(alphas[i]);
						
						vertexX = vertexs[i * 8 + 2]-pivotX;
						vertexY = vertexs[i * 8 + 3]-pivotY;
						painter.write( _tx + vertexX * _1 + vertexY * _3);
						painter.write( _ty + vertexX * _2 + vertexY * _4);
						painter.write(uvs[i * 8 + 2]);
						painter.write(uvs[i * 8 + 3]);
						painter.write(alphas[i]);
						
						vertexX = vertexs[i * 8 + 4]-pivotX;
						vertexY = vertexs[i * 8 + 5]-pivotY;
						painter.write( _tx + vertexX * _1 + vertexY * _3);
						painter.write( _ty + vertexX * _2 + vertexY * _4);
						painter.write(uvs[i * 8 + 4]);
						painter.write(uvs[i * 8 + 5]);
						painter.write(alphas[i]);
						
						vertexX = vertexs[i * 8 + 6]-pivotX;
						vertexY = vertexs[i * 8 + 7]-pivotY;
						painter.write( _tx + vertexX * _1 + vertexY * _3);
						painter.write( _ty + vertexX * _2 + vertexY * _4);
						painter.write(uvs[i * 8 + 6]);
						painter.write(uvs[i * 8 + 7]);
						painter.write(alphas[i]);
					}
		
			}
			staffToDraw -= counter-normalCounter;
			normalCounter += counter-normalCounter;
		}while (staffToDraw > 0);
		x -= offsetX+pivotX;
		y -= offsetY+pivotY;
	}
	
	
	/* INTERFACE com.gEngine.display.IDraw */
	
	public inline function blend():Int 
	{
		return Blend;
	}

	public inline function texture():Int 
	{
		return mTileSheetId;
	}
	
	
	public function set_skewX(aValue:Float):Float
	{
		tanSkewX = Math.tan(aValue);
		return skewX = aValue;
	}
	public function set_skewY(aValue:Float):Float
	{
		tanSkewY = Math.tan(aValue);
		return skewY = aValue;
	}
	public function removeFromParent() 
	{
		if (parent != null)
		{
		parent.remove(this);
		}
	}
	
	public function colorTransform(r:Float = 0, g:Float = 0, b:Float = 0, a:Float = 0):Void
	{
		if (r == 0 && g == 0 && b == 0 && a == 0 )
		{
			//Blend = Blend & ~Tilesheet.TILE_TRANS_COLOR;
			
		}else {
		//	Blend |=Tilesheet.TILE_TRANS_COLOR;
		}
		transRed = r;
		transGreen = g;
		transBlue = b;
		transAlpha = alpha;
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
		
		transform = transform.multmat(FastMatrix3.translation(x+pivotX+offsetX, y+pivotY+offsetY));
		transform = transform.multmat(FastMatrix3.scale(scaleX, scaleY));
		transform = transform.multmat(FastMatrix3.rotation(rotation));
		return transform;
	}
	
	public function findNextEvent():Label
	{
		for (label in mAnimationData.labels) 
		{
			if (label.frame <= CurrentFrame) continue;
			if (label.name.charAt(0)== "[")
			{
				return label;
			}
		}
		return null;
	}
	/* INTERFACE com.gEngine.display.IDraw */
	
}

