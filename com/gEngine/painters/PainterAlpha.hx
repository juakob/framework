package com.gEngine.painters;
import kha.Shaders;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;

/**
 * ...
 * @author Joaquin
 */
class PainterAlpha extends Painter
{

	public function new(aAutoDestroy:Bool=true) 
	{
		super(aAutoDestroy);
		dataPerVertex = 5;
	}
	override function defineVertexStructure(structure:VertexStructure) 
	{
		structure.add("vertexPosition", VertexData.Float2);
		structure.add("texPosition", VertexData.Float3);
	}
	override function setShaders(aPipeline:PipelineState):Void 
	{
		aPipeline.vertexShader = Shaders.simpleAlpha_vert;
		aPipeline.fragmentShader = Shaders.simpleAlpha_frag;
	}
}