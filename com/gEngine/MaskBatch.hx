package com.gEngine;
import com.MyList;

/**
 * ...
 * @author Joaquin
 */
class MaskBatch
{
	public var start:Int;
	public var vertex:MyList<Float>;
	public var uvs:MyList<Float>;
	public var maskUvs:MyList<Float>;
	public var maskId:String;
	public var textures:MyList<String>;
	public var vertexCount:MyList<Int>;
	public var masksCount:Int;
	public function new()
	{
		vertex = new MyList();
		uvs = new MyList();
		maskUvs = new MyList();
		textures = new MyList();
		vertexCount = new MyList();
	}
	
}