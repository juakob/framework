package com.gEngine;

//import com.framework.utils.Input;

import com.framework.utils.Input;
import com.framework.utils.Resource.TextureProxy;
import com.framework.utils.SimpleProfiler;
import com.gEngine.display.AnimationSprite;
import com.gEngine.display.BasicSprite;
import com.gEngine.display.Batch;
import com.gEngine.display.BatchProxy;
import com.gEngine.display.Blend;
import com.gEngine.display.ComplexSprite;
import com.gEngine.display.extra.AnimationSpriteClone;
import com.gEngine.helper.RectangleDisplay;
import com.gEngine.helper.Screen;
import com.gEngine.painters.IPainter;
import com.gEngine.painters.Painter;
import com.gEngine.painters.PainterAlpha;
import com.gEngine.painters.SpritePainter;
import com.gEngine.shaders.ShBlurH;
import com.gEngine.shaders.ShBlurV;
import com.gEngine.tempStructures.Bitmap;
import com.gEngine.tempStructures.UVLinker;
import com.gEngine.tempStructures.UVLinker;
import com.MyList;
import com.helpers.CompilationConstatns;
import com.helpers.RenderTargetPool;
import com.imageAtlas.ImageTree;
import com.gEngine.display.Stage; 
import haxe.io.Bytes;
import haxe.io.BytesInput;
import kha.Canvas;
import kha.Display;
import kha.Shaders;
import kha.Window;
import kha.graphics4.BlendingFactor;
import kha.graphics4.DepthStencilFormat;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.graphics4.TextureFilter;

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
	@:allow(com.framework.utils.Resource)
	 class GEngine 
	{
		
		 public static var i(get, null):GEngine;
		 
		 private static function get_i():GEngine
		 {
			 return i;
		 }
		
		 public var width(default, null):Int;
		 public var height(default, null):Int;
		 public var realWidth(default, null):Int;
		 public var realHeight(default, null):Int;
		 public var realU:Float;
		 public var realV:Float;
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
		private var mSpritePainter:IPainter;
		inline static var initialIndex:Int = 2;
		var currentIndex:Int = initialIndex;
		
		var renderTargetPool:RenderTargetPool;
		
		var mCurrentRenderTargetId:Int =-1;
		
		#if debugInfo
			private var deltaTime:Float = 0.0;
			private var totalFrames:Int = 0;
			private var elapsedTime:Float = 0.0;
			private var previousTime:Float = 0.0;
			private var fps:Int = 0;
			public static var drawCount:Int = 0;
			private var font:kha.Font;
			public static var extraInfo:String = "";
			var fontLoaded:Bool;
		#end
		
		private function new(antiAlias:Int) 
		{
			clearColor = Color.fromFloats(0, 0, 0, 1);
			
			antiAliasing = antiAlias;
			
			Window.get(0).notifyOnResize(resize);
			
			PainterGarbage.init();
			
			renderTargetPool = new RenderTargetPool();
			
			mResources = new EngineResources();
			mTextures = new MyList();
			mStage = new Stage();

			//createBuffer(Screen.getWidth(), Screen.getHeight());
			trace(Screen.getWidth()+"  "+ Screen.getHeight());
			createBuffer( Screen.getWidth(),Screen.getHeight());
			
			var recTexture = Image.createRenderTarget(1, 1);
			recTexture.g2.begin(true, Color.Black);
			recTexture.g2.end();
			mTextures.push(recTexture);
			RectangleDisplay.init(1);

			shaderPipeline = new PipelineState();
			shaderPipeline.fragmentShader = Shaders.painter_image_frag;
			shaderPipeline.vertexShader = Shaders.painter_image_vert;

			var structure = new VertexStructure();
			structure.add("vertexPosition", VertexData.Float3);
			structure.add("texPosition", VertexData.Float2);
			structure.add("vertexColor", VertexData.Float4);
			shaderPipeline.inputLayout = [structure];
			
			shaderPipeline.blendSource = BlendingFactor.BlendOne;
			shaderPipeline.blendDestination = BlendingFactor.BlendZero;
			shaderPipeline.alphaBlendSource = BlendingFactor.BlendOne;
			shaderPipeline.alphaBlendDestination = BlendingFactor.BlendZero;
				
			shaderPipeline.compile();
			
		}
		function createBuffer(aWidth:Int, aHeight:Int):Bool
		{
			if (width == aWidth && height == aHeight) return false;
			width = aWidth;
			height = aHeight;
			if (mTempBuffer != null) mTempBuffer.unload();
			mTempBuffer = Image.createRenderTarget(width, height, null, DepthStencilFormat.NoDepthAndStencil, antiAliasing);
			if (mTextures.length == 0)
			{
				mCurrentRenderTargetId = mTempBufferID = mTextures.push(mTempBuffer) - 1;
			}else {
				mTextures[mTempBufferID] = mTempBuffer;	
			}
			
			realWidth = mTempBuffer.realWidth;
			realHeight = mTempBuffer.realHeight;
			
			var renderScale:Float = 1;
			realU =   width / realWidth ;
			realV =  height / realHeight ;
			
			scaleWidth =  1;//(width / realWidth   );
			scaleHeigth = 1;//(height / realHeight   ) ;
			#if flash
			scaleWidth =   (width / realWidth   );
			scaleHeigth =  (height / realHeight   ) ;
			#end
			
			trace(realWidth + "  " + realHeight+" width"+width+" height"+height);
			
			modelViewMatrix = FastMatrix4.identity();
			modelViewMatrix=modelViewMatrix.multmat(FastMatrix4.scale((2.0*renderScale) / virtualWidth*scaleWidth, -(2.0*renderScale) / virtualHeight*scaleHeigth, 1));
			modelViewMatrix = modelViewMatrix.multmat(FastMatrix4.translation( -virtualWidth / scaleWidth / (2*renderScale), -virtualHeight / scaleHeigth / (2*renderScale), 0));
			
			modelViewMatrixMirrorY = FastMatrix4.identity();
			modelViewMatrixMirrorY=modelViewMatrixMirrorY.multmat(FastMatrix4.scale((2.0*renderScale) / virtualWidth*scaleWidth, -(2.0*renderScale) / virtualHeight*scaleHeigth, 1));
			modelViewMatrixMirrorY = modelViewMatrixMirrorY.multmat(FastMatrix4.translation( -virtualWidth/scaleWidth / (2.0*renderScale), virtualHeight/scaleHeigth/(2.0*renderScale), 0));
			modelViewMatrixMirrorY = modelViewMatrixMirrorY.multmat(FastMatrix4.scale(1, -1, 1));
			
			finalViewMatrix = FastMatrix4.identity();
			finalViewMatrix=finalViewMatrix.multmat(FastMatrix4.scale(2.0 / width, -2.0 / height, 1));
			finalViewMatrix = finalViewMatrix.multmat(FastMatrix4.translation( -width / 2, -height / 2, 0));
			
			finalViewMatrixMirrorY = FastMatrix4.identity();
			finalViewMatrixMirrorY=finalViewMatrixMirrorY.multmat(FastMatrix4.scale(2.0 / width, -2.0 / height, 1));
			finalViewMatrixMirrorY = finalViewMatrixMirrorY.multmat(FastMatrix4.translation( -width / 2, height / 2, 0));
			finalViewMatrixMirrorY = finalViewMatrixMirrorY.multmat(FastMatrix4.scale(1, -1, 1));
			
			scaleWidth = width / virtualWidth;
			scaleHeigth = height / virtualHeight;
			
			return true;
			
		}
		public function createDefaultPainters():Void
		{
			mPainter = new Painter(false, Blend.blendNone());
			mPainter.filter = TextureFilter.PointFilter;
			mSpritePainter = new SpritePainter(false);
			
			blurX = new ShBlurH(false,1,Blend.blendDefault());
			blurY = new ShBlurV(false,1, Blend.blendDefault());
		}
		public static function init(antiAlias:Int):Void
		{	
			i = new GEngine(antiAlias);
			#if debugInfo
			Assets.loadFont("mainfont", setFont);
			#end
		}
		
		#if debugInfo
		static private function setFont(aFont:kha.Font) 
		{
			i.font = aFont;
			i.fontLoaded=true;
		}
		#end
		
		public function resize(availWidth:Int, availHeight:Int) 
		{
			if (availWidth == 0 || availWidth == 0) return;
			Input.i.screenScale.setTo(virtualWidth / availWidth, virtualHeight / availHeight);
			if (createBuffer(availWidth, availHeight)) {	
				adjustRenderTargets();
				trace("resize " + availWidth + " , " + availHeight);
			}
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
				#if debugInfo
				trace("animation loaded " + names[i]);
				#end
				mResources.addResource(names[i], frames[i], dummys[i], labels[i],textures[i],masks[i]);	
			}
			
			var totalComplexAnimations:Int = importer.complexAnimations.length;
			for ( j in 0...totalComplexAnimations) 
			{
				mResources.addComplexResource(importer.complexAnimations[j], importer.complexAnimationsChilds[j]);
			}
			return texturesToLoad;
		}
		public function addResource(name:String,frames:MyList<Frame>,dummys:MyList<MyList<Dummy>>,labels:MyList<Label>,textures:MyList<MyList<String>>,masks:MyList<MaskBatch>)
		{
			mResources.addResource(name, frames, dummys, labels, textures, masks);
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
		public function getNewRectangle(width:Float,height:Float):RectangleDisplay
		{
			var rectangle:RectangleDisplay = new RectangleDisplay();
			rectangle.scaleX = width;
			rectangle.scaleY = height;
			return rectangle;
		}
		public function getNewAnimationClone(name:String):AnimationSpriteClone
		{
			var animation:AnimationSpriteClone = new AnimationSpriteClone(mResources.getAnimationData(name));
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
		public function loadAnimationsToTexture(aTexture:TextureProxy):Image
		{
			var aAnimations:MyList<String> = aTexture.animations;
			var aWidth:Int = Std.int(aTexture.size.x);
			var aHeight:Int = Std.int(aTexture.size.y); 
			var aColor:Color = aTexture.color;
			var atlasImage:Image;
			var textureId:Int;
			var start:Int = currentIndex;
			for (i in start...mTextures.length) 
				{
					if (mTextures[i].width == aWidth && mTextures[i].height == aHeight) break;
					++currentIndex;
					
				}
			if (currentIndex < mTextures.length)
			{
				atlasImage = mTextures[currentIndex];
				textureId = currentIndex;
			}else {
				atlasImage = Image.createRenderTarget(aWidth, aHeight, TextureFormat.RGBA32,DepthStencilFormat.NoDepthAndStencil,0);
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
			
			for (atlas in aTexture.atlas)
			{
				simpleAnimations.push(atlas.name);
				for(bitmap in atlas.bitmaps){
					bitmaps.push(bitmap);
				}
			}
			
			bitmaps.sort(sortArea);
			var atlasMap = new ImageTree(aWidth, aHeight, 2);
			
			var linker:MyList<AnimationTilesheetLinker> = new MyList();
			var g = atlasImage.g2;
			
			
			
			g.pipeline = shaderPipeline;
			g.color = aColor;
			g.begin(true, 0x00000);
			
			for (bitmap in bitmaps) 
			{
				
				var rectangle = atlasMap.insertImage(bitmap);
				#if debug
				if (rectangle == null) {
					throw "not enough space on the atlas texture , atlas id " + textureId +", create another atlas";
				}
				#end
				g.drawSubImage(bitmap.image, rectangle.x, rectangle.y, bitmap.x, bitmap.y, bitmap.width, bitmap.height);
				rectangle.x-=1;
				rectangle.y-=1;
				
				rectangle.width -= 2;
				rectangle.height-=2;
				linker.push(new AnimationTilesheetLinker(bitmap.name, rectangle, aWidth, aHeight));
				
			}
			
			g.end();
			//var img = Image.createRenderTarget(1, 1, TextureFormat.RGBA32,DepthStencilFormat.DepthOnly);
			//img.unload();
			for (animation in simpleAnimations) 
			{
				mResources.linkAnimationToTexture(animation,textureId, linker);
			}
			atlasImage.generateMipmaps(4);
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
		var shaderPipeline:kha.graphics4.PipelineState;
		private  var antiAliasing:Int = 4;
		
		public static inline var virtualWidth:Float=CompilationConstatns.getWidth();
		public static inline var virtualHeight:Float=CompilationConstatns.getHeight();
		static inline public var backBufferId=0;
		
		public var scaleWidth:Float=1;
		public var scaleHeigth:Float=1;
		public var blurX:ShBlurH;
		public var blurY:ShBlurV;
		
		public var clearColor:Color;
	
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
		public function getMatrix():FastMatrix4
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
		public function renderBuffer(aSource:Int,aPainter:IPainter,x:Float,y:Float,aWidth:Float,aHeight:Float,aSourceScale:Float,aClear:Bool,aOutScale:Float=1)
		{
			aPainter.textureID = aSource;
			var tex = mTextures[aSource];
			var texWidth = tex.realWidth*aSourceScale*1/scaleWidth;
			var texHeight = tex.realHeight*aSourceScale*1/scaleHeigth;
			
			writeVertex(aPainter,x, y,texWidth,texHeight,aOutScale);

			writeVertex(aPainter,x+aWidth, y,texWidth,texHeight,aOutScale);
				
			writeVertex(aPainter,x, y+aHeight,texWidth,texHeight,aOutScale);

			writeVertex(aPainter,x+aWidth, y+aHeight,texWidth,texHeight,aOutScale);
			
			aPainter.render(aClear);
		}
		public  inline function  writeVertex(aPainter:IPainter,aX:Float,aY:Float,aSWidth:Float,aSHeight:Float,aResolution:Float) {
				aPainter.write(aX*aResolution);
				aPainter.write(aY*aResolution);
				aPainter.write(aX/aSWidth);
				aPainter.write(aY/aSHeight);	
		}
	
		public function getTexture(aId:Int):Image
		{
			return mTextures[aId];
		}
		
		public function update(elapsedTime:Float):Void
		{
			mStage.update(elapsedTime);
		}
		
		public function draw(aFrameBuffer:Framebuffer,clear:Bool=true):Void
		{
			//if (aFrameBuffer.width != width || aFrameBuffer.height != height) resize(aFrameBuffer.width, aFrameBuffer.height);
			#if debugInfo
			var currentTime:Float = kha.Scheduler.realTime();
			deltaTime = (currentTime - previousTime);
			
			elapsedTime += deltaTime;
			if (elapsedTime >= 1.0) {
				fps = totalFrames;
				totalFrames = 0;
				elapsedTime = 0;
				
			}
			totalFrames++;
			 previousTime = currentTime;
			#end
			mFrameBuffer = aFrameBuffer;
			if(mTempBuffer==null)return;
			var g = mTempBuffer.g4;
			
			// Begin rendering
			g.begin();
			if(clear)g.clear(clearColor);
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
			
			#if debugInfo
			if(fontLoaded){
				aFrameBuffer.g2.font = font;
				aFrameBuffer.g2.fontSize = 16;
				aFrameBuffer.g2.color = 0xFF000000;
				aFrameBuffer.g2.fillRect(0, 0, 300, 20);
				aFrameBuffer.g2.color = 0xFFFFFFFF;
				aFrameBuffer.g2.drawString("drawCount: " + drawCount + "         fps: " + fps +"\n"+extraInfo, 10, 2);
				aFrameBuffer.g2.end();
			}
			drawCount = 0;
			#end
			
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
				var target:Image = Image.createRenderTarget(width, height,null,DepthStencilFormat.NoDepthAndStencil,antiAliasing);
				id = mTextures.push(target) - 1;
				renderTargetPool.addRenderTarget(id);
			}
			return id;
		}
		public function releaseRenderTarget(aId:Int) 
		{
			renderTargetPool.release(aId);
		}
		public function adjustRenderTargets():Void
		{
			for (proxy in renderTargetPool.targets) {
				mTextures[proxy.textureId].unload();
				mTextures[proxy.textureId]= Image.createRenderTarget(width, height,null,DepthStencilFormat.NoDepthAndStencil,antiAliasing);
			}
		}
		
		private function sortArea(b1:Bitmap, b2:Bitmap):Int
		{
			return Std.int((b2.width * b2.height) - (b1.width * b1.height));
		}
		
		public function destroy():Void 
		{	
			mResources.clear();
			mStage = new Stage();
			currentIndex = initialIndex;
			PainterGarbage.i.clear();
			renderTargetPool.releaseAll();
		}
		
		public function swapBuffer(aA:Int, aB:Int) 
		{
			var temp:Image = mTextures[aA];
			mTextures[aA] = mTextures[aB];
			mTextures[aB] = temp;
		}
		
		
		
		
	}


