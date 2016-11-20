package com.panelUI;

import com.MyList;
import com.framework.utils.Entity;
import com.framework.utils.SimpleButton;
import com.gEngine.GEngine;
import com.gEngine.display.AnimationSprite;
import com.gEngine.display.IDraw;
import com.gEngine.display.Layer;
import com.panelUI.Translate;

/**
 * ...
 * @author Joaquin
 */
class Panel extends Entity
{
	private var mComponents:Map<String,IDraw>;
	
	private var mTweenPlayer:TransitionPlayer;
	private var mContainer:Layer;
	private var mOnEvent:SimpleButton->Void;
	public var name:String;
	
	public function new(panel:String,layer:Layer,onButtonClick:SimpleButton->Void=null,fps:Float=60) 
	{
		super();
		name = panel;
		mComponents = new Map<String,IDraw>();
		mTweenPlayer = new TransitionPlayer();
		mContainer = new Layer();
		layer.addChild(mContainer);
		mOnEvent = onButtonClick;
		
		var components:MyList<String> = GEngine.i.getComplexAnimations(panel);
		var display:AnimationSprite;
		
		for (dir in components) 
		{
			var animation:AnimationSprite = GEngine.i.getNewAnimation(dir);
			animation.frameRate = 1 / fps;
			display = animation;
			display.recenter();
			var name:String = dir.split(".").pop();
			
			var commands:Array<String> = name.split("_");

			mComponents.set(commands[0], animation);
			
			var commandParts:Array<String>;
			var command:String;
			var container:Layer;
			for (j in 0...commands.length) 
			{
				commandParts = commands[j].split("$");
				command = commandParts[0].toUpperCase();
				if (command == "BUTTON")
				{
					var button:SimpleButton = new SimpleButton(null,animation);
					button.userData = name.substr(0,name.length-"_button_".length);
					button.onClick = onEvent;
					addChild(button);
					continue;
				}
				if (command == "GROUP")
				{
					container = cast getComponent(commandParts[1]);
					if (container==null)
					{
						container = new Layer();
						mComponents.set(commandParts[1], container);
						mContainer.addChild(container);
					}
					container.addChild(display);
					continue;
				}
				
				
			}
			
			//animation.goToAndStop(Math.random() * (animation.totalFrames - 1));
			if(display.parent==null) mContainer.addChild(display);
		}
	}
	
	//private function onClick(e:Event):Void 
	//{
		//onEvent(PanelEvent.weak(DisplayObject(e.target).name));
	//}
	public function getComponent(name:String):IDraw
	{
		return mComponents.get(name);
	}

	override function onUpdate(aDt:Float):Void 
	{
		mTweenPlayer.update(aDt);
	}
	override private function onDestroy():Void 
	{
		mContainer.removeFromParent();
		mComponents = null;
	}
	public function setEventCallback(onButtonClick:SimpleButton->Void):Void
	{
		
	}
	public function onEvent(event:SimpleButton):Void
	{
		#if debug
		trace(event.userData);
		#end
		if (mOnEvent != null)
		{
			mOnEvent(event);
		}
	}
	
	public function addTransition(trans:ITransition) 
	{
		mTweenPlayer.addTransition(trans);
	}
	
}


