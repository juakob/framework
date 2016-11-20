package com.gEngine.painters;
import kha.Shaders;
import kha.graphics4.IndexBuffer;
import kha.graphics4.PipelineState;
import kha.graphics4.Usage;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;

/**
 * ...
 * @author Joaquin
 */
class PainterMaskSimple extends Painter
{

	public function new(aAutoDestroy:Bool=true) 
	{
		super(aAutoDestroy);
		ratioIndexVertex = 1;
		dataPerVertex = 6;
	}
	override function defineVertexStructure(structure:VertexStructure) 
	{
		structure.add("vertexPosition", VertexData.Float2);
		structure.add("texPosition", VertexData.Float4);
	}
	override function createIndexBuffer():Void 
	{
		// Create index buffer
		indexBuffer = new IndexBuffer(
			Std.int(MAX_VERTEX_PER_BUFFER), // Number of indices for our cube
			Usage.StaticUsage // Index data will stay the same
		);
		
		// Copy indices to index buffer
		var iData = indexBuffer.lock();
			for ( i in 0...Std.int( ( MAX_VERTEX_PER_BUFFER  ) ) )
		{
			iData[i]=i;
			
		}
		indexBuffer.unlock();
	}
	override function setShaders(aPipeline:PipelineState):Void 
	{
		aPipeline.vertexShader = Shaders.simpleMask_vert;
		aPipeline.fragmentShader = Shaders.simpleMask_frag;
	}
}