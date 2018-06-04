package com.framework.utils;
import com.MyList;
import com.framework.utils.Resource.AtlasInfo;
import com.framework.utils.Resource.Rename;
import com.framework.utils.Resource.TextureProxy;
import com.gEngine.AnimationData;
import com.gEngine.GEngine;
import com.gEngine.helper.AtlasExtractor;
import com.gEngine.helper.AtlasType;
import com.gEngine.tempStructures.Bitmap;
import com.helpers.FastPoint;
import com.soundLib.SoundManager.SM;
import kha.Assets;
import kha.Blob;
import kha.Color;
import kha.Image;
import kha.Sound;

/**
 * ...
 * @author Joaquin
 */
typedef Rename = { var original:String; var newName:String; };
@:allow(com.gEngine.GEngine)
class Resource
{

	public function new() 
	{
		
	}
	
		private var mAnimationsResources:Array<String> = new Array();
		private var mImageResources:Array<String> = new Array();
		private var mSoundResources:Array<String> = new Array();
		private var mTextures:Array<TextureProxy> = new Array();
		private var mDataResources:Array<String> = new Array();
		private var mAnimationsLoaded:Int = 0;
		private var mImagesLoaded:Int = 0;
		private var mSoundsLoaded:Int = 0;
		private var mDataLoaded:Int = 0;
		private var mOnFinish:Void->Void;
		private var renames:Array<Rename> = new Array();
		
		public function addAnimation(aAnimation:String,aRename:String=null,textureId:Int=1):Void
		{
			mAnimationsResources.push(aAnimation);
			#if debug
			if (mTextures.length == 0)
			{
				throw "Call startTexture before adding an animation";
			}
			#end
			mTextures[mTextures.length - 1].animations.push(aAnimation);
			if (aRename != null)
			{
				var rename:Rename = { original : aAnimation, newName : aRename };
				renames.push(rename);
			}
			
		}
		public function startTexture(aWidth:Int, aHeight:Int,?aColor:Color):Void
		{
			var texture:TextureProxy = new TextureProxy();
			texture.size = new FastPoint(aWidth, aHeight);
			mTextures.push(texture);
			if (aColor != null)
			{
				texture.color = aColor;
			}
		}
		public function addSound(aSound:String):Void
		{
			mSoundResources.push(aSound);
		}
		public function uploadTextures():Void
		{ 
			var counter:Int = 0;
			for (texture in mTextures) 
			{
				AtlasExtractor.extractAtlas(texture.atlas);
				GEngine.i.loadAnimationsToTexture(texture);
				++counter;
			}
			//remove data
			mTextures.splice(0, mTextures.length);
			
			for (animation in mAnimationsResources) 
			{
				Reflect.callMethod(Assets.blobs, Reflect.field(Assets.blobs, animation + "Unload"), []);
			}
			mAnimationsResources.splice(0, mAnimationsResources.length);
			for (image in mImageResources) 
			{
				Reflect.callMethod(Assets.images, Reflect.field(Assets.images, image + "Unload"), []);
			}
			mImageResources.splice(0, mImageResources.length);
			
			renameAnimations();
		}
		public function load(onFinish:Void->Void):Void
		{
			mOnFinish = onFinish;
			
			for (animation in mAnimationsResources) 
			{
				Assets.loadBlob(animation, onAnimationLoad);
			}
			for (sound in mSoundResources) 
			{
				Assets.loadSound(sound, onSoundLoad);
			}
			for (data in mDataResources)
			{
				Assets.loadBlob(data, function(b:Blob) {++mDataLoaded; checkFinishLoading();} );
			}
			for (texture in mTextures) 
			{
				for (atlas in texture.atlas) 
				{
					loadImage(atlas.image);
				}
			}
		}
		
		
		private function loadImage(aName:String):Void {
			if (mImageResources.indexOf(aName) < 0)
			{
				//trace("image load: " + aName);
				mImageResources.push(aName);
				//Assets.loadBlob(aName, addImage
				#if debug
				trace(aName);
				if (Assets.images.names.indexOf(aName) ==-1) throw "image " + aName+" not found";
				#end
				Assets.loadImage(aName, addImage);
			}
		}
		
