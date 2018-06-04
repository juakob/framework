package com.gEngine ;

	import com.helpers.ByteArrayKha;
	import com.helpers.MinMax;
	import com.helpers.FastPoint;
	import com.MyList;
	import kha.Blob;
	/**
	 * ...
	 * @author joaquin
	 */
	 class Importer 
	{
		public var names:MyList<String>;
		public var animationLabels:MyList<MyList<Label>>;
		public var animationsTextures:MyList<MyList<String>>;
		public var complexAnimations:MyList<String>;
		public var complexAnimationsChilds:MyList<MyList<String>>;
		public var dummys:MyList<MyList<MyList<Dummy>>>;
		
		public var frameData:MyList<MyList<Frame>>;
		public var textures:MyList<MyList<MyList<String>>>;
		public var maskTextures:MyList<String>;
		public var masksBatchs:MyList<MyList<MaskBatch>>;
		
		public function new() 
		{
			
			names = new MyList();
			animationLabels = new MyList();
			animationsTextures = new MyList();
			complexAnimations = new MyList();
			complexAnimationsChilds = new MyList();
			dummys = new MyList();
			frameData = new MyList();
			textures = new MyList();
			maskTextures = new MyList();
			masksBatchs = new MyList();
			
		}
		public function decompile(aBlob:Blob):Void
		{
			var data:ByteArrayKha = new ByteArrayKha(aBlob);
			//data.uncompress();
			//data.endian = Endian.LITTLE_ENDIAN;
			var lengthSimpleAnimations:Int = data.readUnsignedInt();
			for ( j in 0...lengthSimpleAnimations) 
			{
				//animation name
				var name:String = data.readUTF();
				names.push(name);
				
				//frames Length
				var labelsLength:Int = data.readUnsignedInt();
				var currentLabels:MyList<Label> = new MyList<Label>();
				for ( i in 0...labelsLength) 
				{
					var label_:Label = new Label();
					label_.frame=data.readUnsignedInt();
					label_.name = data.readUTF();
					currentLabels.push(label_);
				}
				animationLabels.push(currentLabels);
				//textures
				var textureLength:Int = data.readUnsignedInt();
				var currentTextues:MyList<String> = new MyList<String>();
				for (k in 0...textureLength) 
				{
					currentTextues.push(data.readUTF());
				}
				animationsTextures.push(currentTextues);
				
				
				readFrames(data,animationsTextures[j]);
				
				//Dummys Data
				readDummys(data);
			
			}
			
			
			readComplexAnimation(data);
		}
		
		
		
		  function readFrames(frames:ByteArrayKha,aTextures:MyList<String>):Void
		{
			
			var length:Int = frames.readInt();
			
			//var framesData = new MyList<MyList<Float>>();
			var frameLength:Int;
			var localPos:Int = 0;
			var currentAnimationFrames:MyList<Frame> = new MyList();
			var currentAnimationTextures:MyList<MyList<String>> = new MyList();
			var currentMaskBatchs:MyList<MaskBatch> = new MyList();
			for ( i in 0...length) 
			{
				var currentFrame = new Frame();
				var drawArea:DrawArea = new DrawArea(frames.readFloat(), frames.readFloat(), frames.readFloat(), frames.readFloat());
				currentFrame.drawArea = drawArea;
				
				frameLength = frames.readInt();
				
				currentFrame.vertexs = new MyList();
				currentFrame.alphas = new MyList();
				currentFrame.colortTransform = new MyList();
				currentFrame.maskBatchs = new MyList();
				currentFrame.blurBatchs = new MyList();
				var currentTextures = new MyList<String>();
				while (frameLength > 0)
				{
					
					localPos = frames.position;
					var texture:String = aTextures[frames.readInt()];
					currentTextures.push(texture);
					for ( j in 0...4 ) 
					{
					currentFrame.vertexs.push(frames.readFloat());//x
					currentFrame.vertexs.push(frames.readFloat());//y
					}
					
					frameLength -= frames.position - localPos;
				}
				var alphaLength = frames.readInt();
				while (alphaLength > 0)
				{
					localPos = frames.position;
					currentFrame.alphas.push(frames.readFloat());
					alphaLength -= frames.position - localPos;
				}
				var colorLength = frames.readInt();
				while (colorLength > 0)
				{
					localPos = frames.position;
					currentFrame.colortTransform.push(frames.readFloat());
					colorLength -= frames.position - localPos;
				}
				var masksCount = frames.readInt();
				for (i in 0...masksCount)
				{
					var maskBatch:MaskBatch = new MaskBatch();
					var start:Int = frames.readInt();
					maskBatch.start = start;
					var maskId:String = aTextures[frames.readInt()];
					maskBatch.maskId = maskId;
					maskTextures.push(maskId);
					var maskCount:Int = frames.readInt();
					maskBatch.masksCount = maskCount;
					for (k in 0...maskCount) 
					{
						var texture:String = aTextures[frames.readInt()];
						maskTextures.push(texture);
						maskBatch.textures.push(texture);
						var vertexCount:Int = frames.readInt();
						maskBatch.vertexCount.push(vertexCount);
						for (l in 0...vertexCount) 
						{
							maskBatch.vertex.push(frames.readFloat());//x
							maskBatch.vertex.push(frames.readFloat());//y
							
							maskBatch.uvs.push(frames.readFloat());//u
							maskBatch.uvs.push(frames.readFloat());//v
							
							maskBatch.maskUvs.push(frames.readFloat());//maskU
							maskBatch.maskUvs.push(frames.readFloat());//maskV
							
						}
					}
					currentFrame.maskBatchs.push(maskBatch);
					currentMaskBatchs.push(maskBatch);
				}
				
				var blurCount = frames.readInt();
				for (i in 0...blurCount)
				{
					var batch = new BlurBatch();
					batch.start = frames.readInt();
					batch.end = frames.readInt();
					batch.blurX = frames.readFloat();
					batch.blurY = frames.readFloat();
					batch.passes = frames.readInt();
					batch.area = new MinMax();
					batch.area.min.x = frames.readFloat();
					batch.area.min.y = frames.readFloat();
					batch.area.max.x = frames.readFloat()+batch.area.min.x;
					batch.area.max.y = frames.readFloat()+batch.area.min.y;
					
					currentFrame.blurBatchs.push(batch);
				}
				currentAnimationFrames.push(currentFrame);
				currentAnimationTextures.push(currentTextures);
			}
			frameData.push(currentAnimationFrames);
			textures.push(currentAnimationTextures);
			masksBatchs.push(currentMaskBatchs);
		}
		
		 function readDummys(data:ByteArrayKha):Void
		{
			var lengthDummyData:UInt = data.readUnsignedInt();
			var dummysCurrentAnimation:MyList<MyList<Dummy>> = new MyList();
			while (lengthDummyData > 0)
			{
				var dummysCurrentFrame:MyList<Dummy> = new MyList<Dummy>();
				var initialPosition:UInt = data.position;
				var length:UInt = data.readUnsignedInt();
				for ( n in 0...length) 
				{
					var dummy:Dummy = new Dummy();
					dummy.name = data.readUTF();

					dummy.drawIndex = data.readInt();
					
					dummy.matrix.a = data.readFloat();
					dummy.matrix.b = data.readFloat();
					dummy.matrix.c = data.readFloat();
					dummy.matrix.d = data.readFloat();
					dummy.matrix.tx = data.readFloat();
					dummy.matrix.ty = data.readFloat();
					dummy.pos = new FastPoint(data.readFloat(), data.readFloat());
					dummy.widthV = new FastPoint(data.readFloat(), data.readFloat());
					dummy.heightV = new FastPoint(data.readFloat(), data.readFloat());
					dummysCurrentFrame.push(dummy);
				}
				dummysCurrentAnimation.push(dummysCurrentFrame);
				lengthDummyData -= data.position - initialPosition;
			}
			dummys.push(dummysCurrentAnimation);
		
		}
		 function readComplexAnimation(data:ByteArrayKha):Void
		{
			var lengthComplexAnimations:Int = data.readUnsignedInt();
			for ( l in 0...lengthComplexAnimations) 
			{
				complexAnimations.push(data.readUTF());
				var childenNames:MyList<String>=new MyList<String>();
				var childrenLength:Int = data.readUnsignedInt();
				for ( m in 0...childrenLength) 
				{
					childenNames.push(data.readUTF());
				}
				complexAnimationsChilds.push(childenNames);
			}
		}
		
	
		
	}

