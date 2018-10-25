package com.framework.utils;
//import com.framework.utils.Input.TouchInfo;
import com.gEngine.display.AnimationSprite;
import com.gEngine.display.IDraw;
import com.gEngine.display.Layer;
import com.gEngine.GEngine;
import com.helpers.FastPoint;
import com.helpers.Rectangle;
import com.panelUI.ITransition;
import com.panelUI.TransitionPlayer;
import kha.math.FastVector2;


/**
 * ...
 * @author ...
 */
class SimpleButton extends Entity implements UIComponent
{
	private var mArea:Rectangle;
	
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var width(get, set):Float;
	public var height(get, set):Float;
	public var offset(default, null):FastPoint;
	public var visible(get, set):Bool;
	public var isPress(default, null):Bool;
	
	
	
	public var onClick:SimpleButton->Void;
	
	public var userData:Dynamic;
	public var camera:Camera;
	public var autoDetect:Bool = true;
	public var disable(get, set):Bool;
	var mDisable:Bool;
	
	var transitionPlayer:TransitionPlayer;
		
	public var display(default,null):AnimationSprite;
	
	public function new(aLayer:Layer ,sprite:AnimationSprite=null) 
	{
		mArea = new Rectangle();
		offset = new FastPoint();
		
		if (sprite == null)
		{
		display = GEngine.i.getNewAnimation("dummyblue");
		aLayer.addChild(display);
		}else {
		display = sprite;	
		display.goToAndStop(display.labelFrame("hit"));
		mArea = display.calculateBounds();
		display.player.play("up");
		
		}
		
		super();
		transitionPlayer = new TransitionPlayer();
	}
	
	private var oneFrameDelay:Bool;
	var touchInside:Bool;
	override public function update(aDt:Float):Void 
	{
		transitionPlayer.update(aDt);
		if(disable){
			return;
		}
		isPress = false;
		if (oneFrameDelay &&onClick!=null)
		{
			onClick(this);
			oneFrameDelay = false;
		}
		if (press())
		{
			touchInside = true;
		}
		if (Input.inst.isMouseReleased()&&autoDetect)
		{
			if(touchInside&& mouseInsideArea())
			{
				isPress = true;
				oneFrameDelay = true;
			}
			touchInside = false;
		}
		
		super.update(aDt);
		
		//display.x = mArea.x + offset.x;
		//display.y = mArea.y + offset.y;
	}
	
	/* INTERFACE com.framework.utils.UIComponent */
	
	public function handleInput():Void 
	{
		if(disable){
			return;
		}
		if (Input.inst.isMouseReleased()){
			if(mouseInsideArea())
			{
				isPress = true;
				oneFrameDelay = true;
			}
		}
		
	}
	public var multitouch:Bool;
	//var touchPoint:TouchInfo;
	var isTouching:Bool;
	var touchId:Int;

	function press():Bool
	{
		if (Input.inst.isMousePressed())
		{
			return mouseInsideArea();
		}
		return false;
	}
	function mouseInsideArea():Bool
	{
		return  mArea.contains(Input.inst.getMouseX(), Input.inst.getMouseY());
	}
	
	
	private function set_x(aX:Float):Float
	{
		display.x = aX;
		mArea.x = aX;
		return aX;
	}
	private function get_x():Float
	{
		return display.x;
	}
	
	private function set_visible(aVisible:Bool):Bool
	{
		display.visible = aVisible;
		
		return display.visible;
	}
	private function get_visible():Bool
	{
		return display.visible;
	}
	
	private function set_y(aY:Float):Float
	{
		display.y = aY;
		mArea.y = aY;
		return aY;
	}
	private function get_y():Float
	{
		return display.y;
	}
	
	private function set_width(aWidth:Float):Float
	{
		mArea.width = aWidth;
		display.scaleX = aWidth / 10;
		return aWidth;
	}
	private function get_width():Float
	{
		return mArea.width;
	}
	
	private function set_height(aHeight:Float):Float
	{
		mArea.height = aHeight;
		display.scaleY = aHeight / 10;
		return aHeight;
	}
	private function get_height():Float
	{
		return mArea.height;
	}
	override function onDestroy():Void 
	{
		display.removeFromParent();
		onClick = null;
		super.onDestroy();
	}
	public function addTransition(aTransition:ITransition)
	{
		transitionPlayer.addTransition(aTransition);
	}
	
	function get_disable():Bool 
	{
		return mDisable;
	}
	
	function set_disable(value:Bool):Bool 
	{
		display.visible = !value;
		return mDisable = value;
	}
}