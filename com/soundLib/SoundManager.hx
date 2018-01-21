package com.soundLib;
import kha.Assets;
import kha.Sound;
import kha.audio1.Audio;
import kha.audio1.AudioChannel;


/**
 * ...
 * @author Joaquin
 */

typedef SM = SoundManager;
class SoundManager
{
	
	private static var map:Map<String,Sound>;
	private static var music:AudioChannel;
	private static var musicName:String;
	private static var musicPosition:Float=0;
	//
	private static var mMuteSounds:Bool = false;
	private static var mMuteMusic:Bool = false;
	
	
	public static function init():Void
	{
	
		map = new Map();
	}
	public static function addSound(aSound:String):Void
	{
		
		//#if debug
		////if (!Assets.exists(location + aSound + ".mp3"))
		////{
			////throw new Error("sound file not found " + aSound);
		////}
		//#end
		map.set(aSound,  Reflect.field(kha.Assets.sounds, aSound));
		//#else
		//map.set(aSound, Assets.getSound(location + aSound+".ogg"));
		//#end
	}
	public static function playFx(aSound:String):Void
	{
		#if debug
		if (!map.exists(aSound)) {
			throw "Sound not found";
		}
		#end
		if (!mMuteSounds)
		{
			Audio.play(map.get(aSound));
		}
	}
	public static function playMusic(aSound:String,aPosition:Float=0):Void
	{
		#if debug
		if (!map.exists(aSound)) {
			throw "Sound not found";
		}
		#end
		if (music != null)
		{
			music.stop();
		}
		musicName = aSound;
		if (!mMuteMusic)
		{
			music = Audio.play(map.get(aSound), true);
			//music.position = aPosition;
		}
	}
	public static function switchSound():Void
	{
		if (mMuteSounds)
		{
			unMuteSound();
		}else {
			muteSound();
		}
	}
	public static function switchMusic():Void
	{
		if (mMuteMusic)
		{
			unMuteMusic();
		}else {
			muteMusic();
		}
	}
	public static function muteSound():Void
	{
		mMuteSounds = true;
	}
	public static function muteMusic():Void
	{
		mMuteMusic = true;
		if (music != null)
		{
			musicPosition = music.position;
			music.stop();
		}
	}
	public static function unMuteSound():Void
	{
		mMuteSounds = false;
	}
	public static function unMuteMusic():Void
	{
		mMuteMusic = false;
		if (musicName != null)
		{
			playMusic(musicName,musicPosition);
		}
	}
	public static inline function  soundMuted():Bool
	{
		return mMuteSounds;
	}
	public static inline function  musicMuted():Bool
	{
		return mMuteMusic;
	}
	static public function reset() 
	{
		map = new Map();
	}
	
}