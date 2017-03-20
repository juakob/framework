package com.gEngine;

//import com.framework.utils.Input;

import com.framework.utils.SimpleProfiler;
import com.gEngine.display.AnimationSprite;
import com.gEngine.display.BasicSprite;
import com.gEngine.display.Batch;
import com.gEngine.display.BatchProxy;
import com.gEngine.display.ComplexSprite;
import com.gEngine.painters.IPainter;
import com.gEngine.painters.Painter;
import com.gEngine.painters.PainterAlpha;
import com.gEngine.painters.SpritePainter;
import com.gEngine.tempStructures.Bitmap;
import com.gEngine.tempStructures.UVLinker;
import com.gEngine.tempStructures.UVLinker;
import com.MyList;
import com.helpers.RenderTargetPool;
import com.imageAtlas.ImageTree;
import com.gEngine.display.Stage; 
import haxe.io.Bytes;
import haxe.io.BytesInput;
import kha.Canvas;
import kha.graphics4.DepthStencilFormat;

import kha.Color;
import kha.Framebuffer;
import kha.graphics4.TextureFormat;
import kha.math.FastMatrix4;



import com.gEngine.display.IDraw;
import kha.Assets;
import kha.Blob;
import kha.Image;
import kha.System;

	/**
	 * ...
	 * @author joaquin
	 */
	@:allow(com.gEngine.painters.Painter)
	 class GEngine 
	{
		
		 public static var i(get, null):GEngine;
		 #if debug
		 private static var initialized:Bool;
		 #end
		 private static function get_i():GEngine
		 {
			 return i;
		 }
		
		 public var width(default, null):Int;
		 public var height(default, null):Int;
		 public var realWidth(default, null):Int;
		 public var realHeight(default, null):Int;
		 private var realU:Float;
		 private var realV:Float;
		private var mResources:EngineResources;
		private var mTextures:MyList<Image>;
		private var mStage:Stage;
		var modelViewMatrix:FastMatrix4;
		var modelViewMatrixMirrorY:FastMatrix4;
		var tempToTempBuffMatrix:FastMatrix4;
		var tempToTempBuffMatrixMirrorY:FastMatrix4;
		var finalViewMatrix:FastMatrix4;
		var finalViewMatrixMirrorY:FastMatrix4;
		private var mPainter:Painter;
		private var mSpritePainter:SpritePainter;
		inline static var initialIndex:Int = 2;
		var currentIndex:Int = initialIndex;
		
		var renderTargetPool:RenderTargetPool;
		
		var mCurrentRenderTargetId:Int=-1;
		
		private function new() 
		{
			PainterGarbage.init();
			
			renderTargetPool = new RenderTargetPool();
			
			mResources = new EngineResources();
			mTextures = new MyList();
			mStage = new Stage();
			width = System.windowWidth();
			height = System.windowHeight();
			
			mTempBuffer = Image.createRenderTarget(width, height, null, DepthStencilFormat.NoDepthAndStencil, 1);
			mCurrentRenderTargetId=mTempBufferID = mTextures.push(mTempBuffer) - 1;
			
			mPainter = new Painter(false);
			mSpritePainter = new SpritePainter(false);
			
			width = Std.int(width);
			height = Std.int(height);
			
			realWidth = mTempBuffer.realWidth;
			realHeight = mTempBuffer.realHeight;
			
			#if flash
			realWidth = width;
			realHeight = height;
			#end
			
			
			var renderScale:Float = 1;
			scaleWidth = width / 1280;
			scaleHeigth = height / 720;
			
			modelViewMatrix = FastMatrix4.identity();
			modelViewMatrix=modelViewMatrix.multmat(FastMatrix4.scale((2.0*renderScale) / width*scaleWidth, -(2.0*renderScale) / height*scaleHeigth, 1));
			modelViewMatrix = modelViewMatrix.multmat(FastMatrix4.translation( -width / scaleWidth / (2*renderScale), -height / scaleHeigth / (2*renderScale), 0));
			
			modelViewMatrixMirrorY = FastMatrix4.identity();
			modelViewMatrixMirrorY=modelViewMatrixMirrorY.multmat(FastMatrix4.scale((2.0*renderScale) / width*scaleWidth, -(2.0*renderScale) / height*scaleHeigth, 1));
			modelViewMatrixMirrorY = modelViewMatrixMirrorY.multmat(FastMatrix4.translation( -width/scaleWidth / (2.0*renderScale), height/scaleHeigth/(2.0*renderScale), 0));
			modelViewMatrixMirrorY = modelViewMatrixMirrorY.multmat(FastMatrix4.scale(1, -1, 1));
		
			
			width = Std.int(System.windowWidth());
			height = Std.int(System.windowHeight());
			
			finalViewMatrix = FastMatrix4.identity();
			finalViewMatrix=finalViewMatrix.multmat(FastMatrix4.scale(2.0 / width, -2.0 / height, 1));
			finalViewMatrix = finalViewMatrix.multmat(FastMatrix4.translation( -width / 2, -height / 2, 0));
			
			finalViewMatrixMirrorY = FastMatrix4.identity();
			finalViewMatrixMirrorY=finalViewMatrixMirrorY.multmat(FastMatrix4.scale(2.0 / width, -2.0 / height, 1));
			finalViewMatrixMirrorY = finalViewMatrixMirrorY.multmat(FastMatrix4.translation( -width / 2, height / 2, 0));
			finalViewMatrixMirrorY = finalViewMatrixMirrorY.multmat(FastMatrix4.scale(1, -1, 1));
			

			
			realU =  width*renderScale / realWidth ;
			realV =  height*renderScale /realHeight ;
			
			
		}
		public static function init():Void
		{
			i = new GEngine();
			 #if debug
			initialized = true;
			#end
			resize();
			
		}
		
		
		static private inline function  resize():Void
		{
			var width:Int = System.windowWidth();
			var height:Int = System.windowHeight();
		}
	
		public function addResources(data:Blob):Array<String>
		{
			var importer:Importer = new Importer();
			importer.decompile(data);
			
			var names:MyList<String> = importer.names;
			var frames:MyList<MyList<Frame>> = importer.frameData;
			var labels:MyList<MyList<Label>> = importer.animationLabels;
			var dummys:MyList<MyList<MyList<Dummy>>> = importer.dummys;
			var textures:MyList<MyList<MyList<String>>> = importer.textures;
			var masks:MyList<MyList<MaskBatch>> = importer.masksBatchs;
			/// loading 
			var texturesToLoad:Array<String> = new Array();
			for (animationTextures in importer.animationsTextures)
			{
				for (texture in animationTextures) 
				{
					texturesToLoad.push(texture);
				}
				
			}
			for (maskTexture in importer.maskTextures) 
			{
				texturesToLoad.push(maskTexture);
			}
			////
			
			for (i in 0...names.length)
			{
				trace("animation loaded " + names[i]);
				mResources.addResource(names[i], frames[i], dummys[i], labels[i],textures[i],masks[i]);	
			}
			
			var totalComplexAnimations:Int = importer.complexAnimations.length;
			for ( j in 0...totalComplexAnimations) 
			{
				mResources.addComplexResource(importer.complexAnimations[j], importer.complexAnimationsChilds[j]);
			}
			return texturesToLoad;
		}
	
		public function getNewSprite(name:String):BasicSprite
		{
			var animation:BasicSprite = new BasicSprite(mResources.getAnimationData(name));
			return animation;
		}
		
		public function getNewAnimation(name:String):AnimationSprite
		{
			var animation:AnimationSprite = new AnimationSprite(mResources.getAnimationData(name));
			return animation;
		}
		public function getNewComplexSprite(name:String):ComplexSprite
		{
			var animation:ComplexSprite = new ComplexSprite(mResources.getAnimationData(name));
			return animation;
		}
		
		public function getComplexAnimations(name:String):MyList<String>
		{
			var id:Int = mResources.getComplexAnimationId(name);
			#if debug
				if (id == -1)
				{
					throw "Complex Animation " + name+ " not found ";
				}
			#end
			return mResources.getChilds(id);
		}
		public function loadAnimationsToTexture(aAnimations:MyList<String>,aWidth:Int,aHeight:Int):Image
		{
			
			var atlasImage:Image;
			var textureId:Int;
			if (currentIndex < mTextures.length)
			{
				atlasImage = mTextures[currentIndex];
				textureId = currentIndex;
				
			}else {
				atlasImage = Image.createRenderTarget(2048, 2048, TextureFormat.RGBA32);
				textureId = mTextures.push(atlasImage) - 1;
				
				
			}
			
			++currentIndex;
			
			var imagesNames:MyList<String> = new MyList();
			
			var simpleAnimations:MyList<String> = new MyList();
			for (animation in aAnimations)
			{
				var complexId = mResources.getComplexAnimationId(animation);
				if (complexId>=0) {
					var childrenNames = mResources.getChilds(complexId);
					for (child in childrenNames) 
					{
						var uvLink = mResources.getTextureLinker(child);
						extractImageNames(uvLink, imagesNames);
						simpleAnimations.push(child);
					}
				}else{
					var uvLink = mResources.getTextureLinker(animation);
					extractImageNames(uvLink, imagesNames);
					simpleAnimations.push(animation);
				}
			}
			
			var bitmaps = getBitmaps(imagesNames);
			bitmaps.sort(sortArea);
			var atlasMap = new ImageTree(aWidth, aHeight, 1);
			
			var linker:MyList<AnimationTilesheetLinker> = new MyList();
			var g = atlasImage.g2;
			g.begin(true,0);

			var once:Bool = true;
			for (bitmap in bitmaps) 
			{
				
				var rectangle = atlasMap.insertImage(bitmap);
				g.drawImage(bitmap.image, rectangle.x, rectangle.y);
				rectangle.x+=1;
				rectangle.y+=1;
				rectangle.width -= 4;
				rectangle.height-=4;
				linker.push(new AnimationTilesheetLinker(bitmap.name, rectangle, aWidth, aHeight));
				
			}
			g.end();
			
			var img = Image.createRenderTarget(1, 1, TextureFormat.RGBA32);
			img.unload();
			for (animation in simpleAnimations) 
			{
				mResources.linkAnimationToTexture(animation,textureId, linker);
			}
			
			return atlasImage;
		}
	
		
		private inline function extractImageNames(linker:UVLinker, images:MyList<String>):Void
		{
			for (frame in linker.texturesNames) 
			{
				for (texture in frame)
				{
					if (images.indexOf(texture) == -1)
					{
						images.push(texture);
					}
				}
			}
			for (maskBatch in linker.masks) 
			{
				if (images.indexOf(maskBatch.maskId) == -1)
				{
					images.push(maskBatch.maskId);
				}
				for (masked in maskBatch.textures) 
				{
					if (images.indexOf(masked) == -1)
					{
						images.push(masked);
					}
				}
			}
		}
		
		private var mFrameBuffer:Framebuffer;
		private var mTempBuffer:Image;
		public var mTempBufferID:Int;

		public var renderFinal:Bool;
		private var renderCustomBuffer:Bool;
		private var customBuffer:Image;
		
		public var scaleWidth:Float=1;
		public var scaleHeigth:Float=1;
		
	
		public function changeToBuffer()
		{
			mCurrentRenderTargetId = mTempBufferID;
			renderCustomBuffer = false;
		}
	
		public function setCanvas(aId:Int):Void
		{
			mCurrentRenderTargetId = aId;
			if (mCurrentRenderTargetId != mTempBufferID)
			{
			renderCustomBuffer = true;
			customBuffer = mTextures[aId];
			}else
			{
				changeToBuffer();
			}
			
		}
		public inline function currentCanvasId():Int
		{
			return mCurrentRenderTargetId;
		}
		public function currentCanvas():Canvas
		{
			if (renderCustomBuffer)
			{
				return customBuffer;
			}
			if (renderFinal)
			{
					return mFrameBuffer;
			}
			return mTempBuffer;
		}
		private function getMatrix():FastMatrix4
		{
			if (renderFinal)
			{
				if (mFrameBuffer.g4.renderTargetsInvertedY())
				{
					return finalViewMatrixMirrorY;
				}
				return finalViewMatrix;
			}
			if (mFrameBuffer.g4.renderTargetsInvertedY())
			{
				return modelViewMatrixMirrorY;
			}
			return modelViewMatrix;
		}
		public function renderBuffer(aSource:Int,aPainter:IPainter,x:Float,y:Float,aWidth:Float,aHeight:Float,aTexWidth:Float,aTexHeight:Float,aClear:Bool)
		{
			aPainter.textureID = aSource;
			if (mFrameBuffer.g4.renderTargetsInvertedY()) 
			{
				//aPainter.write(x);
				//aPainter.write(y);
				//aPainter.write();
				//aPainter.write(realV);
				//
				//aPainter.write(x+aWidth);
				//aPainter.write(y);
				//aPainter.write(realU);
				//aPainter.write(realV);
				//
				//aPainter.write(x);
				//aPainter.write(y+aHeight);
				//aPainter.write(0);
				//aPainter.write(0);
				//
				//aPainter.write(x+aWidth);
				//aPainter.write(y+aHeight);
				//aPainter.write(realU);
				//aPainter.write(0);
			}else
			{
				//aPainter.write(x);
				//aPainter.write(y);
				//aPainter.write(0);
				//aPainter.write(0);
				writeVertex(aPainter,x, y,aTexWidth,aTexHeight);
				
				//aPainter.write(x+aWidth);
				//aPainter.write(y);
				//aPainter.write(realU);
				//aPainter.write(0);
				writeVertex(aPainter,x+aWidth, y,aTexWidth,aTexHeight);
				
				//aPainter.write(x);
				//aPainter.write(y+aHeight);
				//aPainter.write(0);
				//aPainter.write(realV);
				writeVertex(aPainter,x, y+aHeight,aTexWidth,aTexHeight);
				
				//aPainter.write(x+aWidth);
				//aPainter.write(y+aHeight);
				//aPainter.write(realU);
				//aPainter.write(realV);
				writeVertex(aPainter,x+aWidth, y+aHeight,aTexWidth,aTexHeight);
			}
			aPainter.render(aClear);
			
			
		}
		inline function  writeVertex(aPainter:IPainter,aX:Float,aY:Float,aSWidth:Float,aSHeight:Float) {
				aPainter.write(aX);
				aPainter.write(aY);
				aPainter.write(aX/aSWidth);
				aPainter.write(aY/aSHeight);	
		}
	
		private function getTexture(aId:Int):Image
		{
			return mTextures[aId];
		}
		public function render(painter:Painter) :Void
		{	
			++drawCounter;
		}
		public function update(elapsedTime:Float):Void
		{
			mStage.update(elapsedTime);
		}
		
		
		public var drawCounter:Int = 0;
		public function draw(aFrameBuffer:Framebuffer,clear:Bool=true):Void
		{
			
			mFrameBuffer = aFrameBuffer;
			drawCounter = 0;
			
			var g = mTempBuffer.g4;

			// Begin rendering
			g.begin();
			if(clear)g.clear(Color.fromFloats(0.0, 0.0,0.0,0),0.0);
			g.end();
			mStage.render(mSpritePainter);
			
			mPainter.textureID = mTempBufferID;
			renderFinal = true;
			if (mFrameBuffer.g4.renderTargetsInvertedY())
			{
				mPainter.write(0);
				mPainter.write(0);
				mPainter.write(0);
				mPainter.write(realV);
					
				mPainter.write(width);
				mPainter.write(0);
				mPainter.write(realU);
				mPainter.write(realV);
					
				mPainter.write(0);
				mPainter.write(height);
				mPainter.write(0);
				mPainter.write(0);
					
				mPainter.write(width);
				mPainter.write(height);
				mPainter.write(realU);
				mPainter.write(0);
			}else{
				mPainter.write(0);
				mPainter.write(0);
				mPainter.write(0);
				mPainter.write(0);
					
				mPainter.write(width);
				mPainter.write(0);
				mPainter.write(realU);
				mPainter.write(0);
					
				mPainter.write(0);
				mPainter.write(height);
				mPainter.write(0);
				mPainter.write(realV);
					
				mPainter.write(width);
				mPainter.write(height);
				mPainter.write(realU);
				mPainter.write(realV);
			}
			mPainter.render(true);
			renderFinal = false;
			
		}
		public function addChild(draw:IDraw):Void
		{
			mStage.addChild(draw);
		}
		private function getBitmaps(aTextures:MyList<String>):MyList<Bitmap>
		{
			
			var images:MyList<Bitmap> = new MyList();
			var bitmap:Bitmap;
			var name:String;
			for ( j in 0...aTextures.length) 
			{
				name = aTextures[j];
				bitmap = new Bitmap();
				bitmap.image = Reflect.field(kha.Assets.images, name);
				bitmap.name = name;
				bitmap.width = bitmap.image.width;
				bitmap.height = bitmap.image.height;
			
				images.push(bitmap);
			}
			return images;
		}
		
		public function getRenderTarget():Int
		{
			var id:Int = renderTargetPool.getFreeImageId();
			if (id ==-1)
			{
				var target:Image = Image.createRenderTarget(width, height,null,DepthStencilFormat.NoDepthAndStencil,1);
				id = mTextures.push(target) - 1;
				renderTargetPool.addRenderTarget(id);
			}
			return id;
		}
		
	
		private function sortArea(b1:Bitmap, b2:Bitmap):Int
		{
			return Std.int((b2.width * b2.height) - (b1.width * b1.height));
		}
		
		public function destroy():Void 
		{
			mResources.clear();
			mStage = null;
			mStage = new Stage();
			currentIndex = initialIndex;
			PainterGarbage.i.clear();
		}
		
		public function releaseRenderTarget(aId:Int) 
		{
			renderTargetPool.release(aId);
		}
	}


