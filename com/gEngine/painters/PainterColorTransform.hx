package com.gEngine.painters;
import com.gEngine.display.Blend;
import kha.Shaders;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;

/**
 * ...
 * @author Joaquin
 */
class PainterColorTransform extends Painter
{

	public function new(aAutoDestroy:Bool=true,aBlend:Blend) 
	{
		super(aAutoDestroy,aBlend);
		dataPerVertex = 12;
	}
	override function defineVertexStructure(structure:VertexStructure) 
	{
		structure.add("vertexPosition", VertexData.Float2);
		structure.add("texPosition", VertexData.Float2);
		structure.add("colorMul", VertexData.Float4);
		structure.add("colorAdd", VertexData.Float4);
	}
	override function setShaders(aPipeline:PipelineState):Void 
	{
		aPipeline.vertexShader = Shaders.simpleColorTransformation_vert;
		aPipeline.fragmentShader = Shaders.simpleColorTransformation_frag;
	}
	
}