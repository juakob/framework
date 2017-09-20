package com.gEngine.painters;
import com.gEngine.display.Blend;
import com.gEngine.display.BlendMode;
import com.gEngine.display.DrawMode;
import com.gEngine.painters.IPainter;
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
   function validateBatch(aTexture:Int, aSize:Int,aDrawMode:DrawMode,aBlend:BlendMode):Void;
   function vertexCount():Int;
   function releaseTexture():Bool;
   function adjustRenderArea(aArea:MinMax):Void;
   
   var textureID:Int;
   var resolution:Float;
}