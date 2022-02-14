package modules03.mod0303 
{
	import base.text.BasicText;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import goethe.GoetheColors;
	import lt.uza.utils.Global;
	/**
	 * ...
	 * @author 
	 */
	public class ImperativeTableRowPresent extends Sprite
	{
		
		private var global:Global = Global.getInstance();
		private var _stage:Stage;
	//	private var _rubTexts:Array = [];
		
		private var _rubber:McRubber;
		//private var _mouseDownPoint:Point = new Point();
		public function ImperativeTableRowPresent(xml:XML) 
		{
			
			_stage = global.stage;
			
			
			var w:int = Mod03Table.COL_WIDTH
			var h:int = Mod03Table.ROW_HEIGHT
			
			graphics.beginFill(GoetheColors.GREY_30);
			graphics.drawRect(-w-1, 0, w , h);
			graphics.drawRect(0, 0, w , h);
			graphics.drawRect(w+1, 0, w, h);
			graphics.drawRect(w * 2 + 2, 0, w, h);
			
			var tf:BasicText = new BasicText( { text:"Präsens", fontColor:GoetheColors.GREY_75 } );
			tf.x = -tf.textWidth - (w - tf.textWidth) / 2;
			tf.y = 10;
			addChild(tf)
		
			
			
			var i:int = 0;
			for each(var cx:XML in xml.col) {
			
				var txt:BasicText = new BasicText( { text:cx.present[0], fontColor:GoetheColors.GREY_75 } );
				txt.x = i *  Mod03Table.COL_WIDTH + 10 + i;
				txt.y = 10;
				addChild(txt);
			//	_rubTexts.push(rt);
				i++;
			}
			
		
			
		}
		
	
		
	}

}