package;
import kha.input.Surface;
import kha.input.Mouse;


/**
 * ...
 * @author Joaquin
 */
class VirtualGamepad
{
	private var width:Int;
	private var height:Int;
	private var scaleX:Float=1;
	private var scaleY:Float=1;
	var buttons:Array<VirtualButton>;
	var sticks:Array<VirtualStick>;
	
	var onAxisChange:Int->Float->Void;
	var onButtonChange:Int->Float->Void;
	
	public function new(width:Int,height:Int) 
	{
		Surface.get().notify(onTouchStart, onTouchEnd, onTouchMove);
		//Mouse.get().notify(onTouchStart, onTouchEnd, onTouchMove2,null,null);
		buttons = new Array();
		sticks = new Array();
		this.width=width;
		this.height=height;
	}
	public function destroy()
	{
		Surface.get().remove(onTouchStart, onTouchEnd, onTouchMove);
	}
	
	public function addButton(id:Int, x:Float, y:Float, radio:Float)
	{
		var button = new VirtualButton();
		button.id = id;
		button.x = x;
		button.y = y;
		button.radio = radio;
		buttons.push(button);
	}
	
	public function addStick(idX:Int, idY:Int, x:Float, y:Float, radio:Float)
	{
		var stick = new VirtualStick();
		stick.idX = idX;
		stick.idY = idY;
		stick.x = x;
		stick.y = y;
		stick.radio = radio;
		sticks.push(stick);
	}
	
	public function resize(width:Int, height:Int)
	{
		scaleX =   this.width/width;
		scaleY = this.height/height;
	}
	public function notify(onAxis:Int->Float->Void, onButton:Int->Float->Void):Void
	{
		onAxisChange = onAxis;
		onButtonChange = onButton;
	}
	function onTouchMove2(id:Int,x:Int,y:Int,w:Int=0) 
	{
		onTouchMove(id,x,y);
	}
	function onTouchMove(id:Int,x:Int,y:Int) 
	{
		for (stick in sticks) 
		{
			if (stick.handleInput(x * scaleX , y * scaleY))
			{
				onAxisChange(stick.idX, stick.axisX);
				onAxisChange(stick.idY, stick.axisY);
				stick.active = true;
			}
		}
	}
	
	
	function onTouchEnd(id:Int,x:Int,y:Int) 
	{
		for (button in buttons)
		{
			if (button.active)
			{
				button.active = false;
				onButtonChange(button.id, 0);
			}
		}
		for (stick in sticks) 
		{
			if (stick.active)
			{
				onAxisChange(stick.idX, 0);
				onAxisChange(stick.idY, 0);
				stick.active = false;
			}
		}
	}
	
	function onTouchStart(id:Int,x:Int,y:Int) 
	{
		for (button in buttons)
		{
			if (button.handleInput(x * scaleX, y * scaleY))
			{
				button.active = true;
				onButtonChange(button.id, 1);
			}
		}
		for (stick in sticks) 
		{
			if (stick.handleInput(x * scaleX, y * scaleY))
			{
				onAxisChange(stick.idX, stick.axisX);
				onAxisChange(stick.idY, stick.axisY);
				stick.active = true;
			}
		}
		
	}
	
}
class VirtualButton
{
	public var id:Int;
	public var x:Float;
	public var y:Float;
	public var radio:Float;
	public var active:Bool;
	public function new() { }
	public function handleInput(x:Float, y:Float):Bool
	{
		return (x -this.x)*(x -this.x) + (y - this.y)*(y - this.y) < radio * radio;
	}
}
class VirtualStick
{
	public var idX:Int;
	public var idY:Int;
	public var x:Float;
	public var y:Float;
	public var radio:Float;
	public var axisX:Float;
	public var axisY:Float;
	public var active:Bool;
	public function new() { }
	public function handleInput(x:Float, y:Float):Bool
	{
		var sqrDistance =  (x -this.x)*(x -this.x) + (y - this.y)*(y - this.y);
		if (sqrDistance < radio * radio)
		{
			var length = Math.sqrt(sqrDistance);
			axisX = ((x -this.x) / length) ;
			axisY = -((y - this.y) / length );
			
			return true;
		}
		return false;
	}
}