package com.gEngine.painters;
import com.gEngine.display.Blend;
import com.gEngine.display.BlendMode;
import com.gEngine.display.DrawMode;
import com.helpers.MinMax;
import kha.Color;
import kha.FastFloat;
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
import kha.math.FastMatrix4;
import kha.math.Matrix4;

/**
 * ...
 * @author Joaquin
 */
//testClass
class Painter3D implements IPainter
{
	var vertexBuffer:VertexBuffer;
	var indexBuffer:IndexBuffer;
	var pipeline:PipelineState;
	var red:FastFloat = 0.;
	var green:FastFloat = 0.;
	var blue:FastFloat = 0.;
	var alpha:FastFloat = 0.;
	public var MAX_VERTEX_PER_BUFFER:Int =2331;
	
	var dataPerVertex:Int = 6;
	var mMvpID:ConstantLocation;
	public var mTextureID:TextureUnit;
	
	public var resolution:Float = 1;
	
	var ratioIndexVertex:Float = 6 / 4;
	private var counter:Int=0;
	var buffer:Float32Array;
	public var textureID:Int = -1;
	
	
	public function new(aAutoDestroy:Bool = true, aBlend:Blend=null) 
	{	
		if (aBlend == null) aBlend = Blend.blendDefault();
		//if (aAutoDestroy) PainterGarbage.i.add(this);
		initShaders(aBlend);
		buffer = getVertexBuffer();
		mCustomBlend = false;
	}
	public inline function write(aValue:Float):Void
	{
	//	buffer.set(counter++, aValue);
		
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
		//if (counter == 0) return;
		
		
			var g = GEngine.i.currentCanvas().g4;
			// Begin rendering
			g.begin();
			g.scissor(0, 0, GEngine.i.width, GEngine.i.height);
			//uploadVertexBuffer();
			// Clear screen
			if(clear) g.clear(Color.fromFloats(red,green,blue,alpha));
			// Bind data we want to draw
			g.setVertexBuffer(vertexBuffer);
			g.setIndexBuffer(indexBuffer);

			// Bind state we want to draw with
			g.setPipeline(pipeline);

			setParameter(g);
			//g.setTextureParameters(mTextureID, TextureAddressing.Clamp, TextureAddressing.Clamp, TextureFilter.LinearFilter, TextureFilter.LinearFilter, MipMapFilter.NoMipFilter);
			
			g.drawIndexedVertices(); 
			
			//unsetTextures(g);
			// End rendering	
			g.disableScissor();
			g.end();
			//buffer = getVertexBuffer();
			#if debugInfo
			++GEngine.drawCount;
			#end
			counter = 0;
	}
	public function vertexCount():Int
	{
		return Std.int(counter / dataPerVertex);
	}
	
	public function initShaders(aBlend:Blend):Void {
		
			pipeline = new PipelineState();
			setShaders(pipeline);
			
			var structure = new VertexStructure();
			defineVertexStructure(structure);
			pipeline.inputLayout = [structure];
			
			//pipeline.cullMode = CullMode.None;
			
			//setBlends(pipeline,aBlend);
			pipeline.compile();
			
			getConstantLocations(pipeline);
			
		
			vertexBuffer=new VertexBuffer(
				MAX_VERTEX_PER_BUFFER,
				structure, 
				Usage.StaticUsage 
				);
			buffer = getVertexBuffer();
			var counter:Int = 0;
			for (i in 1...(Std.int(MAX_VERTEX_PER_BUFFER/3))) 
			{
				writeVertex(0, 0, 0, 0, 1, 1, 0+counter);
				writeVertex(25,32, 0, 1, 0, 1, 6+counter);
				writeVertex(0, 32, 0, 1, 1, 0, 12 + counter);
				counter += 18;
			}
				
			uploadVertexBuffer();
			createIndexBuffer();
		}
		
		function getConstantLocations(aPipeline:PipelineState) 
		{
			mMvpID = aPipeline.getConstantLocation("projectionMatrix");
		//	mTextureID = aPipeline.getTextureUnit("tex");
		}
		function createIndexBuffer():Void
		{
			
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
			structure.add("vertexPosition", VertexData.Float3);
			structure.add("texPosition", VertexData.Float3);
		}
		
		private function setShaders(aPipeline:PipelineState):Void
		{
				aPipeline.vertexShader = Shaders.simpleShape_vert;
				aPipeline.fragmentShader = Shaders.simpleShape_frag;
		}
		private function setParameter(g:Graphics):Void
		{
			g.setMatrix(mMvpID, GEngine.i.getMatrix().multmat(FastMatrix4.translation(Math.random()*1180,Math.random()*620,0)));

			//g.setTexture(mTextureID, GEngine.i.mTextures[textureID]);
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
		var mCustomBlend:Bool = false;
		public function validateBatch(aTexture:Int, aSize:Int, aDrawMode:DrawMode, aBlend:BlendMode):Void 
		{
			
				render();
		
		}
		
		/* INTERFACE com.gEngine.painters.IPainter */
		
		public function releaseTexture():Bool 
		{
			return true;
		}
		
		/* INTERFACE com.gEngine.painters.IPainter */
		
		public function adjustRenderArea(aArea:MinMax):Void 
		{
			
		}
}