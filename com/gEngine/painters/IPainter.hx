package com.gEngine.painters;

/**
 * @author Joaquin
 */
interface IPainter 
{
   function write(aValue:Float):Void;
   function start():Void;
   function finish():Void;
   function render(clear:Bool = false ):Void;
   function validateBatch(aTexture:Int, aSize:Int, aAlpha:Bool, aColorTransform:Bool,aMask:Bool):Void;
   function vertexCount():Int;
   function releaseTexture():Bool;
   var textureID:Int;
}