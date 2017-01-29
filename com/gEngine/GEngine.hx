package com.gEngine;

//import com.framework.utils.Input;

import com.framework.utils.SimpleProfiler;
import com.gEngine.display.AnimationSprite;
import com.gEngine.display.BasicSprite;
import com.gEngine.display.Batch;
import com.gEngine.display.BatchProxy;
import com.gEngine.painters.Painter;
import com.gEngine.painters.PainterAlpha;
import com.gEngine.painters.SpritePainter;
import com.gEngine.tempStructures.Bitmap;
import com.gEngine.tempStructures.UVLinker;
import com.gEngine.tempStructures.UVLinker;
import com.MyList;
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
		
		private function new() 
		{
			PainterGarbage.init();
			
			mResources = new EngineResources();
			mTextures = new MyList();
			mStage = new Stage();
			width = System.windowWidth();
			height = System.windowHeight();
			
			mTempBuffer = Image.createRenderTarget(width, height,null,DepthStencilFormat.NoDepthAndStencil,1);
			mTempBufferID = mTextures.push(mTempBuffer) - 1;
			
			mTempTarget = Image.createRenderTarget(width, height,null,DepthStencilFormat.NoDepthAndStencil,1);
			mTempTargetID = mTextures.push(mTempTarget) - 1;
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
		
			
			//tempToTempBuffMatrix = FastMatrix4.identity();
			//tempToTempBuffMatrix=tempToTempBuffMatrix.multmat(FastMatrix4.scale((2.0*renderScale) / width, -(2.0*renderScale) / height, 1));
			//tempToTempBuffMatrix = tempToTempBuffMatrix.multmat(FastMatrix4.translation( -width  / (2*renderScale), -height  / (2*renderScale), 0));
			//
			//tempToTempBuffMatrixMirrorY = FastMatrix4.identity();
			//tempToTempBuffMatrixMirrorY=tempToTempBuffMatrixMirrorY.multmat(FastMatrix4.scale((2.0*renderScale) / width, -(2.0*renderScale) / height, 1));
			//tempToTempBuffMatrixMirrorY = tempToTempBuffMatrixMirrorY.multmat(FastMatrix4.translation( -width / (2.0*renderScale), height/(2.0*renderScale), 0));
			//tempToTempBuffMatrixMirrorY = tempToTempBuffMatrixMirrorY.multmat(FastMatrix4.scale(1, -1, 1));
			
			width = Std.int(System.windowWidth());
			height = Std.int(System.windowHeight());
			
			finalViewMatrix = FastMatrix4.identity();
			finalViewMatrix=finalViewMatrix.multmat(FastMatrix4.scale(2.0 / width, -2.0 / height, 1));
			finalViewMatrix = finalViewMatrix.multmat(FastMatrix4.translation( -width / 2, -height / 2, 0));
			
			finalViewMatrixMirrorY = FastMatrix4.identity();
			finalViewMatrixMirrorY=finalViewMatrixMirrorY.multmat(FastMatrix4.scale(2.0 / width, -2.0 / height, 1));
			finalViewMatrixMirrorY = finalViewMatrixMirrorY.multmat(FastMatrix4.translation( -width / 2, height / 2, 0));
			finalViewMatrixMirrorY = finalViewMatrixMirrorY.multmat(FastMatrix4.scale(1, -1, 1));
			
			
			
			
			//modelViewMatrixMirrorY = modelViewMatrix;
			

			//width = System.windowWidth();
			//height = System.windowHeight();
			
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
			
		//	Input.inst.screenScale.setTo(1280 / width, 720/height);
			//if (mSprite!=null)
			//{
				//
			//	GEngine.i.width = width;
			//	GEngine.i.height = height ;
				//mSprite.scaleX = width/1280;
				//mSprite.scaleY = height/ 720;
			//}
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
		private var mTempTarget:Image;
		public var mTempTargetID:Int;
		private var renderToTemp:Bool;
		public var renderFinal:Bool;
		private var renderCustomBuffer:Bool;
		private var customBuffer:Image;
		
		public var scaleWidth:Float=1;
		public var scaleHeigth:Float=1;
		
		public function changeToTemp()
		{
			renderToTemp = true;
			renderCustomBuffer = false;
		}
	
		public function changeToBuffer()
		{
			renderToTemp = false;
			renderCustomBuffer = false;
		}
	
		public function setCanvas(aTarget:Image):Void
		{
			renderCustomBuffer = true;
			customBuffer = aTarget;
		}
		public function currentCanvas():Canvas
		{
			
			if (renderCustomBuffer)
			{
				return customBuffer;
			}
			if (renderToTemp)
			{
					return mTempTarget;
			}
			if (renderFinal)
			{
					return mFrameBuffer;
			}
			return mTempBuffer;
		}
		public var temp:Bool;
		private function getMatrix():FastMatrix4
		{
			if (temp)
			{
				if (mFrameBuffer.g4.renderTargetsInvertedY())
				{
					return tempToTempBuffMatrixMirrorY;
				}
				return tempToTempBuffMatrix;
			}
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
		public function renderTempToFrameBuffer(aPainter:Painter,x:Float,y:Float,sx:Float,sy:Float,sw:Float,sh:Float)
		{
			changeToBuffer();
			aPainter.textureID = mTempTargetID;
			if (renderToTemp&&mFrameBuffer.g4.renderTargetsInvertedY()) 
			{
				aPainter.write(x);
				aPainter.write(y);
				aPainter.write(0);
				aPainter.write(realV);
				
				aPainter.write(x+sw);
				aPainter.write(y);
				aPainter.write(realU);
				aPainter.write(realV);
				
				aPainter.write(x);
				aPainter.write(y+sh);
				aPainter.write(0);
				aPainter.write(0);
				
				aPainter.write(x+sw);
				aPainter.write(y+sh);
				aPainter.write(realU);
				aPainter.write(0);
			}else
			{
				aPainter.write(x);
				aPainter.write(y);
				aPainter.write(0);
				aPainter.write(0);
				
				aPainter.write(x+sw);
				aPainter.write(y);
				aPainter.write(realU);
				aPainter.write(0);
				
				aPainter.write(x);
				aPainter.write(y+sh);
				aPainter.write(0);
				aPainter.write(realV);
				
				aPainter.write(x+sw);
				aPainter.write(y+sh);
				aPainter.write(realU);
				aPainter.write(realV);
			}
			aPainter.render();
			
			
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
			
			//g = aFrameBuffer.g4;
			//g.begin();
			//if(clear)g.clear(Color.fromFloats(0.0, 0.0, 0.0,0), 0.0);
			//g.end();
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
	}


