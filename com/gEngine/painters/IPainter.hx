package com.gEngine.painters;
import com.helpers.MinMax;

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
   function adjustRenderArea(aArea:MinMax):Void;
   function multipassBlend():Void;
   function defaultBlend():Void;
   var textureID:Int;
   var resolution:Float;
}