		public function checkFinishLoading()
		{
			if (isAllLoaded())
			{
				trace("all loaded");
				mOnFinish();
				for (sound in mSoundResources) 
				{
					SM.addSound(sound);
				}
			}
		}
		
		function renameAnimations() 
		{
			for (rename in renames) 
			{
				var animation:AnimationData = GEngine.i.mResources.getAnimationData(rename.original);
				animation.name = rename.newName;
			}
			renames.splice(0, renames.length);
		}
		
		private function onAnimationLoad(aBlob:Blob):Void
		{
			var images = GEngine.i.addResources(aBlob);
			for (image in images) 
			{
				loadImage(image);
			}
			++mAnimationsLoaded;
			checkFinishLoading();
		}
		
		private function addImage(aBlob:Image):Void
		{
			++mImagesLoaded;
			checkFinishLoading();
		}
		private function onSoundLoad(aSound:Sound):Void
		{
			aSound.uncompress(function() {
				++mSoundsLoaded;
			checkFinishLoading(); } );
			
		}
		public function unload():Void
		{
			
			for (sound in mSoundResources) 
			{
				Reflect.callMethod(Assets.sounds, Reflect.field(Assets.sounds, sound + "Unload"), []);
			}
			for (data in mDataResources) {
				Reflect.callMethod(Assets.blobs, Reflect.field(Assets.blobs, data + "Unload"), []);
			}
			mSoundResources.splice(0, mSoundResources.length);
			mDataResources.splice(0, mDataResources.length);
			mAnimationsLoaded = 0;
			mSoundsLoaded = 0;
			mImagesLoaded = 0;
			mDataLoaded = 0;
		}
		public inline function isAllLoaded():Bool
		{	
			return mAnimationsResources.length == mAnimationsLoaded &&
				mImageResources.length == mImagesLoaded &&
				mSoundResources.length == mSoundsLoaded &&
				mDataResources.length == mDataLoaded;
		}
		
		public function addData(aName:String) 
		{
			mDataResources.push(aName);
		}
		
		public function addAtlas(aName:String,aImage:String, aData:String,aType:AtlasType) 
		{
			#if debug
			if (mTextures.length == 0)
			{
				throw "Call startTexture before adding an animation";
			}
			#end
			addData(aData);
			var atlasInfo:AtlasInfo = new AtlasInfo();
			atlasInfo.data = aData;
			atlasInfo.image = aImage;
			atlasInfo.name = aName;
			atlasInfo.type = aType;
			mTextures[mTextures.length - 1].atlas.push(atlasInfo);
		}
		
		public function addTileSheet(aName:String,aImage:String, aSpriteWidth:Int, aSpriteHeight:Int) 
		{
			#if debug
			if (mTextures.length == 0)
			{
				throw "Call startTexture before adding an animation";
			}
			#end
			var atlasInfo:AtlasInfo = new AtlasInfo();
			atlasInfo.image = aImage;
			atlasInfo.name = aName;
			atlasInfo.spriteWidth = aSpriteWidth;
			atlasInfo.spriteHeight = aSpriteHeight;
			atlasInfo.type = AtlasType.SpriteSheet;
			mTextures[mTextures.length - 1].atlas.push(atlasInfo);
		}
}
class TextureProxy
{
	public var animations:Array<String> = new Array();
	public var atlas:Array<AtlasInfo> = new Array();
	public var color:Color=Color.fromFloats(1,1, 1, 1);
	public var size:FastPoint;
	public function new()
	{
		
	}
}
class AtlasInfo
{
	public var image:String;
	public var data:String;
	public var name:String;
	public var type:AtlasType;
	public var bitmaps:Array<Bitmap> = new Array();
	public var spriteWidth:Int;
	public var spriteHeight:Int;
	public function new()
	{
	}
}