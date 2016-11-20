package com.panelUI ;

/**
 * ...
 * @author Joaquin
 */
class Tweens 
{
	inline private static var b:Float = 0;
	inline private static var c:Float = 1;
	inline private static var d:Float = 1;
	public static function LINEAR(t:Float):Float
	{
		return t;
	}
	
	static public function EASE_IN_OUT(t:Float):Float 
	{
		var ts:Float=(t/=d)*t;
		var tc:Float=ts*t;
		return b+c*(6*tc*ts + -15*ts*ts + 10*tc);
	}
	static public function ELASTIC_OUT_SMALL(t:Float):Float 
	{
		var ts:Float=(t/=d)*t;
		var tc:Float=ts*t;
		return b+c*(33*tc*ts + -106*ts*ts + 126*tc + -67*ts + 15*t);
	}
	static public function ELASTIC_OUT_BIG(t:Float):Float 
	{
		var ts:Float=(t/=d)*t;
		var tc:Float=ts*t;
		return b+c*(56*tc*ts + -175*ts*ts + 200*tc + -100*ts + 20*t);
	}
	static public function ELASTIC_IN_SMALL(t:Float):Float 
	{
		var ts:Float=(t/=d)*t;
		var tc:Float=ts*t;
		return b+c*(33*tc*ts + -59*ts*ts + 32*tc + -5*ts);
	}
	static public function ELASTIC_IN_BIG(t:Float):Float 
	{
		var ts:Float=(t/=d)*t;
		var tc:Float=ts*t;
		return b+c*(56*tc*ts + -105*ts*ts + 60*tc + -10*ts);
	}
	static public function BACK_IN(t:Float):Float 
	{
			var ts:Float=(t/=d)*t;
			var tc:Float=ts*t;
			return b+c*(4*tc + -3*ts);
	}
	static public function BACK_OUT(t:Float):Float 
	{
			var ts:Float=(t/=d)*t;
			var tc:Float=ts*t;
			return b+c*(-6.1475*tc*ts + 22.3925*ts*ts + -28.99*tc + 13.895*ts + -0.15*t);
	}
	
	public inline static function LERP(s:Float, start:Float, finish:Float):Float
	{
		return start+s*(finish -  start);
	}
		
}

