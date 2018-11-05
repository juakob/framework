package com.panelUI;
/**
 * ...
 * @author Joaquin
 */
class PanelEvent 
{
	public var type:String;
	public var data:Dynamic;
	public function new(){}
	private static var m_i:PanelEvent = new PanelEvent();
	public static function weak(type:String,data:Dynamic=null):PanelEvent
	{
		m_i.type = type;
		m_i.data = data;
		return m_i;
	}
}