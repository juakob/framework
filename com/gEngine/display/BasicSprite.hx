package com.gEngine.display;
import com.gEngine.AnimationData;
import com.gEngine.DrawArea;
import com.gEngine.Frame;
import com.gEngine.MaskBatch;
import com.gEngine.painters.IPainter;
import com.gEngine.painters.Painter;
import com.gEngine.display.IDraw;
import com.gEngine.Dummy;
import com.gEngine.Label;
import com.helpers.Matrix;
import com.MyList;
import com.helpers.MinMax;
import com.helpers.Rectangle;
import kha.Color;
import kha.FastFloat;
import kha.arrays.Float32Array;
import kha.math.FastMatrix3;
import kha.math.FastVector2;
import kha.math.Vector2;



class BasicSprite implements IDraw
{
	
	public var x:FastFloat=0;
	public var y:FastFloat=0;
	public var scaleX:FastFloat;
	public var scaleY:FastFloat;
	public var rotation(default, set):Float;
	
	public var blend:BlendMode = BlendMode.Default;
	
	private var cosAng:FastFloat;
	private var sinAng:FastFloat;
	
	public var pivotX:FastFloat=0;
	public var pivotY:FastFloat=0;
	
	public var offsetX:FastFloat=0;
	public var offsetY:FastFloat = 0;
	
	public var interpolateFrames:Bool;
	
	private var mAnimationData:AnimationData;
	
	public var TotalFrames(default, null):Int;
	private var mTileSheetId:Int;
	
	public var parent:IDrawContainer;
	public var visible:Bool = true;
	
	public var alpha:FastFloat = 1;
	
	public var skewX(default,set):FastFloat = 0;
	public var skewY(default,set):FastFloat = 0;
	
	private var tanSkewX:FastFloat = 0;
	private var tanSkewY:FastFloat = 0;
	
	private var colorTransform:Bool = false;
	private var addRed:FastFloat = 0;
	private var addGreen:FastFloat = 0;
	private var addBlue:FastFloat = 0;
	private var addAlpha:FastFloat = 0;
	
	private var mulRed:FastFloat = 1;
	private var mulGreen:FastFloat = 1;
	private var mulBlue:FastFloat = 1;
	private var mulAlpha:FastFloat = 1;
	
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

		scaleX = 1;
		scaleY = 1;
		rotation = 0;
		cosAng = Math.cos(rotation);
		sinAng = Math.sin(rotation);
		
