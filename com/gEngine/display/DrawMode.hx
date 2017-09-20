package com.gEngine.display;

/**
 * @author Joaquin
 */

 
@:enum
abstract DrawMode(Int) 
{
	//warning dont change the order
	var Default = 0;
	var Alpha = 1;
	var ColorTint = 2;
	var Mask = 3;
}