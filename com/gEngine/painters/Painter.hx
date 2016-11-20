package com.gEngine.painters;
import kha.Color;
import kha.Shaders;
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
	var vertexBuffer:VertexBuffer;
	var indexBuffer:IndexBuffer;
	var pipeline:PipelineState;
	public var MAX_VERTEX_PER_BUFFER:Int =1500;
	
	var dataPerVertex:Int = 4;
	var mMvpID:ConstantLocation;
	public var mTextureID:TextureUnit;
	
	var ratioIndexVertex:Float = 6 / 4;
	private var counter:Int=0;
	var buffer:Float32Array;
	public var textureID:Int = -1;
	public function new(aAutoDestroy:Bool = true) 
	{
		if (aAutoDestroy) PainterGarbage.i.add(this);
		initShaders();
		buffer = getVertexBuffer();
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
			uploadVertexBuffer();
			// Clear screen
			if(clear) g.clear(Color.fromFloats(0.0, 0.0, 0.0,0));
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
			buffer = getVertexBuffer();
			g.end();
		
		
	
		counter = 0;
	}
	public function vertexCount():Int
	{
		return Std.int(counter / dataPerVertex);
	}
	
	public function initShaders():Void {
			//structure = new VertexStructure();
			//structure.add("pos", VertexData.Float2);
			//structure.add("uv", VertexData.Float2);
			

			
			// Save length - we store position and uv data
			
	
			// Compile pipeline state
			// Shaders are located in 'Sources/Shaders' directory
			// and Kha includes them automatically
			pipeline = new PipelineState();
			setShaders(pipeline);
			
			var structure = new VertexStructure();
			defineVertexStructure(structure);
			pipeline.inputLayout = [structure];
			
			// Set depth mode
			//    pipeline.depthWrite = true;
				
			//    pipeline.depthMode = CompareMode.Always;
			pipeline.cullMode = CullMode.None;
			
			setBlends(pipeline);
			pipeline.compile();
			
	
			// Get a handle for our "MVP" uniform
			//mvpID = pipeline.getConstantLocation("MVP");
	//
			//// Get a handle for texture sample
			//textureID = pipeline.getTextureUnit("myTextureSampler");
			
//			timeID = pipeline.getConstantLocation("time");
			getConstantLocations(pipeline);
	
			// Texture
			// Create vertex buffer
			vertexBuffer=new VertexBuffer(
				MAX_VERTEX_PER_BUFFER, // Vertex count - 3 floats per vertex
				structure, // Vertex structure
				Usage.DynamicUsage // Vertex data will stay the same
				);
	
			createIndexBuffer();
		}
		
		function getConstantLocations(aPipeline:PipelineState) 
		{
			mMvpID = aPipeline.getConstantLocation("projectionMatrix");
			mTextureID = aPipeline.getTextureUnit("tex");
		}
		function createIndexBuffer():Void
		{
			// Create index buffer
			indexBuffer = new IndexBuffer(
				Std.int(MAX_VERTEX_PER_BUFFER*6/4), // Number of indices for our cube
				Usage.StaticUsage // Index data will stay the same
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
		private function setBlends(aPipeline:PipelineState) 
		{
			aPipeline.blendSource = BlendingFactor.BlendOne;
			aPipeline.blendDestination = BlendingFactor.InverseSourceAlpha;
			aPipeline.alphaBlendSource = BlendingFactor.SourceAlpha;
			aPipeline.alphaBlendDestination = BlendingFactor.InverseSourceAlpha;
		
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
			vertexBuffer.delete();
			indexBuffer.delete();
			pipeline.delete();
		}
		
		/* INTERFACE com.gEngine.painters.IPainter */
		
		public function validateBatch(aTexture:Int, aSize:Int, aAlpha:Bool, aColorTransform:Bool,aMask:Bool):Void 
		{
			if (aTexture != textureID || !canDraw(aSize))
			{
				render();
				textureID = aTexture;
			}
		}
		
		
}