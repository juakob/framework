package com.gEngine.shaders;

import com.gEngine.GEngine;
import com.gEngine.painters.Painter;
import com.gEngine.painters.SpritePainter;

/**
 * ...
 * @author Joaquin
 */
class PosEffect extends SpritePainter
{
	var mPosEffect:Painter;
	public function new(aPosEffect:Painter) 
	{
		mPosEffect = aPosEffect;
		super(true);
		
	}
	override public function start() 
	{
		//GEngine.i.changeToTemp();
		var g = GEngine.i.currentCanvas().g4;
		g.begin();
		g.clear(0);
		g.end();
	}
	override public function finish() 
	{
		//GEngine.i.renderTempToFrameBuffer(mPosEffect,0, 0, 0, 0, 1280, 720);
	}
	
}