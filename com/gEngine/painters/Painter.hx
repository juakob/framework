package com.gEngine.painters;
import com.gEngine.display.Blend;
import com.gEngine.display.BlendMode;
import com.gEngine.display.DrawMode;
import com.gEngine.helper.Screen;
import com.helpers.MinMax;
import kha.Color;
import kha.Display;
import kha.FastFloat;
import kha.Shaders;
import kha.System;
import kha.arrays.Float32Array;
import kha.graphics4.BlendingOperation;
import kha.graphics4.Graphics;
import kha.graphics4.BlendingFactor;
import kha.graphics4.ConstantLocation;
import kha.graphics4.CullMode;
import kha.graphics4.IndexBuffer;
import kha.graphics4.MipMapFilter;
import kha.graphics4.PipelineState;
import kha.graphics4.TextureAddressing;
import kha.graphics4.TextureFilter;
import kha.graphics4.TextureUnit;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;

/**
 * ...
 * @author Joaquin
 */
class Painter implements IPainter
{
	var vertexBuffer1:VertexBuffer;
	var vertexBuffer2:VertexBuffer;
	var vertexBuffer:VertexBuffer;
	var indexBuffer:IndexBuffer;
	var pipeline:PipelineState;
	public var red:FastFloat = 0.;
	public var green:FastFloat = 0.;
	public var blue:FastFloat = 0.;
	public var alpha:FastFloat = 0.;
	public var MAX_VERTEX_PER_BUFFER:Int =2500;
	
	var dataPerVertex:Int = 4;
	var mMvpID:ConstantLocation;
	public var mTextureID:TextureUnit;
	
	public var resolution:Float = 1;
	
	var ratioIndexVertex:Float = 6 / 4;
	private var counter:Int=0;
	var buffer:Float32Array;
	public var textureID:Int = -1;
	
	var fullScreenWidth:Float;
	var fullScreenHeight:Float;
	
	var cropArea:MinMax;
	
	public function new(aAutoDestroy:Bool = true, aBlend:Blend=null) 
	{	
		if (aBlend == null) aBlend = Blend.blendDefault();
		if (aAutoDestroy) PainterGarbage.i.add(this);
		initShaders(aBlend);
		buffer = getVertexBuffer();
		mCustomBlend = false;
		fullScreenWidth = Screen.getWidth();
		fullScreenHeight = Screen.getHeight();
		cropArea = new MinMax();
		resetRenderArea();
	}
	public inline function write(aValue:Float):Void
	{
		buffer.set(counter++, aValue);
		
	}
	public inline function canDraw(aSize:Int):Bool
	{
		return (counter + aSize) <= MAX_VERTEX_PER_BUFFER;
	}
	public function start()
	{
		
	}
	public function finish()
	{
		
	}
	public function render(clear:Bool = false ):Void
	{
		if (counter == 0) return;
		
		
			var g = GEngine.i.currentCanvas().g4;
			// Begin rendering
			g.begin();
			g.scissor(Std.int(cropArea.min.x),Std.int(cropArea.min.y),Std.int(cropArea.max.x),Std.int(cropArea.max.y));
			uploadVertexBuffer();
			// Clear screen
			if(clear) g.clear(Color.fromFloats(red,green,blue,alpha));
			// Bind data we want to draw
			g.setVertexBuffer(vertexBuffer);
			g.setIndexBuffer(indexBuffer);

			// Bind state we want to draw with
			g.setPipeline(pipeline);

			setParameter(g);
			g.setTextureParameters(mTextureID, TextureAddressing.Clamp, TextureAddressing.Clamp, TextureFilter.LinearFilter, TextureFilter.LinearFilter, MipMapFilter.NoMipFilter);
			
			g.drawIndexedVertices(0, Std.int(vertexCount() * ratioIndexVertex)); 
			
			unsetTextures(g);
			// End rendering	
			if (vertex1)
			{
				vertex1 = false;
				vertexBuffer = vertexBuffer1;
			}else {
				vertex1 = true;
				vertexBuffer = vertexBuffer2;
			}
			buffer = getVertexBuffer();
			g.disableScissor();
			g.end();
			
			#if debugInfo
			++GEngine.drawCount;
			#end
			counter = 0;
	}
	public inline function vertexCount():Int
	{
		return Std.int(counter / dataPerVertex);
	}
	