		mTextureId = aAnimationData.texturesID;
	}
	public function clone():BasicSprite
	{
		var cl = new BasicSprite(mAnimationData);
		return cl;
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
	
	
	// IAnimatable
	
	/** @inheritDoc */
	public function update(passedTime:Float):Void
	{
		mFrameSkiped = 0;
		if (!Playing ) return;
		previousFrame = CurrentFrame;

		#if debug
			if (CurrentFrame == TotalFrames)
			{
				throw "Error()";
			}
		#end
	
		mCurrentTime += passedTime;
		if (mCurrentTime < frameRate) return;
		
		mFrameSkiped = Std.int(mCurrentTime / frameRate);
		mCurrentTime -= frameRate*mFrameSkiped;
		CurrentFrame += mFrameSkiped;
		mFrameSkiped -= 1;
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
		#if debug
		{
			if (CurrentFrame == TotalFrames)
			{
				throw "frame is out of range ";
			}
		}
		#end
		return CurrentFrame;
	}
	
	public function goToAndStop(frame:Int):Void
	{
		#if debug
			if (frame == -1)
			{
				throw "negative frame";
			}
			if (CurrentFrame >= TotalFrames)
			{
				throw "out of scope";
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
			if (CurrentFrame >= TotalFrames)
			{
				throw "out of scope";
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
		return null;
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
		 
		var _1 = _1t*transform.a  +_2t*transform.c;//new a
		var _2 = _1t*transform.b+_2t*transform.d;//new b
		var _3 = _3t * transform.a +_4t *transform.c;//new c
		var _4 = _3t * transform.b + transform.d * _4t;//new d
	
		var _tx = x* transform.a+ y *transform.c + transform.tx;
		var _ty = x * transform.b + y * transform.d +transform.ty;
		
		var vertexX:FastFloat;
		var vertexY:FastFloat;
		
		
		var frame = mAnimationData.frames[CurrentFrame];
		var vertexs:MyList<FastFloat>;
		if (interpolateFrames && CurrentFrame<TotalFrames)
		{
			vertexs = interpolateFrame(CurrentFrame, mCurrentTime, frameRate, mAnimationData.frames);
		}else {
			 vertexs= frame.vertexs;
		}
		 
		var uvs = frame.UVs;
		var alphas = frame.alphas;
		var colorTrans = frame.colortTransform;
		var stuffToDraw:Int = Std.int(vertexs.length / 8) + frame.maskBatchs.length+frame.blurBatchs.length;
		var drawTo:Int = 0;
		var maskCounter:Int = 0;
		var maskOffset:Int = 0;
		var blurCounter:Int = 0;
		var blurStarted:Bool=false;
		var drawFrom:Int = 0;
		var finishTarget:Int=-1;
		var workTargetId:Int=-1;
		var drawMask:Bool=false;
		do {
			if (frame.maskBatchs.length == 0)
			{
				drawTo = Std.int(vertexs.length / 8) + frame.maskBatchs.length+frame.blurBatchs.length;
			}else {
				if (drawMask)
				{
					drawMask = false;
					
					
					var maskBatch:MaskBatch = frame.maskBatchs[maskCounter];
					painter.validateBatch(mTextureId, Std.int(maskBatch.vertex.length/2), DrawMode.Mask,blend);
					--stuffToDraw;
					var polygons:MyList<FastFloat> = maskBatch.vertex;
					var polyUvs:MyList<FastFloat> = maskBatch.uvs;
					var maskUvs:MyList<FastFloat> = maskBatch.maskUvs;
					var vertex0:Int = 0;
					maskOffset +=  maskBatch.masksCount;
					
					var buffer = painter.getVertexBuffer();
					var vertexBufferCounter = painter.getVertexDataCounter();
					for (vertexCount in maskBatch.vertexCount) 
					{
						var trianglesCount:Int = vertexCount - 2;
						for(i in 0...trianglesCount)
						{
							vertexX = polygons[vertex0]-pivotX;
							vertexY = polygons[vertex0+1]-pivotY;
							buffer.set(vertexBufferCounter++, _tx + vertexX * _1 + vertexY * _3);
							buffer.set(vertexBufferCounter++, _ty + vertexX * _2 + vertexY * _4);
							buffer.set(vertexBufferCounter++,polyUvs[vertex0]);
							buffer.set(vertexBufferCounter++,polyUvs[vertex0+1]);
							buffer.set(vertexBufferCounter++,maskUvs[vertex0+0]);
							buffer.set(vertexBufferCounter++,maskUvs[vertex0+1]);
							
							
							vertexX = polygons[vertex0+i*2  + 2]-pivotX;
							vertexY = polygons[vertex0+i*2  + 3]-pivotY;
							buffer.set(vertexBufferCounter++, _tx + vertexX * _1 + vertexY * _3);
							buffer.set(vertexBufferCounter++, _ty + vertexX * _2 + vertexY * _4);
							buffer.set(vertexBufferCounter++,polyUvs[vertex0+i*2  + 2]);
							buffer.set(vertexBufferCounter++,polyUvs[vertex0+i*2  + 3]);
							buffer.set(vertexBufferCounter++,maskUvs[vertex0+i*2  + 2]);
							buffer.set(vertexBufferCounter++,maskUvs[vertex0+i*2 + 3]);
							
							vertexX = polygons[vertex0+i*2 + 4]-pivotX;
							vertexY = polygons[vertex0+i*2 + 5]-pivotY;
							buffer.set(vertexBufferCounter++, _tx + vertexX * _1 + vertexY * _3);
							buffer.set(vertexBufferCounter++, _ty + vertexX * _2 + vertexY * _4);
							buffer.set(vertexBufferCounter++,polyUvs[vertex0+i*2 + 4]);
							buffer.set(vertexBufferCounter++,polyUvs[vertex0+i*2 + 5]);
							buffer.set(vertexBufferCounter++,maskUvs[vertex0+i*2 + 4]);
							buffer.set(vertexBufferCounter++,maskUvs[vertex0+i*2 + 5]);
							
							
						}
						
						vertex0 += vertexCount * 2;
					}
					painter.setVertexDataCounter(vertexBufferCounter);
					++maskCounter;
				}
				
				if (frame.maskBatchs.length > maskCounter)
				{
					
					drawTo =drawFrom+ frame.maskBatchs[maskCounter].start - (drawFrom + maskOffset);
					drawMask = true;
					
				}else {
					drawTo = Std.int(vertexs.length / 8);
				}
				
			}
			if (frame.blurBatchs.length != 0 && blurCounter<frame.blurBatchs.length)
			{
				if (drawFrom == frame.blurBatchs[blurCounter].start && !blurStarted)
				{
					
					blurStarted = true;
					drawTo = frame.blurBatchs[blurCounter].end+1;
					painter.render();
					finishTarget = GEngine.i.currentCanvasId();
					workTargetId = GEngine.i.getRenderTarget();
					var drawArea = MinMax.weak;
					drawArea.reset();
					
					transformArea(frame.blurBatchs[blurCounter].area,drawArea);
					//drawArea.addBorderWidth(frame.blurBatchs[blurCounter].blurX/2);
					//drawArea.addBorderWidth(frame.blurBatchs[blurCounter].blurY/2);
					drawArea.min.x -= offsetX;
					drawArea.min.y -= offsetY;
					drawArea.max.x -= offsetX;
					drawArea.max.y -= offsetY;
					
					GEngine.i.setCanvas(workTargetId);
					GEngine.i.currentCanvas().g2.scissor(Std.int(drawArea.min.x-5), 
														Std.int(drawArea.min.y-5), 
														Std.int(drawArea.width()+10),
														Std.int(drawArea.height()+10));
					GEngine.i.currentCanvas().g2.begin(true,Color.fromFloats(0,0,0,0));
					GEngine.i.currentCanvas().g2.end();
					GEngine.i.currentCanvas().g2.disableScissor();
				}else
				if (drawFrom == frame.blurBatchs[blurCounter].end+1)
				{
					painter.render();
					blurStarted = false;
					
					var drawArea = MinMax.weak;
					var resolution:Int = 1;
					var filter = GEngine.i.blurX;
					filter.resolution = 0.5;
					filter.mFactor = frame.blurBatchs[blurCounter].blurX/5;
					var middleStep = GEngine.i.getRenderTarget();
					GEngine.i.setCanvas(middleStep);
					
					GEngine.i.renderBuffer(workTargetId, filter, drawArea.min.x * resolution, drawArea.min.y * resolution, drawArea.width() * resolution, drawArea.height() * resolution, 1280, 720, true, filter.resolution);
					GEngine.i.setCanvas(finishTarget);
					GEngine.i.releaseRenderTarget(workTargetId);
					var filter2 = GEngine.i.blurY;
					filter2.resolution = 2;
					filter2.mFactor = frame.blurBatchs[blurCounter].blurY/5;
					GEngine.i.renderBuffer(middleStep, filter2, drawArea.min.x * resolution, drawArea.min.y * resolution, drawArea.width() * resolution, drawArea.height() * resolution, 1280*2, 720*2, false,1);
					GEngine.i.releaseRenderTarget(middleStep);
					
					
					++blurCounter;
					continue;
				}
				else
				{
					//trace(frame.blurBatchs.length);
					drawTo = frame.blurBatchs[blurCounter].start - drawFrom;// ;
				
				}
			}
			var drawMode:DrawMode = DrawMode.Default;
			if (alphas.length != 0) drawMode = DrawMode.Alpha;
			if (colorTrans.length != 0 || colorTransform) drawMode = DrawMode.ColorTint;
			
			
			painter.validateBatch(mTextureId, Std.int(frame.vertexs.length / 2 ), drawMode,blend);
			
			
			if (colorTrans.length!=0||colorTransform)
			{
				var redMul, blueMul , greenMul,alphaMul:Float;
				var redAdd, blueAdd , greenAdd, alphaAdd:Float;
				var frameColorTransform:Bool = colorTrans.length != 0;
				var buffer = painter.getVertexBuffer();
				var vertexBufferCounter = painter.getVertexDataCounter();
				for ( i in drawFrom...drawTo)
					{
						if (frameColorTransform)
						{
							redMul = colorTrans[i*8]*this.mulRed;
							greenMul = colorTrans[i * 8 + 1]*this.mulGreen;
							blueMul = colorTrans[i * 8 + 2]*this.mulBlue;
							alphaMul = colorTrans[i*8 + 3]*this.mulAlpha;
							
							redAdd = colorTrans[i*8 +4]+this.addRed;
							greenAdd = colorTrans[i * 8 + 5]+this.addGreen;
							blueAdd = colorTrans[i * 8 + 6] +this.addBlue;
							alphaAdd = colorTrans[i * 8 + 7] + this.addAlpha;
						}else {
							redMul = this.mulRed;
							greenMul = this.mulGreen;
							blueMul = this.mulBlue;
							alphaMul = this.mulAlpha;
							
							redAdd = this.addRed;
							greenAdd = this.addGreen;
							blueAdd = this.addBlue;
							alphaAdd = this.addAlpha;
						}
						
						vertexX = vertexs[i * 8 + 0]-pivotX;
						vertexY = vertexs[i * 8 + 1] - pivotY;
						writeColorVertex(_tx + vertexX * _1 + vertexY * _3, _ty + vertexX * _2 + vertexY * _4, 
						uvs[i * 8 + 0], uvs[i * 8 + 1],
						redMul, greenMul, blueMul, alphaMul, redAdd, greenAdd, blueAdd, alphaAdd, buffer, vertexBufferCounter);
						vertexBufferCounter += 12;
						
						vertexX = vertexs[i * 8 + 2]-pivotX;
						vertexY = vertexs[i * 8 + 3]-pivotY;
						writeColorVertex(_tx + vertexX * _1 + vertexY * _3, _ty + vertexX * _2 + vertexY * _4, 
						uvs[i * 8 + 2], uvs[i * 8 + 3],
						redMul, greenMul, blueMul, alphaMul, redAdd, greenAdd, blueAdd, alphaAdd, buffer, vertexBufferCounter);
						vertexBufferCounter += 12;
						
						vertexX = vertexs[i * 8 + 4]-pivotX;
						vertexY = vertexs[i * 8 + 5]-pivotY;
						writeColorVertex(_tx + vertexX * _1 + vertexY * _3, _ty + vertexX * _2 + vertexY * _4, 
						uvs[i * 8 + 4], uvs[i * 8 + 5],
						redMul, greenMul, blueMul, alphaMul, redAdd, greenAdd, blueAdd, alphaAdd, buffer, vertexBufferCounter);
						vertexBufferCounter += 12;
						
						vertexX = vertexs[i * 8 + 6]-pivotX;
						vertexY = vertexs[i * 8 + 7]-pivotY;
						writeColorVertex(_tx + vertexX * _1 + vertexY * _3, _ty + vertexX * _2 + vertexY * _4, 
						uvs[i * 8 + 6], uvs[i * 8 + 7],
						redMul, greenMul, blueMul, alphaMul, redAdd, greenAdd, blueAdd, alphaAdd, buffer, vertexBufferCounter);
						vertexBufferCounter += 12;
					}
				painter.setVertexDataCounter(vertexBufferCounter);
			}else
			if (alphas.length == 0)
			{
				var buffer = painter.getVertexBuffer();
				var vertexBufferCounter = painter.getVertexDataCounter();
				var vertexIndex:Int;
				var uvIndex:Int;
				for ( i in drawFrom...drawTo)
				{
					uvIndex=vertexIndex = i * 8;
					vertexX = vertexs[vertexIndex]-pivotX;
					vertexY = vertexs[++vertexIndex]-pivotY;
					buffer.set(vertexBufferCounter++, _tx + vertexX * _1 + vertexY * _3);
					buffer.set(vertexBufferCounter++, _ty + vertexX * _2 + vertexY * _4);
					buffer.set(vertexBufferCounter++,uvs[uvIndex]);
					buffer.set(vertexBufferCounter++,uvs[++uvIndex]);
					
					vertexX = vertexs[++vertexIndex]-pivotX;
					vertexY = vertexs[++vertexIndex]-pivotY;
					buffer.set(vertexBufferCounter++, _tx + vertexX * _1 + vertexY * _3);
					buffer.set(vertexBufferCounter++, _ty + vertexX * _2 + vertexY * _4);
					buffer.set(vertexBufferCounter++,uvs[++uvIndex]);
					buffer.set(vertexBufferCounter++,uvs[++uvIndex]);
					
					vertexX = vertexs[++vertexIndex]-pivotX;
					vertexY = vertexs[++vertexIndex]-pivotY;
					buffer.set(vertexBufferCounter++, _tx + vertexX * _1 + vertexY * _3);
					buffer.set(vertexBufferCounter++, _ty + vertexX * _2 + vertexY * _4);
					buffer.set(vertexBufferCounter++,uvs[++uvIndex]);
					buffer.set(vertexBufferCounter++,uvs[++uvIndex]);
					
					
					vertexX = vertexs[++vertexIndex]-pivotX;
					vertexY = vertexs[++vertexIndex]-pivotY;
					buffer.set(vertexBufferCounter++, _tx + vertexX * _1 + vertexY * _3);
					buffer.set(vertexBufferCounter++, _ty + vertexX * _2 + vertexY * _4);
					buffer.set(vertexBufferCounter++,uvs[++uvIndex]);
					buffer.set(vertexBufferCounter++,uvs[++uvIndex]);
					
				}
				painter.setVertexDataCounter(vertexBufferCounter);
			}else {
				var buffer = painter.getVertexBuffer();
				var vertexBufferCounter = painter.getVertexDataCounter();
					for ( i in drawFrom...drawTo)
					{
						vertexX = vertexs[i * 8 + 0]-pivotX;
						vertexY = vertexs[i * 8 + 1]-pivotY;
						buffer.set(vertexBufferCounter++, _tx + vertexX * _1 + vertexY * _3);
						buffer.set(vertexBufferCounter++, _ty + vertexX * _2 + vertexY * _4);
						buffer.set(vertexBufferCounter++,uvs[i * 8 + 0]);
						buffer.set(vertexBufferCounter++,uvs[i * 8 + 1]);
						buffer.set(vertexBufferCounter++,alphas[i]);
						
						vertexX = vertexs[i * 8 + 2]-pivotX;
						vertexY = vertexs[i * 8 + 3]-pivotY;
						buffer.set(vertexBufferCounter++, _tx + vertexX * _1 + vertexY * _3);
						buffer.set(vertexBufferCounter++, _ty + vertexX * _2 + vertexY * _4);
						buffer.set(vertexBufferCounter++,uvs[i * 8 + 2]);
						buffer.set(vertexBufferCounter++,uvs[i * 8 + 3]);
						buffer.set(vertexBufferCounter++,alphas[i]);
						
						vertexX = vertexs[i * 8 + 4]-pivotX;
						vertexY = vertexs[i * 8 + 5]-pivotY;
						buffer.set(vertexBufferCounter++, _tx + vertexX * _1 + vertexY * _3);
						buffer.set(vertexBufferCounter++, _ty + vertexX * _2 + vertexY * _4);
						buffer.set(vertexBufferCounter++,uvs[i * 8 + 4]);
						buffer.set(vertexBufferCounter++,uvs[i * 8 + 5]);
						buffer.set(vertexBufferCounter++,alphas[i]);
						
						vertexX = vertexs[i * 8 + 6]-pivotX;
						vertexY = vertexs[i * 8 + 7]-pivotY;
						buffer.set(vertexBufferCounter++, _tx + vertexX * _1 + vertexY * _3);
						buffer.set(vertexBufferCounter++, _ty + vertexX * _2 + vertexY * _4);
						buffer.set(vertexBufferCounter++,uvs[i * 8 + 6]);
						buffer.set(vertexBufferCounter++,uvs[i * 8 + 7]);
						buffer.set(vertexBufferCounter++,alphas[i]);
					}
				painter.setVertexDataCounter(vertexBufferCounter);
			}
			stuffToDraw -= drawTo-drawFrom;
			drawFrom += drawTo-drawFrom;
		}while (stuffToDraw > 0 || blurStarted);
		x -= offsetX+pivotX;
		y -= offsetY+pivotY;
	}
	
	private static var hInterpolated:MyList<FastFloat>=new MyList<FastFloat>();
	private static inline function interpolateFrame(currentFrame:Int, deltaTime:Float, frameRate:Float, frames:MyList<Frame>):MyList<FastFloat>
	{
		hInterpolated.splice(0, hInterpolated.length);
		var frameA = frames[currentFrame].vertexs;
		var frameB = frames[currentFrame+1].vertexs;
		var s:Float = deltaTime / frameRate;
		var total:Int = frameA.length;
		for (i in 0...total) 
		{
			hInterpolated.push(frameB[i] * s + (1-s) * frameA[i]);
		}
		return hInterpolated;
	}
	
	private static inline function writeColorVertex(aX:Float, aY:Float, aU:Float, aV:Float, aRedMul:Float, aGreenMul:Float, aBlueMul:Float, aAlphaMul:Float,
												aRedAdd:Float,aGreenAdd:Float,aBlueAdd:Float,aAlphaAdd:Float,buffer:Float32Array,offsetPos:Int) {
			buffer.set(offsetPos++ , aX);
			buffer.set(offsetPos++ , aY);
			buffer.set(offsetPos++ , aU);
			buffer.set(offsetPos++ , aV);
			buffer.set(offsetPos++ , aRedMul);
			buffer.set(offsetPos++ , aGreenMul);
			buffer.set(offsetPos++ , aBlueMul);
			buffer.set(offsetPos++ , aAlphaMul);
			buffer.set(offsetPos++ , aRedAdd);
			buffer.set(offsetPos++ , aGreenAdd);
			buffer.set(offsetPos++ , aBlueAdd);
			buffer.set(offsetPos++ , aAlphaAdd);	
	}
	
	/* INTERFACE com.gEngine.display.IDraw */
	

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
	
	public function colorAdd(r:Float = 0, g:Float = 0, b:Float = 0, a:Float = 0):Void
	{
		addRed = r;
		addGreen = g;
		addBlue = b;
		addAlpha = a;
		colorTransform = overrideColorTransform();
	}
	public function colorMultiplication(r:Float = 1, g:Float = 1, b:Float = 1, a:Float = 1):Void
	{
		mulRed = r;
		mulGreen = g;
		mulBlue = b;
		mulAlpha = a;
		colorTransform = overrideColorTransform();
	}
	private inline function overrideColorTransform():Bool {
		return !(mulRed + mulGreen + mulBlue+mulAlpha == 0 &&
		addRed == 0 && addGreen == 0 && addBlue == 0 && addAlpha == 0);
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
	
	public function getDrawArea(aValue:MinMax):Void 
	{
		
		var a = scaleX * cosAng-sinAng*tanSkewY*scaleX;
		var b = scaleX * sinAng+cosAng*tanSkewY*scaleX;
		var c = -scaleY * sinAng+cosAng*tanSkewX*scaleY;
		var d = scaleY * cosAng + sinAng * tanSkewX * scaleY;
		
		var x = this.x+offsetX+pivotX;
		var y = this.y + offsetY + pivotY;
		
		var drawArea = mAnimationData.frames[CurrentFrame].drawArea;
		
		var matrix:FastMatrix3 = new FastMatrix3(a, c, x, b, d, y, 0, 0, 1);
		aValue.mergeVec(matrix.multvec(new FastVector2(   drawArea.x, drawArea.y)));
		aValue.mergeVec(matrix.multvec(new FastVector2(  drawArea.side,   drawArea.y)));
		aValue.mergeVec(matrix.multvec(new FastVector2( drawArea.x,  drawArea.up)));
		aValue.mergeVec(matrix.multvec(new FastVector2(  drawArea.side,   drawArea.up)));
	}
	public function localDrawArea():DrawArea
	{
		return mAnimationData.frames[CurrentFrame].drawArea;
	}
	
	public function transformArea(aInput:MinMax,aResult:MinMax):Void 
	{
		
		var a = scaleX * cosAng-sinAng*tanSkewY*scaleX;
		var b = scaleX * sinAng+cosAng*tanSkewY*scaleX;
		var c = -scaleY * sinAng+cosAng*tanSkewX*scaleY;
		var d = scaleY * cosAng + sinAng * tanSkewX * scaleY;
		
		var x = this.x+offsetX+pivotX;
		var y = this.y + offsetY + pivotY;
		
		
		var matrix:FastMatrix3 = new FastMatrix3(a, c, x, b, d, y, 0, 0, 1);
		aResult.mergeVec(matrix.multvec(new FastVector2(   aInput.min.x, aInput.min.y)));
		aResult.mergeVec(matrix.multvec(new FastVector2(  aInput.max.x,   aInput.min.y)));
		aResult.mergeVec(matrix.multvec(new FastVector2( aInput.min.x,  aInput.max.y)));
		aResult.mergeVec(matrix.multvec(new FastVector2(  aInput.max.x,   aInput.max.y)));
	}
	/* INTERFACE com.gEngine.display.IDraw */
	
}

