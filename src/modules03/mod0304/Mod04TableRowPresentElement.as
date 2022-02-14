package modules03.mod0304 
{
	import base.text.BasicText;
	import flash.display.Sprite;
	import flash.events.Event;
	import goethe.GoetheColors;
	import gui.input.SpecialInputField;
	/**
	 * ...
	 * @author 
	 */
	public class Mod04TableRowPresentElement extends Sprite
	{
		
		public var id:int;
		private var _input:SpecialInputField;
		private var _endText:String;
		private var _done:Boolean = false;
		
		public static const WIDTH:Number = 216;
		public static const HEIGHT:Number = 90;
		
		/**
		 * 
		 * @param	hl
		 * @param	pp   "du", "ihr" oder "Sie"
		 * @param	xml
		 */
		public function Mod04TableRowPresentElement( pp:String, xml:XML) 
		{
			
			graphics.beginFill(GoetheColors.GREY_30);
			graphics.drawRect(0, 0, WIDTH - 1, HEIGHT - 1);
			
			graphics.beginFill(GoetheColors.LIGHT_BLUE);
			graphics.drawRect(0, 0, WIDTH - 1, 28);
			
			var hlTf:BasicText = new BasicText( { text: pp + "-Form", fontSize:14, fontColor:0xffffff } );
			hlTf.x = (WIDTH - hlTf.width) / 2;
			hlTf.y = 4;
			addChild(hlTf);
			
			var ppTxt:String = pp//  pp.charAt(0).toUpperCase() + pp.substr(1); // du und ihr klein lassen
			var tfPp:BasicText = new BasicText( { text: ppTxt } );
			
			tfPp.y = 43;
			
			_endText = ppTxt;
			//if (xml.@strong == "true") _endText += " <b>" +xml + "</b>";
			if (xml.@endform != undefined) _endText += " "+String(xml.@endform).split("[").join("<").split("]").join(">");
			else _endText +=  " " + xml ;
			
			addChild(tfPp);
			
			trace("xml", xml);
			
			_input = new SpecialInputField( { targetText:xml } )//xml.elem.(@pp == pp)[0] } );
			//_input.addEventListener(SpecialInputField.TEXT_COMPLETE, onTextComplete);
			_input.y = tfPp.y
			
			addChild(_input);
			
			tfPp.x = (WIDTH - tfPp.width - 16 - _input.width)/2;
			_input.x = tfPp.x + tfPp.width + 16;
			
		}
		
		
		public function onTextWrong():void 
		{
			graphics.clear();
			graphics.beginFill(GoetheColors.ORANGE);
			graphics.drawRect(0, 0, WIDTH - 1, HEIGHT - 1);
			
			graphics.beginFill(GoetheColors.LIGHT_BLUE);
			graphics.drawRect(0, 0, WIDTH - 1, 28);
		}
		
		public function onTextComplete(e:Event=null):void 
		{
			
			_done = true;
			graphics.clear();
			graphics.beginFill(GoetheColors.GREEN);
			graphics.drawRect(0, 0, WIDTH - 1, HEIGHT - 1);
			
			graphics.beginFill(GoetheColors.GREEN_DARKER);
			graphics.drawRect(0, 0, WIDTH - 1, 28);
			
			//while (numChildren > 1) {
				//removeChildAt(1);
				
			//}
			for (var i:int = 1; i < numChildren; i++) {
				getChildAt(i).visible = false;
			}
			
			var tf:BasicText = new BasicText( { text: _endText,  fontColor:0x000000 } );
			tf.x = (WIDTH - tf.width) / 2;
			tf.y = 43;
			addChild(tf);
		}
		
		public function activateFocus():void 
		{
			_input.activateElem(0);
		}
		
		public function deactivateFocus():void 
		{
			_input.unsetFocus();
		}
		
		public function get input():SpecialInputField 
		{
			return _input;
		}
		
		public function get done():Boolean 
		{
			return _done;
		}
		
	}

}