package com.gEngine;
import com.helpers.Matrix;
import com.helpers.FastPoint;


	/**
	 * ...
	 * @author joaquin
	 */
	 class Dummy 
	{
		public var name:String;
		public var pos:FastPoint;
		public var widthV:FastPoint;
		public var heightV:FastPoint;
		public var drawIndex:Int;
		
		public var matrix:Matrix;
		
		public function new() 
		{
			matrix = new Matrix();
		}
		
		public function clone():Dummy 
		{
			var dummy:Dummy = new Dummy();
			dummy.matrix = matrix.clone();
			dummy.name = name;
			dummy.pos = pos.clone();
			dummy.widthV = widthV.clone();
			dummy.heightV = heightV.clone();
			dummy.drawIndex = drawIndex;
			return dummy;
		}
		public function contains(mouseX:Float, mouseY:Float):Bool
		{
			return !( mouseX > pos.x + widthV.x || mouseX < pos.x - widthV.x || mouseY > pos.y + heightV.y || mouseY < pos.y - heightV.y);
		}
		
		public function applyTransform(tranformation:Matrix):Void 
		{
			pos = tranformation.transformPoint(pos);
		}
		
	}

