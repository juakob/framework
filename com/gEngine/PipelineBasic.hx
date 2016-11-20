package com.gEngine;

import com.MyList;
import kha.Shaders;
import kha.arrays.Float32Array;
import kha.graphics4.BlendingFactor;
import kha.graphics4.CompareMode;
import kha.graphics4.ConstantLocation;
import kha.graphics4.TextureUnit;
import kha.graphics4.CullMode;
import kha.graphics4.IndexBuffer;
import kha.graphics4.PipelineState;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;

/**
 * ...
 * @author Joaquin
 */
class PipelineBasic
{
	var structure:kha.graphics4.VertexStructure;

	public var vertexBuffer(default,null):VertexBuffer;
	public var indexBuffer(default,null):IndexBuffer;
	public var pipeline(default,null):PipelineState;
	public static inline var MAX_VERTEX_PER_BUFFER:Int =1500;
	
	public  var dataPerVertex(default,null) = 4;
	public var mvpID(default, null):ConstantLocation;
	public var timeID(default,null):ConstantLocation;
	public var textureID(default, null):TextureUnit;
	
	public function new() 
	{
		
	}
	public function initShaders():Void {
			//structure = new VertexStructure();
			//structure.add("pos", VertexData.Float2);
			//structure.add("uv", VertexData.Float2);
			structure = new VertexStructure();
			structure.add("vertexPosition", VertexData.Float2);
			structure.add("texPosition", VertexData.Float2);

			
			// Save length - we store position and uv data
			
	
			// Compile pipeline state
			// Shaders are located in 'Sources/Shaders' directory
			// and Kha includes them automatically
			pipeline = new PipelineState();
			setShaders(pipeline);
		
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
			mvpID = pipeline.getConstantLocation("projectionMatrix");
			textureID = pipeline.getTextureUnit("tex");
//			timeID = pipeline.getConstantLocation("time");
			getConstantLocations(pipeline);
	
			// Texture
			// Create vertex buffer
			vertexBuffer=new VertexBuffer(
				MAX_VERTEX_PER_BUFFER, // Vertex count - 3 floats per vertex
				structure, // Vertex structure
				Usage.DynamicUsage // Vertex data will stay the same
				);
	
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
		
		function getConstantLocations(aPipeline:PipelineState) 
		{
			
		}
		
		private function setBlends(aPipeline:PipelineState) 
		{
			aPipeline.blendSource = BlendingFactor.SourceAlpha;
			aPipeline.blendDestination = BlendingFactor.InverseSourceAlpha;
			aPipeline.alphaBlendSource = BlendingFactor.SourceAlpha;
			aPipeline.alphaBlendDestination = BlendingFactor.InverseSourceAlpha;
		}
		
		private function setShaders(aPipeline:PipelineState):Void
		{
				aPipeline.vertexShader = Shaders.simple_vert;
				aPipeline.fragmentShader = Shaders.simple_frag;
		}

		public function getVertexBuffer():Float32Array
		{
			return vertexBuffer.lock();
		}
		
		public function uploadVertexBuffer():Void
		{
			vertexBuffer.unlock();
			
		}
}