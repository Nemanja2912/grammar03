package modules.mod01 
{
	import base.text.BasicText;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author 
	 */
	public class ImperativeBox extends Sprite
	{
		
		private var _box:Sprite;
		private var _tf:BasicText;
		
		public function ImperativeBox(words:Array) 
		{
			
			var text:String = words.join(" ");
			
			_box = new Sprite();
			addChild(_box);
			
			_tf = new BasicText( { text:text } );
			addChild(_tf);
			
			
		}
		
	}

}