package com.panelUI ;

	
/**
 * ...
 * @author Joaquin
 */
interface ITransition 
{
	function update(aDt:Float):Void;
	function isFinish():Bool;
	function setToFinish():Void;
}
	
