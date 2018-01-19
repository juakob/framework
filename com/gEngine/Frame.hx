package com.gEngine;
import com.MyList;

/**
 * ...
 * @author Joaquin
 */
class Frame
{
	public var vertexs:MyList<Float>;
	public var UVs:MyList<Float>;
	public var alphas:MyList<Float>;
	public var colortTransform:MyList<Float>;
	public var maskBatchs:MyList<MaskBatch>;
	public var drawArea:DrawArea;
	public var blurBatchs:MyList<BlurBatch>;
	public function new() 
	{
		
	}
	
}