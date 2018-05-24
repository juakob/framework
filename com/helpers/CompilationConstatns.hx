package com.helpers;

/**
 * ...
 * @author Joaquin
 */
class CompilationConstatns
{

	public macro static function getWidth()
	{
		if (haxe.macro.Context.defined("G_WIDTH"))
		{
		return macro $v { Std.parseInt(haxe.macro.Context.definedValue("G_WIDTH")) };
		}
		return macro $v { 1280};
	}
	public macro static function getHeight()
	{
		if (haxe.macro.Context.defined("G_HEIGHT"))
		{
		return macro $v { Std.parseInt(haxe.macro.Context.definedValue("G_HEIGHT")) };
		}
		return macro $v { 720};
	}
}