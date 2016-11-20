package com.helpers;
import kha.Blob;

/**
 * ...
 * @author Joaquin
 */
class ByteArrayKha
{
	private var blob:Blob;
	public var position:Int = 0;
	public function new(aBlob:Blob) 
	{
		blob = aBlob;
	}
	public function readUnsignedInt():UInt
	{
		position += 4;
		return blob.readU32LE(position - 4);
	}
	public function readUTF():String
	{
		var length = blob.readU16LE(position);
		position += 2;
		var string:String="";
		for (i in 0...length) 
		{
			string += String.fromCharCode(blob.readS8(position));
			position += 1;
		}
		return string;
	}
	public function readFloat():Float
	{
		position += 4;
		return blob.readF32LE(position - 4);
	}
	public function readInt():Int
	{
		position += 4;
		return blob.readS32LE(position - 4);
	}
}