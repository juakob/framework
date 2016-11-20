package com.framework;

import com.framework.utils.Input;
import com.framework.utils.Resource;
import com.gEngine.GEngine;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;


import com.framework.utils.State;

class Simulation 
{
	private  var mCurrentState:State;
	private var mPause:Bool;
	private var mNextState:State;
	private var mChangeState:Bool;
	
	private  var initialState:Class<State>;
	
	var mResources:Resource;
	
	public static var i:Simulation;
	
	//////////////////////////////////////////////////////////////////////		
	public function new(aInitialState:Class<State>) 
	{
		initialState=aInitialState;
		i = this;
		/// Register services
		mResources = new Resource();
		mCurrentState = new State();
		Input.init();
		GEngine.init();
		init();
		
	}
	
	private function init():Void 
	{
		changeState(Type.createInstance(initialState, []));
		//loadState(Type.createInstance(initialState, []) );
		initialState = null;
		
		Scheduler.addTimeTask(onEnterFrame, 0, 1 / System.refreshRate);
		System.notifyOnRender(onRender);
		
		//stage.addEventListener(Event.ACTIVATE, onActive);
		//stage.addEventListener(Event.DEACTIVATE, onDeactivate);
		
	}
	
	
	
	private function onDeactivate():Void 
	{
		if (mCurrentState != null)
		{
			mCurrentState.onDesactivate();
		}
	}
	
	private function onActive():Void 
	{
		if (mCurrentState != null)
		{
			mCurrentState.onActivate();
		}
	}
	
	private var mFrameByFrameTime:Float = 0;
	private var mLastFrameTime:Float=0;
	private function onEnterFrame():Void 
	{
		if (!mPause) {
			var time = Scheduler.realTime();
			mFrameByFrameTime =  time- mLastFrameTime;
			mLastFrameTime = time;
			
			if (mFrameByFrameTime <= 0||mFrameByFrameTime>0.06666)
			{
				mFrameByFrameTime = 1 / 60;
			}
			TimeManager.setDelta(mFrameByFrameTime);
			update( mFrameByFrameTime );
			
		
		/// Update services
		Input.i.update();
		}
	}
	function onRender(aFramebuffer:Framebuffer) 
	{	
		if (uploadTextures)
		{
			mResources.uploadTextures();
			mCurrentState.init();
			uploadTextures = false;
			initialized = true;
			return;
		}
		if (mChangeState)
		{
			mChangeState = false;
			loadState(mNextState);
			mNextState = null;
			return;
			
		}
		mCurrentState.render();
		GEngine.i.draw(aFramebuffer);
		mCurrentState.draw(aFramebuffer);
	}
	
	//////////////////////////////////////////////////////////////////////
	/**
	 * Actualiza el estado del juego.
	 * @param	aDt lapso de tiempo entre llamados a este método.
	 */
	private function update(aDt:Float):Void
	{
		if (!initialized) return;
		
		GEngine.i.update(aDt);
		mCurrentState.update(aDt);
	}
	
	//////////////////////////////////////////////////////////////////////
	private function loadState(state:State):Void
	{
			initialized = false;
			if (mCurrentState!=null)
			{
				mCurrentState.destroy();
				mResources.unload();
			}
			mCurrentState = state;
			mCurrentState.load(mResources);
			if (!mResources.isAllLoaded())
			{
				mResources.load(initState);
			}else {
				initState();
			}
		//	mResources.checkFinishLoading();
	}
	private var initialized:Bool = false;
	private var uploadTextures:Bool = false;
	private function initState():Void
	{
		uploadTextures = true;
		//mCurrentState.init();
	}
	
	public function changeState(state:State):Void
	{
		mChangeState = true;
		mNextState = state;
		
	}
	public function pause():Void
	{
		mPause = true;
	}
	public function unpause():Void
	{
		mPause = false;
	}
	
}