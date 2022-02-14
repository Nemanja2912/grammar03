package modules03.mod0304 
{
	import aze.motion.eaze;
	import base.events.CustomEvent;
	import base.text.BasicText;
	import flash.display.Sprite;
	import flash.events.Event;
	import goethe.GoetheColors;
	import gui.input.SpecialInputField;
	import gui.input.specialKeyboard.MobileKeyboard;
	import gui.popIcon.PopIcon;
	/**
	 * ...
	 * @author 
	 */
	public class Mod04TableRowPresent extends Sprite
	{
		static public const PRESENT_DONE:String = "presentDone";
		
		private var _bg:Sprite = new Sprite();
		private var _elems:Vector.<Mod04TableRowPresentElement> = new Vector.<Mod04TableRowPresentElement>();
		protected var _textsComplete:Array = [0, 0, 0];
		
		public function Mod04TableRowPresent(xml:XML) 
		{
			
			
			addChild(_bg);
			_bg.graphics.beginFill(GoetheColors.LIGHT_BLUE);
			_bg.graphics.drawRect(0, 0, 159, Mod04TableRowPresentElement.HEIGHT - 1);
			
		
			
			var tf:BasicText = new BasicText( { text: "Präsens-<br>Formen<br>bilden", multiline:true, width:130, fontSize:16,  textAlign:"center" , fontColor:0xffffff} );
			tf.x = 10;
			tf.y = 11;
			addChild(tf);
			
			
			var i:int = 0;
			var pp:String;
			//trace(">>>>>>>>>>>>>>>>>>>>" , xml);
			for each(var ex:XML in xml.elem) {
				
				if (i == 0) pp = "du";
				else if (i == 1) pp = "ihr";
				else if (i == 2) pp = "Sie";
				
				var el:Mod04TableRowPresentElement = new Mod04TableRowPresentElement( pp, ex);
				el.id = i;
				el.addEventListener(SpecialInputField.TEXT_COMPLETE, onTextComplete);
				el.addEventListener(SpecialInputField.ALL_FILLED_OUT_WRONG, onTextFilledWrong);
				el.addEventListener(SpecialInputField.ELEMENT_ACTIVATED, onInputElementActivated);
				el.x = Mod04Table.FIRST_COL_WIDTH + i * Mod04TableRowPresentElement.WIDTH;
				
				addChild(el);
				_elems.push(el);
				i++;
			}
			
			
			
			
		}
		
	
		
		public function activateFocus():void 
		{
			for each(var el:Mod04TableRowPresentElement in _elems) {
				if (!el.done) {
					el.activateFocus();
					break;
				}
			}
		}
		
		public function deactivateFocus():void 
		{
			for each(var el:Mod04TableRowPresentElement in _elems) {
				if (!el.done) {
					el.deactivateFocus();
					break;
				}
			}
		}
		
		
		private function onInputElementActivated(e:CustomEvent):void 
		{
			var input:SpecialInputField = e.param.specialInputField as SpecialInputField;
			for each(var  el:Mod04TableRowPresentElement in _elems) {
				if (el.input != input) el.input .unsetFocus();
				
			}
			
			
		}
		
		
		private function onTextFilledWrong(e:CustomEvent):void 
		{
			var input:SpecialInputField = e.param.specialInputField as SpecialInputField
			
			var el:Mod04TableRowPresentElement  = input.parent as Mod04TableRowPresentElement;
			el.onTextWrong(); // grün machen
			
				dispatchEvent(new Event(PopIcon.EVENT_WRONG, true));
		}
		
		private function onTextComplete(e:CustomEvent):void 
		{
			trace("Mod04TableRowPresent::onTextComplete  (MobileKeyboard.HIDE_KEYS,")
			//dispatchEvent(new CustomEvent(MobileKeyboard.HIDE_KEYS, true));
			
			
			var input:SpecialInputField = e.param.specialInputField as SpecialInputField
			input.deactivate();
			
			var el:Mod04TableRowPresentElement  = input.parent as Mod04TableRowPresentElement;
			el.onTextComplete(); // grün machen
			
			if (el.id < 2 && _textsComplete[el.id+1] == 0) { // nächstes input aktivieren
				SpecialInputField(_elems[el.id +1].input).activateElem(0);
			} else if (el.id == 0 && _textsComplete[el.id+2] == 0) { // wenn mittleres schon gemacht ist, gleich zum letzten springen
				SpecialInputField(_elems[el.id +2].input).activateElem(0);
			}
			
			_textsComplete[el.id] = 1;
			if (_textsComplete.indexOf(0) == -1) {
				dispatchEvent(new Event(PRESENT_DONE));
				eaze(_bg).apply( { tint:GoetheColors.GREY_75 } );
			}
			
			
			
			
			
		}
		
		public function help():void {
			trace("HELP");
			var curElem:Mod04TableRowPresentElement;
			if (_textsComplete[0] == 0) curElem = _elems[0];
			else if (_textsComplete[1] == 0) curElem = _elems[1];
			else if (_textsComplete[2] == 0) curElem = _elems[2];
			
			curElem.input.help();
			
			
		}
		
		
	}

}