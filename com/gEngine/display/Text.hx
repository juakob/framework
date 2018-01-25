package com.gEngine.display;

import com.MyList;

/**
 * ...
 * @author Joaquin
 */
class Text extends Layer
{
	private var mLetters:MyList<AnimationSprite>;
	public var spaceSeparation:Float=40;
	public var mWidth:Float;
	public var mType:String;
	public var separation:Float;
	public var heigthSeparation:Float;
	public var text(default, set):String;
	public var letterWidth:Float = 20;
	
	public function new(type:String, aWidth:Float, aHeigthSeparation:Float = 10, aSeparation:Float = 1 ) 
	{
		super();
		mLetters = new MyList();
		mWidth = aWidth;
		mType = type;
		separation = aSeparation;
		heigthSeparation = aHeigthSeparation;
	}
	
	public function set_text(aText:String):String
	{
		text = aText;
		var words:Array<String> = aText.split(" ");
		var word:String;
		var counter:Int = 0;
		var displayLetter:AnimationSprite;
		var currentLine:Int=0;
		var currentLineWidth:Float=0;
		var currentWordWidth:Float = 0;
		var currentWordLetters:MyList<AnimationSprite> = new MyList();
		for (i in 0...words.length) 
		{
			word = words[i];
			//word=word.toLowerCase();
			for (j in 0...word.length) 
			{
				if (mLetters.length <= counter)
				{
					displayLetter = GEngine.i.getNewAnimation(mType);
					addChild(displayLetter);
					mLetters.push(displayLetter);
				}else{
					displayLetter = mLetters[counter];
					if (displayLetter.parent == null)
					{
						addChild(displayLetter);
					}
				}
				++counter;
				displayLetter.goToAndStop(displayLetter.labelFrame(word.charAt(j)));
				displayLetter.recenter();
				currentWordLetters.push(displayLetter);
				displayLetter.x = currentLineWidth+currentWordWidth+separation;
				displayLetter.y = currentLine * heigthSeparation;
				letterWidth = displayLetter.localDrawArea().side;
				currentWordWidth +=  letterWidth; //TODO take into acount frame width
				
				if (currentWordWidth + currentLineWidth > mWidth && !(currentWordWidth > mWidth))
				{
					++currentLine;
					currentLineWidth = 0;
					offsetWord(currentWordLetters, currentLine);
				}
			}
			currentLineWidth += currentWordWidth;
			currentWordWidth = 0;
			currentWordLetters.splice(0,currentWordLetters.length);
			currentLineWidth += spaceSeparation - separation;
		}
		for (k in counter...mLetters.length) 
		{
			mLetters[k].removeFromParent();
		}
		return aText;
	}
	
	private function offsetWord(currentWordLetters:MyList<AnimationSprite>, currentLine:Int):Void 
	{
		var wordlength:Float = 0;
		var letter:AnimationSprite;
		for (i in 0...currentWordLetters.length) 
		{
			letter = currentWordLetters[i];
			letter.x = wordlength;
			wordlength += separation+letterWidth;//TODO take into acount frame width
			letter.y = currentLine * heigthSeparation;
		}
	}
	public function getLetter(aId:Int):AnimationSprite
	{
		return mLetters[aId];
	}
	
}

