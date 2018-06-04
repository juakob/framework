package com.gEngine;
import com.MyList;
import kha.FastFloat;

/**
 * ...
 * @author Joaquin
 */
class Frame
{
	public var vertexs:MyList<FastFloat>;
	public var UVs:MyList<FastFloat>;
	public var alphas:MyList<FastFloat>;
	public var colortTransform:MyList<FastFloat>;
	public var maskBatchs:MyList<MaskBatch>;
	public var drawArea:DrawArea;
	public var blurBatchs:MyList<BlurBatch>;
	public function new() 
	{
		
	}
	
}