	public function initShaders(aBlend:Blend):Void {
		
			pipeline = new PipelineState();
			setShaders(pipeline);
			
			var structure = new VertexStructure();
			defineVertexStructure(structure);
			pipeline.inputLayout = [structure];
			
			pipeline.cullMode = CullMode.None;
			
			setBlends(pipeline,aBlend);
			pipeline.compile();
			
			getConstantLocations(pipeline);
	
			vertexBuffer1=new VertexBuffer(
				MAX_VERTEX_PER_BUFFER,
				structure, 
				Usage.DynamicUsage 
				);
				vertexBuffer = vertexBuffer1;
				vertexBuffer2=new VertexBuffer(
				MAX_VERTEX_PER_BUFFER,
				structure, 
				Usage.DynamicUsage 
				);
	
	
			createIndexBuffer();
		}
		var vertex1:Bool = true;
		function getConstantLocations(aPipeline:PipelineState) 
		{
			mMvpID = aPipeline.getConstantLocation("projectionMatrix");
			mTextureID = aPipeline.getTextureUnit("tex");
		}
		function createIndexBuffer():Void
		{
			// Create index buffer
			indexBuffer = new IndexBuffer(
				Std.int(MAX_VERTEX_PER_BUFFER*6/4), 
				Usage.StaticUsage 
			);
			
			// Copy indices to index buffer
			var iData = indexBuffer.lock();
				for ( i in 0...Std.int( ( MAX_VERTEX_PER_BUFFER / 4 ) ) )
			{
				iData[i*6]=( (i * 4)+ 0 );
				iData[i*6+1]=( (i*4) + 1 );
				iData[i*6+2]=( (i * 4) + 2 );
				iData[i*6+3]=( (i * 4) + 1 );
				iData[i*6+4]=( (i * 4) + 2 );
				iData[i*6+5]=( (i * 4) + 3 );
			}
			indexBuffer.unlock();
		}
		private function setBlends(aPipeline:PipelineState, aBlend:Blend) 
		{
			aPipeline.blendSource = aBlend.blendSource;
			aPipeline.blendDestination = aBlend.blendDestination;
			aPipeline.alphaBlendSource = aBlend.alphaBlendSource;
			aPipeline.alphaBlendDestination = aBlend.alphaBlendDestination;
		}
		
		private function defineVertexStructure(structure:VertexStructure)
		{
			structure.add("vertexPosition", VertexData.Float2);
			structure.add("texPosition", VertexData.Float2);
		}
		
		private function setShaders(aPipeline:PipelineState):Void
		{
				aPipeline.vertexShader = Shaders.simple_vert;
				aPipeline.fragmentShader = Shaders.simple_frag;
		}
		private function setParameter(g:Graphics):Void
		{
			g.setMatrix(mMvpID, GEngine.i.getMatrix());

			g.setTexture(mTextureID, GEngine.i.mTextures[textureID]);
		}
		private function unsetTextures(g:Graphics):Void
		{
			g.setTexture(mTextureID, null);
		}
		inline function getVertexBuffer():Float32Array
		{
			return vertexBuffer.lock();
		}
		
		inline function uploadVertexBuffer():Void
		{
			vertexBuffer.unlock();
		}
		public function destroy():Void
		{
			//vertexBuffer.delete();
			//indexBuffer.delete();
			//pipeline.delete();
		}
		
		/* INTERFACE com.gEngine.painters.IPainter */
		var mCustomBlend:Bool = false;
		public function validateBatch(aTexture:Int, aSize:Int, aDrawMode:DrawMode, aBlend:BlendMode):Void 
		{
			if (aTexture != textureID || !canDraw(aSize)  )
			{
				render();
				textureID = aTexture;
			}
		}
		
		/* INTERFACE com.gEngine.painters.IPainter */
		
		public function releaseTexture():Bool 
		{
			return true;
		}
		
		/* INTERFACE com.gEngine.painters.IPainter */
		
		public function adjustRenderArea(aArea:MinMax):Void 
		{
			cropArea.min.x = aArea.min.x;
			cropArea.min.y = aArea.min.y;
			cropArea.max.x = aArea.max.x;
			cropArea.max.y = aArea.max.y;
		}
		public function resetRenderArea():Void {
			cropArea.min.x = 0;
			cropArea.min.y = 0;
			cropArea.max.x = fullScreenWidth;
			cropArea.max.y = fullScreenHeight;
		}
		
		
}