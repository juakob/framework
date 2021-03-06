package com.gEngine.display;

import com.gEngine.AnimationData;
import com.gEngine.Dummy;
import com.gEngine.painters.IPainter;
import com.helpers.Matrix;
import com.helpers.MinMax;
import kha.FastFloat;
import kha.math.FastMatrix3;
import kha.math.FastVector2;

/**
 * ...
 * @author Joaquin
 */

class ComplexSprite extends AnimationSprite
{
	private var mChildren:Array<DisplayDummyLink>;
	private var mChildBatch:Array<ChildBatch>;
	private var mTmatrix:Matrix = new Matrix();
	
	var mMaskStart:Int;
	var mChildStart:Int;
	public function new(aAnimationData:AnimationData) 
	{
		super(aAnimationData);
		mChildren = new Array();
		mChildBatch = new Array();

	} 
	public function addChild(display:IDraw, aDummyName:String)
	{
		mChildren.push(new DisplayDummyLink(display, aDummyName));
	}
	public function removeChild( aDummyName:String)
	{
		var index:Int=0;
		for (i in 0...mChildren.length)
		{
			if (mChildren[i].dummyName == aDummyName) {
				index = i;
				break;
			}
		}
		mChildren.splice(index,1);
	}
	override public  function render(painter:IPainter,transform:Matrix):Void
	{
		if (!visible)
		{
			return;
		}
		x += offsetX + pivotX;
		y += offsetY + pivotY;
		
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
		if (interpolateFrames &&   CurrentFrame<TotalFrames-1 && mAnimationData.frames[CurrentFrame+1].canInterpolate )
		{
			vertexs = BasicSprite.interpolateFrame(CurrentFrame, mCurrentTime, frameRate, mAnimationData.frames);
		}else {
			 vertexs= frame.vertexs;
		}
		
		var uvs = frame.UVs;
		var alphas = frame.alphas;
		var colorTrans = frame.colortTransform;
		var stuffToDraw:Int = Std.int(vertexs.length / 8) + frame.maskBatchs.length;
		var counter:Int = 0;
		var maskCounter:Int = 0;
		var childCounter:Int = 0;
		var normalCounter:Int = 0;
		var drawMask:Bool = false;
		
		mMaskStart =mChildStart = -1;
		
		mChildBatch.splice(0, mChildBatch.length);
		for(display in mChildren)
		{
			var dummy:Dummy = getDummy(display.dummyName);
			if (dummy != null)
			{
				mChildBatch.push(new ChildBatch(dummy, display.animation));
				++stuffToDraw;
			}
		}
		counter = Std.int(vertexs.length / 8);
		var lastMask:Int =-1;
		var lastChild:Int =-1;
		var drawOrderCounter:Int = 0;
		do {
			
			if (frame.maskBatchs.length > maskCounter)
			{
				mMaskStart = frame.maskBatchs[maskCounter].start;
				var dif = mMaskStart - normalCounter;
				if (counter > dif||mChildBatch.length ==childCounter) counter = dif;
			}
				if (mChildBatch.length >childCounter)
			{
				mChildStart = mChildBatch[childCounter].dummy.drawIndex ;
				var dif = mChildStart - normalCounter;
				if (counter > dif||frame.maskBatchs.length == maskCounter) counter = dif;
			}
			
			if (mMaskStart==drawOrderCounter && lastMask!=mMaskStart)
			{
				--stuffToDraw;
				++drawOrderCounter;
				var maskBatch:MaskBatch = frame.maskBatchs[maskCounter];
				painter.validateBatch(mTextureId, Std.int(maskBatch.vertex.length/2), DrawMode.Mask,blend,textureFilter,mipMapFilter);
				
				var polygons = maskBatch.vertex;
				var polyUvs = maskBatch.uvs;
				var maskUvs = maskBatch.maskUvs;
				
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
				lastMask = mMaskStart;
				++maskCounter;
				
			}
			
			if (mChildStart == drawOrderCounter && lastChild!=mChildStart)
			{
				++drawOrderCounter;
				var dummy = mChildBatch[childCounter].dummy;
				mTmatrix.identity();
				mTmatrix.a = dummy.matrix.a *_1 +dummy.matrix.b*_3;//new a
				mTmatrix.b = dummy.matrix.a*_2+dummy.matrix.b*_4;//new b
				mTmatrix.c = dummy.matrix.c * _1 +dummy.matrix.d *_3;//new c
				mTmatrix.d = dummy.matrix.c*_2+dummy.matrix.d*_4;//new d
				

				mTmatrix.tx = dummy.matrix.tx * _1 + dummy.matrix.ty * _3 + _tx;
				mTmatrix.ty = dummy.matrix.tx * _2 + dummy.matrix.ty * _4 +_ty;
				
				mChildBatch[childCounter].display.render(painter, mTmatrix);
				
				lastChild = mChildStart;
				++childCounter;
				--stuffToDraw;
			}
			
			if (counter < normalCounter)
			{
				counter = normalCounter;
			}
			
			if(mChildBatch.length ==childCounter && frame.maskBatchs.length == maskCounter)//no more masks and no more children
			{
				counter= Std.int(vertexs.length / 8);//draw the rest
			}
			var drawMode:DrawMode = DrawMode.Default;
			if (alphas.length != 0) drawMode = DrawMode.Alpha;
			if (colorTrans.length!=0) drawMode = DrawMode.ColorTint;
			
			painter.validateBatch(mTextureId, Std.int(frame.vertexs.length / 8 + frame.UVs.length / 8),drawMode,blend,textureFilter,mipMapFilter);
			
			
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
			
			stuffToDraw -= counter-normalCounter;
			drawOrderCounter += counter-normalCounter;
			normalCounter += counter-normalCounter;
		}while (stuffToDraw > 0);
		x -= offsetX+pivotX;
		y -= offsetY+pivotY;
	}
	public override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		for (child in mChildren) 
		{
			child.animation.update(elapsed);
		}
	}
	public override function getDrawArea(aValue:MinMax):Void 
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
		
		for(display in mChildren)
		{
			var dummy:Dummy = getDummy(display.dummyName);
			if (dummy == null) continue;

			
			a = dummy.matrix.a *a +dummy.matrix.b*c;
			b = dummy.matrix.a*b+dummy.matrix.b*d;
			c = dummy.matrix.c *a +dummy.matrix.d *c;
			d = dummy.matrix.c*b+dummy.matrix.d*d;
			

			var tx = dummy.matrix.tx * a+ dummy.matrix.ty * c + x;
			var ty = dummy.matrix.tx * b + dummy.matrix.ty * d + y;

			matrix = new FastMatrix3(a, c, tx, b, d, ty, 0, 0, 1);
			var childArea = MinMax.weak;
			childArea.reset();
			display.animation.getDrawArea(childArea);
			aValue.mergeVec(matrix.multvec(new FastVector2(   childArea.min.x, childArea.min.y)));
			aValue.mergeVec(matrix.multvec(new FastVector2(  childArea.max.x,   childArea.min.y)));
			aValue.mergeVec(matrix.multvec(new FastVector2( childArea.min.x,  childArea.max.y)));
			aValue.mergeVec(matrix.multvec(new FastVector2(  childArea.max.x,   childArea.max.y)));
		}
	}
	
}

class DisplayDummyLink
{
	public var animation:IDraw;
	public var dummyName:String;
	public function new(aAnimation:IDraw, aDummyName:String)
	{
		animation = aAnimation;
		dummyName = aDummyName;
	}
}
class ChildBatch
{
	public var dummy:Dummy;
	public var display:IDraw;
	public function new (aDummy:Dummy, aDisplay:IDraw)
	{
		dummy = aDummy;
		display = aDisplay;
	}
}