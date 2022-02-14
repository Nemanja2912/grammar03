package modules03.mod0303 
{
	import base.text.BasicText;
	import flash.display.Sprite;
	import goethe.GoetheColors;
	/**
	 * ...
	 * @author 
	 */
	public class Mod03Table extends Sprite
	{
		
		private var _cont:Sprite = new Sprite();
		
		public static const ROW_HEIGHT:int = 50;
		public static const COL_WIDTH:int = 180;
		
		public function Mod03Table(xml:XML) 
		{
			addChild(_cont);
			
			var topRow:Sprite = new Sprite();
			topRow.graphics.beginFill(GoetheColors.GREY);
			topRow.graphics.drawRect(0, 0, COL_WIDTH*2+1, ROW_HEIGHT);
			topRow.graphics.drawRect(COL_WIDTH*2+2, 0, COL_WIDTH, ROW_HEIGHT);
			_cont.addChild(topRow);
			
			var tf:BasicText = new BasicText( { text:xml.informal, fontColor:GoetheColors.WHITE } );
			tf.y = 9;
			tf.x = (COL_WIDTH*2-tf.width)/2;
			topRow.addChild(tf);
			
			tf = new BasicText( { text:xml.formal , fontColor:GoetheColors.WHITE} );
			tf.y = 9
			tf.x = COL_WIDTH*2 + (COL_WIDTH-tf.width)/2;
			topRow.addChild(tf);
			
			topRow.graphics.beginFill(GoetheColors.GREY_30);
			topRow.graphics.drawRect(0, ROW_HEIGHT+1, COL_WIDTH, ROW_HEIGHT);
			topRow.graphics.drawRect(COL_WIDTH+1, ROW_HEIGHT+1, COL_WIDTH, ROW_HEIGHT);
			topRow.graphics.drawRect(COL_WIDTH * 2 + 2, ROW_HEIGHT + 1, COL_WIDTH, ROW_HEIGHT);
			
			tf = new BasicText( { text:"Singular" , fontColor:GoetheColors.GREY_50 } );
			tf.y = 60
			tf.x = COL_WIDTH*0 + (COL_WIDTH-tf.width)/2;
			topRow.addChild(tf);
			
			tf = new BasicText( { text:"Plural" , fontColor:GoetheColors.GREY_50 } );
			tf.y = 60
			tf.x = COL_WIDTH*1 + (COL_WIDTH-tf.width)/2;
			topRow.addChild(tf);
			
			tf = new BasicText( { text:"Singular/Plural" , fontColor:GoetheColors.GREY_50 } );
			tf.y = 60
			tf.x = COL_WIDTH*2 + (COL_WIDTH-tf.width)/2;
			topRow.addChild(tf);
			
		}
		
	}

}