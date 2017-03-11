package com.framework.utils;
import com.MyList;
import com.gEngine.GEngine;
import com.helpers.Point;
import kha.Assets;
import kha.Blob;
import kha.Image;
import kha.Sound;

/**
 * ...
 * @author Joaquin
 */
class Resource
{

	public function new() 
	{
		
	}
	
		private var mAnimationsResources:Array<String> = new Array();
		private var mImageResources:Array<String> = new Array();
		private var mSoundResources:Array<String> = new Array();
		private var mTexture:Array<MyList<String>> = new Array();
		private var mTextureDimesion:Array<Point> = new Array();
		private var mDataResources:Array<String> = new Array();
		private var mAnimationsLoaded:Int = 0;
		private var mImagesLoaded:Int = 0;
		private var mSoundsLoaded:Int = 0;
		private var mDataLoaded:Int = 0;
		private var mOnFinish:Void->Void;
		public function addAnimation(aAnimation:String,textureId:Int=1):Void
		{
			mAnimationsResources.push(aAnimation);
			mTexture[mTexture.length-1].push(aAnimation);
		}
		public function startTexture(aWidth:Int, aHeight:Int):Void
		{
			mTextureDimesion.push(new Point(aWidth, aHeight));
			mTexture.push(new MyList());
		}
		public function addSound(aSound:String):Void
		{
			mSoundResources.push(aSound);
		}
		public function uploadTextures():Void
		{ 
			var counter:Int = 0;
			for (texture in mTexture) 
			{
				var dimension = mTextureDimesion[counter];
				GEngine.i.loadAnimationsToTexture(texture, Std.int(dimension.x), Std.int(dimension.y));
				++counter;
			}
			//remove data
			mTexture.splice(0, mTexture.length);
			mTextureDimesion.splice(0, mTextureDimesion.length);
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
		}
		
		
		private function loadImage(aName:String):Void {
			if (mImageResources.indexOf(aName) < 0)
			{
				trace("image load: " + aName);
				mImageResources.push(aName);
				//Assets.loadBlob(aName, addImage
				Assets.loadImage(aName, addImage);
			}
		}
		
		public function checkFinishLoading()
		{
			if (isAllLoaded())
			{
				mOnFinish();
			}
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
			checkFinishLoading();});
			
		}
		public function unload():Void
		{
			
			for (sound in mSoundResources) 
			{
				Reflect.callMethod(Assets.sounds, Reflect.field(Assets.sounds, sound + "Unload"), []);
			}
			mSoundResources.splice(0, mSoundResources.length);
			mAnimationsLoaded = 0;
			mSoundsLoaded = 0;
			mImagesLoaded = 0;
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
}