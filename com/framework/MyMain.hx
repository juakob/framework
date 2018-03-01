package com.framework;

	import com.framework.utils.State;
	import com.framework.utils.Input;
	import com.gEngine.GEngine;
	import kha.System;


	

 class MyMain  
{
	//////////////////////////////////////////////////////////////////////
	private var mSimulation:Simulation;
	private var mGameState:Class<State>;
	
	//////////////////////////////////////////////////////////////////////
	public function new(gameState:Class<State> )
	{
		mGameState = gameState;
		initGEngine();
		init();
	}
	
	private function initGEngine():Void 
	{

		Input.init();
		var heigth=System.windowHeight();
		var width = System.windowWidth();
		if (heigth > width)
		{
			var temp = heigth;
			heigth = width;
			width = temp;
		}
		Input.i.screenScale.setTo(1280 / width, 720 / heigth);
		
		GEngine.init();
		GEngine.i.createDefaultPainters();
	}
	
	//////////////////////////////////////////////////////////////////////
	private function init():Void 
	{

		//stage.addEventListener(FocusEvent.FOCUS_OUT, pause);
		//stage.addEventListener(FocusEvent.FOCUS_IN, unpause);
		
		mSimulation = new Simulation(mGameState);
	
	}
	
	
}
	
