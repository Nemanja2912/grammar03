package modules03.mod0302 
{
	import base.text.BasicText;
	import flash.display.Sprite;
	import goethe.GoetheColors;
	/**
	 * ...
	 * @author 
	 */
	public class SimpleWordBox extends Sprite
	{
		
		public function SimpleWordBox(txt:String) 
		{
			var tf:BasicText = new BasicText( { text:txt } );
			tf.x = 10;
			tf.y = 6;
			addChild(tf);
			graphics.beginFill(GoetheColors.GREY_30);
			graphics.drawRoundRect(0, 0, 150, 40, 20,20);
		}
		
	}

}