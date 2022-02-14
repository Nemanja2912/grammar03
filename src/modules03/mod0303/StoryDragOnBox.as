package modules03.mod0303 
{
	import base.text.BasicText;
	import flash.display.Sprite;
	import goethe.GoetheColors;
	/**
	 * ...
	 * @author 
	 */
	public class StoryDragOnBox extends Sprite
	{
		
		public var id:int;
		private var _tf:BasicText;
		
		public function StoryDragOnBox(txt:String) 
		{
			_tf = new BasicText( { text:txt , fontColor:0xffffff} );
			addChild(_tf);
			_tf.y = 8;
			_tf.x = (240 - _tf.width) / 2;
			
			graphics.beginFill(GoetheColors.GREY_30);
			graphics.drawRoundRect(0, 0, 240, 260, 20, 20);
			
			//graphics.beginFill(0xffffff);
			//graphics.drawRoundRect(25, 60, 190, 160, 10,10);
		}
		
	}

}