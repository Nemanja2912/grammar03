package modules03.mod0301 
{
	import base.text.BasicText;
	import flash.display.Sprite;
	import goethe.GoetheColors;
	/**
	 * ...
	 * @author 
	 */
	public class Klammer extends Sprite
	{
		
		
		
		public function Klammer() 
		{
			var tf:BasicText = new BasicText( { text:"}" , fontColor:GoetheColors.GREY, fontWeight:"normal", fontSize:110} );
			addChild(tf);
		}
		
	}

}