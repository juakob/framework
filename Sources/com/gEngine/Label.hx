package com.gEngine ;

	/**
	 * ...
	 * @author joaquin
	 */
	 class Label 
	{
		public var name:String;
		public var frame:Int;	
		public function new()
		{
			
		}
		public function clone():Label {
			var cl:Label = new Label();
			cl.name = name;
			cl.frame = frame;
			return cl;
		}
	}

