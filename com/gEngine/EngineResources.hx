package com.gEngine;

import com.gEngine.tempStructures.UVLinker;
import com.MyList;
import com.helpers.Point;



	/**
	 * ...
	 * @author joaquin
	 */
	 class EngineResources 
	{
		private var mComplexAnimationsNames:MyList<String>;
		private var mComplexAnimationsChildsNames:MyList<MyList<String>>;
		
		private var mAnimations:MyList<AnimationData>;
		
		private var mFramesTextures:MyList<UVLinker>;
		
		public function new() 
		{
		

			mComplexAnimationsNames = new MyList();
			mComplexAnimationsChildsNames = new MyList();

			
			mAnimations = new MyList();
			mFramesTextures = new MyList();

		}
		public function addResource(name:String, frames:MyList<Frame>,dummys:MyList<MyList<Dummy>>,labels:MyList<Label>,textures:MyList<MyList<String>>,masks:MyList<MaskBatch>):Void
		{
			
			var animation = new AnimationData();
			animation.name = name;
			animation.dummys = dummys;
			animation.labels = labels;
			animation.frames = frames;
			mAnimations.push(animation);
			
			var uvLinker = new UVLinker();
			uvLinker.animationName = name;
			uvLinker.texturesNames = textures;
			uvLinker.masks = masks;
			mFramesTextures.push(uvLinker);
		}
		public function addComplexResource(name:String, childs:MyList<String>):Void
		{
			mComplexAnimationsNames.push(name);
			mComplexAnimationsChildsNames.push(childs);
		}
		
		public function getTextureLinker(name:String):UVLinker
		{
			for (animation in mFramesTextures)
			{
				if (animation.animationName == name)
				{
					return animation;
				}
			}
			throw "Animation  "+name+" textures not found";
		}
		
		public function getComplexAnimationId(name:String):Int
		{
			return mComplexAnimationsNames.indexOf(name);
		}
		
		
		public function getChilds(id:UInt):MyList<String>
		{
			return mComplexAnimationsChildsNames[id];
		}
		
		public function getAnimationData(name:String):AnimationData
		{
			for (animation in mAnimations)
			{
				if (animation.name == name)
				{
					return animation;
				}
			}
			throw "Animation "+name+" not found";
		}
		
		public function clear():Void 
		{
			
			mComplexAnimationsNames.splice(0,mComplexAnimationsNames.length);
			mComplexAnimationsChildsNames.splice(0,mComplexAnimationsChildsNames.length);
		//	mComplexAnimationsNames =null;
		//	mComplexAnimationsChildsNames = null;
			
			mAnimations.splice(0, mAnimations.length);
		//	mAnimations = null;
			
			mFramesTextures.splice(0, mFramesTextures.length);
		//	mFramesTextures = null;
			
		}
		
		public function linkAnimationToTexture(aName:String,textureId:Int,linker:MyList<AnimationTilesheetLinker>):Void
		{

			var animation:AnimationData = getAnimationData(aName);
			animation.texturesID = textureId;
			var uvLinker:UVLinker = getTextureLinker(aName);
			
			var currentFrame:Int = 0;
			for (framesTextures in uvLinker.texturesNames) 
			{
				var frame = animation.frames[currentFrame];
				frame.UVs = new MyList();
				for (textureName in framesTextures) 
				{
					var uvData:MyList<Float>=null;
					for (link in linker) 
					{
						if (link.image == textureName)
						{
							uvData = link.UVs;
							break;
						}
					}
					for (data in uvData) 
					{
						frame.UVs.push(data);
						//frame.UVs.push(0);
					}
				}
				++currentFrame;
			}
			for (maskBatch in uvLinker.masks) 
			{
				var maskUWidth:Float=0;
				var maskVHeight:Float=0;
				var maskStartU:Float=0;
				var maskStartV:Float=0;
				
				for (link in linker) 
				{
					if (link.image == maskBatch.maskId)
					{
						maskUWidth = link.getUWidth();
						maskVHeight = link.getVHeight();
						maskStartU = link.getUStart();
						maskStartV = link.getVStart();
						break;
					}
				}
				var counter:Int = 0;
				var offset:Int = 0;
				for (texture in maskBatch.textures) 
				{
					var imageLink:AnimationTilesheetLinker=null;
					for (link in linker) 
					{
						if (link.image == texture)
						{
							imageLink = link;
							break;
						}
					}
					var imageUWidth:Float = imageLink.getUWidth();
					var imageVHeight:Float = imageLink.getVHeight();
					var startU:Float = imageLink.getUStart();
					var startV:Float = imageLink.getVStart();
					
					for (i in 0...maskBatch.vertexCount[counter]) 
					{
						maskBatch.uvs[offset+i*2] = maskBatch.uvs[offset+i*2] * imageUWidth + startU;
						maskBatch.uvs[offset+i*2 + 1] = maskBatch.uvs[offset+i*2 + 1] * imageVHeight + startV;
						
						maskBatch.maskUvs[offset+i*2] = maskBatch.maskUvs[offset+i*2] * maskUWidth + maskStartU;
						maskBatch.maskUvs[offset+i*2 + 1] = maskBatch.maskUvs[offset+i*2 + 1] * maskVHeight + maskStartV;
					}
					offset += maskBatch.vertexCount[counter]*2;
					++counter;
				}
			}
		}
	}

