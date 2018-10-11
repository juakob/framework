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
	
	public function clone():Frame
	{
		var cl = new Frame();
		cl.vertexs = new MyList();
		cl.UVs = new MyList();
		cl.alphas = new MyList();
		cl.colortTransform = new MyList();
	
		cl.drawArea = drawArea.clone();	
		
		//todo clone this data
		cl.maskBatchs = new MyList();
		cl.blurBatchs = new MyList();
		
		copyData(vertexs, cl.vertexs);
		copyData(UVs, cl.UVs);
		copyData(alphas, cl.alphas);
		copyData(colortTransform, cl.colortTransform);
		
		return cl;
	}
	
	public inline static function  copyData(from:MyList<FastFloat>, to:MyList<FastFloat>) {
		for (data in from) 
		{
			to.push(data);
		}
	}
	
}