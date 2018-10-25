package com.framework;

import com.framework.utils.Input;
import com.framework.utils.Resource;
import com.gEngine.GEngine;
import com.gEngine.helper.Screen;
import com.helpers.CompilationConstatns;
import com.soundLib.SoundManager.SM;
import kha.Color;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.graphics2.Graphics;
import kha.math.FastMatrix2;
import kha.math.FastMatrix3;


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
	
	public var manualLoad(get, set):Bool;
	var mManualLoad:Bool;
	//////////////////////////////////////////////////////////////////////		
	public function new(aInitialState:Class<State>) 
	{
		initialState=aInitialState;
		i = this;
		
		/// Register services
		mResources = new Resource();
		mCurrentState = new State();
		Input.init();
		Input.i.screenScale.x = GEngine.virtualWidth/Screen.getWidth();
		Input.i.screenScale.y = GEngine.virtualHeight / Screen.getHeight();
		SM.init();
		init();
		
	}
	function get_manualLoad():Bool {
		return mManualLoad;
	}
	function set_manualLoad(aValue:Bool):Bool {
		mManualLoad = aValue;
		mResources.keepData = aValue;
		return mManualLoad;
	}
	private function init():Void 
	{
		changeState(Type.createInstance(initialState, []));
		//loadState(Type.createInstance(initialState, []) );
		initialState = null;
		
		Scheduler.addTimeTask(onEnterFrame, 0, 1 /60);
		System.notifyOnFrames(onRender);
		
		
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
	private var mLastFrameTime:Float = 0;
	private var mLastRealFrameTime:Float = 0;
	private function onEnterFrame():Void 
	{
		Input.i.screenScale.setTo(CompilationConstatns.getWidth() / System.windowWidth(0), CompilationConstatns.getHeight() / System.windowHeight(0));
		var time = Scheduler.time();
			mFrameByFrameTime =  time- mLastFrameTime;
			mLastFrameTime = time;
		if (!mPause) {
			TimeManager.setDelta(mFrameByFrameTime, Scheduler.realTime());
			update( 1/60 );
			Input.i.update();
		}
	}
	function onRender(aFramebuffers:Array<Framebuffer>) 
	{	
		var aFramebuffer = aFramebuffers[0];
		if (uploadTextures)
		{
			mResources.uploadTextures();
			uploadTextures = false;
			initialized = true;
			GEngine.i.draw(aFramebuffer);
			mCurrentState.init();
			return;
		}
		if (mChangeState)
		{
			mChangeState = false;
			loadState(mNextState);
			mNextState = null;
			return;
			
		}
		if (!initialized) return;
		mCurrentState.render();
		GEngine.i.draw(aFramebuffer);
		mCurrentState.draw(aFramebuffer);
		if (mPause) {
			var g2:Graphics = aFramebuffer.g2;
			g2.begin(false);
			
			g2.transformation = FastMatrix3.scale(0.75, 0.75);
			g2.color = Color.fromFloats(0.5, 0.5, 0.5, 0.5);
			g2.fillRect(0, 0, 1280, 720);
			
			g2.color = Color.fromFloats(1, 1, 1, 1);
			g2.fillTriangle(485, 270, 740, 390, 485, 510);
			
			g2.end();
		}
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
				SM.reset();
				mCurrentState.destroy();
				mResources.unload();
			}
			mCurrentState = state;
			mCurrentState.load(mResources);
			if (manualLoad) {
				mResources.loadLocal(finishUpload);
			}else
			if (!mResources.isAllLoaded())
			{
				mResources.load(finishUpload);
			}else {
				finishUpload();
			}
		//	mResources.checkFinishLoading();
	}
	private var initialized:Bool = false;
	private var initState:Bool = false;
	private var uploadTextures:Bool = false;
	private function finishUpload():Void
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
		if (mCurrentState!=null)
		{
			mCurrentState.onDesactivate();
		}
	}
	public function unpause():Void
	{
		mPause = false;
		if (mCurrentState!=null)
		{
			mCurrentState.onActivate();
		}
	}
	
}
