package com.framework.utils;
import kha.Framebuffer;


	
class Entity
{
	private var mParent:Entity = null;
	private var mChildren:Array<Entity> = new Array<Entity>();
	private var mIsDead:Bool = false;
	public var pool(default,default):Bool;
	private var mLimbo:Bool = false;
	private var mChildrenInLimbo:Int = 0;
	
	private var sToDelete:Array<Int> = new Array();
	
	public function new() 
	{
		
	}
	
	/////////////////////////////////////
	public function update(aDt:Float):Void
	{
		var counter:Int=0;
		for ( child in mChildren ) {
			if (child.mLimbo) 
			{
				++counter;
				continue;
			}
			child.update(aDt);
			if ( child.isDead() ) {
				if (pool)
				{
					child.mLimbo = true;
					child.limboStart();
					++mChildrenInLimbo;
				}else {
					child.destroy();
					sToDelete.push(counter);
				}
			}
			++counter;
		}
		var offset = 0;
		for ( index in sToDelete)
		{
			mChildren.splice(index-offset, 1);
			++offset;
		}
		sToDelete.splice(0, sToDelete.length);
		onUpdate(aDt);
	}
	
	public function render():Void
	{
		for ( child in mChildren) {
			child.render();
		}
		onRender();
	}
	
	public function destroy():Void
	{
		for ( child in mChildren ) {
			child.destroy();
		}
		onDestroy();
		mParent = null;
	}
	
	private function limboStart():Void
	{
		throw "override this function recycle object";
	}
	
	public function recycle(type:Class<Entity> ):Entity
	{
		if (mChildrenInLimbo > 0)
		{
			for (child in mChildren) 
			{
				if (!child.mLimbo) continue;
				
				child.mLimbo = false;
				child.mIsDead = false;
				--mChildrenInLimbo;
				return child;
			}
		}
		var obj:Dynamic= Type.createInstance(type,[]);
		addChild(obj);
		return obj;
	}
	/////////////////////////////////////
	private function onUpdate(aDt:Float):Void
	{	
	}
	private function onRender():Void
	{	
	}
	private function onDestroy():Void
	{
	}
	
	/////////////////////////////////////
	public function die():Void
	{
		mIsDead = true;
	}
	public function isDead():Bool
	{
		return mIsDead;
	}
	
	/////////////////////////////////////
	public function addChild(aEntity:Entity):Void
	{
		mChildren.push(aEntity);
		aEntity.mParent = this;
	}
	
	public static function notify(entity:Entity, id:String, args:Dynamic):Void
	{
		var res:Bool = entity.onNotify(id, args);
		if (!res)
		{
			trace("Unhandled message: " + id + ", args: " + args);
		}
	}
	private function onNotify(id:String, args:Dynamic):Bool
	{
		return false;
	}
	
	public inline function  numAliveChildren():Int
	{
		return mChildren.length-mChildrenInLimbo;
	}
	public inline function  currentCapacity():Int
	{
		return mChildren.length;
	}
	
	public function clear():Void
	{
		for (child in mChildren) 
		{
			child.limboStart();
			child.mLimbo = true;
			child.mIsDead = true;
		}
		mChildrenInLimbo = currentCapacity();
	}
}