package com.gEngine.helper;

/**
 * ...
 * @author Joaquin
 */
class Screen
{

	public static inline function getWidth():Int
	{
		#if (kha_android&&cpp)
		return kha.Display.width(0);
		#else
		return kha.System.windowWidth();
		#end
	}
	public static inline function getHeight():Int
	{
		#if (kha_android&&cpp)
		return kha.Display.height(0);
		#else
		return kha.System.windowHeight();
		#end
	}
	public function new() 
	{
		
	}
	
}