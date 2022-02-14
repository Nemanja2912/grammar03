package modules03.mod0305 
{
	import aze.motion.eaze;
	import base.events.CustomEvent;
	import base.text.BasicText;
	import flash.display.Sprite;
	import flash.events.Event;
	import goethe.GoetheColors;
	import gui.input.SpecialInputField;
	import gui.input.SpecialInputFieldElement;
	/**
	 * ...
	 * @author 
	 */
	public class GapFillText extends Sprite
	{
		static public const ALL_INPUTS_COMPLETE:String = "allInputsComplete";
		static public const WRONG_SOLUTION:String = "wrongSolution";
		
		private var _inputs:Array = [];
		private var _inputsComplete:Array = [];
		private var _boxes:Array = [];
		private var _w:int = 960;
		private var _leading:int = 40;
		private var _elems:Array = [];
		
		public function GapFillText(xml:XML) 
		{
			if (xml.@width != undefined) _w = int(xml.@width);
			
			_elems = [];
			//var xp:Number = 0;
			//var yp:Number = 0;
			var elem:*;
			var tmpElems:Array;
			var sifId:int = 0;
			for each(var xm:XML in xml.elem) {
				//trace("GapFillText type", xm.@type.toString());
				switch (xm.@type.toString()) {
					
					case "gap":
						
						elem = createSpecialInputField(xm, sifId);
						_inputs.push(elem);
						_inputsComplete.push(false);
						sifId ++;
						
						tmpElems = [elem];
						_elems.push(elem);
						break;
						
					case "text":
						
						var tmpArr:Array  = String(xm).split(" ");
						tmpElems = [];
						for each(var str:String in tmpArr) {
							elem = new BasicText( { text:str } );
							tmpElems.push(elem);
							_elems.push(elem);
						}
						break;
				}	
				
				if (xm.@noSpaceAfter != undefined && xm.@noSpaceAfter == "true" ) elem.customData.noSpaceAfter = true
				if (xm.@linebreakAfter != undefined && xm.@linebreakAfter == "true") elem.customData.linebreakAfter = true
				if (xm.@doubleLinebreakAfter != undefined && xm.@doubleLinebreakAfter == "true" ) elem.customData.doubleLinebreakAfter = true
				
				
				
				/*for each (var tmpElem:* in tmpElems) {
					
					if (xp + tmpElem.width > _w) {
						xp = 0;
						yp += _leading;
					}
					tmpElem.x = xp;
					tmpElem.y = yp;
					addChild(tmpElem);
					xp += tmpElem.width + 6
				}
				
				if (xm.@linebreakAfter != undefined && xm.@linebreakAfter == "true" && xp > 0) {
					xp = 0;
					yp += _leading;
				}
				if (xm.@doubleLinebreakAfter != undefined && xm.@doubleLinebreakAfter == "true" && xp > 0) {
					xp = 0;
					yp += _leading*1.4;
				}
				
				if (xm.@type.toString() == "gap") tmpElem.x += 4
				*/

			}
			
			positionElems()

		}
		
		private function createSpecialInputField(xm:XML, id:int):SpecialInputField 
		{
			var elem:SpecialInputField = new SpecialInputField( { targetText:xm } );
			elem.customData.isSolved = false;
			elem.id = id;
			elem.addEventListener(SpecialInputField.ALL_FILLED_OUT, onInputFieldAllFilled);
			elem.addEventListener(SpecialInputField.ARROW_LEFT_OUT, onInputFieldArrowLeftOut);
			elem.addEventListener(SpecialInputField.ARROW_RIGHT_OUT, onInputFieldArrowRightOut);
			elem.addEventListener(SpecialInputField.TEXT_COMPLETE, onInputFieldTextComplete);
			elem.addEventListener(SpecialInputField.DELETE_LEFT_OUT, onInputFieldDeleteLeftOut);
			elem.addEventListener(SpecialInputField.ELEMENT_ACTIVATED, onInputFieldElementActivated);
			elem.addEventListener(SpecialInputField.PRESS_ENTER, onInputFieldEnter);
			elem.addEventListener(SpecialInputField.ALL_FILLED_OUT_WRONG, onAllFilledOutWrong);
			
			var box:Sprite = new Sprite();
			box.graphics.beginFill(GoetheColors.LIGHT_BLUE);
			box.graphics.drawRoundRect(-4, -5, elem.width+6, 45, 16,16);
			//box.x = xp;
			//box.y = yp;
			elem.addChildAt(box, 0);
			_boxes.push(box);
			
			return elem;
		}
		
		
		private function positionElems():void {
			
			var xp:Number = 0;
			var yp:Number = 0;
			for each (var tmpElem:* in _elems) {
				
				if (xp + tmpElem.width > _w) {
					xp = 0;
					yp += _leading;
				}
				tmpElem.x = xp;
				tmpElem.y = yp;
				addChild(tmpElem);
				
				var space:int = (tmpElem.customData.noSpaceAfter == true) ? 0 : 6;
				
				xp += tmpElem.width + space;
				
				if (tmpElem.customData.linebreakAfter == true && xp > 0) {
					xp = 0;
					yp += _leading;
				}
				if (tmpElem.customData.doubleLinebreakAfter == true  && xp > 0) {
					xp = 0;
					yp += _leading*1.4;
				}
				
				//trace("tmpElem is SpecialInputField", tmpElem is SpecialInputField);
				if (tmpElem is SpecialInputField) {
					
					tmpElem.x += 4;
				}
			}
		}
		
		private function onAllFilledOutWrong(e:CustomEvent):void 
		{
			var input:SpecialInputField = e.param.specialInputField as SpecialInputField
			//eaze(_boxes[input.id]).apply( { tint:GoetheColors.ORANGE } );
			var allFieldsFilled:Boolean = true;
			//var i:int = 0;
			for each(var inp:SpecialInputField in _inputs) {
				if (inp.text.length < inp.targetText.length) allFieldsFilled = false;
			}
			if (allFieldsFilled) dispatchEvent (new CustomEvent(WRONG_SOLUTION, false, false));
		}
		
		public function deactivate():void 
		{
			for each(var f:SpecialInputField in _inputs) {
				f.deactivate();
			}
		}
		public function unsetFocus():void {
			for each( var sif:SpecialInputField in _inputs) {
				sif.unsetFocus()
			}
		}
		
		
		public function setFocus():void 
		{
			(_inputs[0] as SpecialInputField).activateElem(0);
		}
		
		public function markWrongFields():void 
		{
			var i:int = 0;
			for each(var inp:SpecialInputField in _inputs) {
				if (inp.text != inp.targetText) {
					//eaze(_boxes[i]).apply( { tint:GoetheColors.ORANGE } );
				}
				
				i++;
			}
		}
		
		private function onInputFieldEnter(e:CustomEvent):void 
		{
			var field:SpecialInputField = e.param.inputField as SpecialInputField;
			if (field == _inputs[_inputs.length - 1]) {
				dispatchEvent(new CustomEvent(WRONG_SOLUTION, true, false));
			}
			
		}
		
		// ein inputfield per klick aktiviert -> andere deaktivieren!
		private function onInputFieldElementActivated(e:CustomEvent):void 
		{
			var field:SpecialInputField = e.param.specialInputField as SpecialInputField
			for each(var f:SpecialInputField in _inputs) {
				if (f != field) {
					f.unsetFocus();
				}
				
			}
		}
		
		private function onInputFieldDeleteLeftOut(e:CustomEvent):void 
		{
			var field:SpecialInputField = e.param.specialInputField as SpecialInputField
			var prevF:SpecialInputField = getPreviousUnsolvedInputFieldTo(field);
			if (prevF) {
				field.unsetFocus()
				prevF.activateElem(prevF.elemsNum - 1);
				(prevF.elems[prevF.elemsNum-1] as SpecialInputFieldElement).text = " ";
			}
		}
		
		private function onInputFieldTextComplete(e:CustomEvent):void 
		{
			var field:SpecialInputField = e.param.specialInputField as SpecialInputField
			_inputsComplete[field.id] = true;
			eaze(_boxes[field.id]).apply( { tint:GoetheColors.GREEN } );
			activateNextInputField(field);
			field.unsetFocus()// das field auf jeden fall nicht mehr bearbeitbar machen
			field.mouseChildren = field.mouseEnabled = false;
			field.customData.isSolved = true;
			if (allInputsComplete()) {
				dispatchEvent(new Event(ALL_INPUTS_COMPLETE));
			}
		}
		
		private function allInputsComplete():Boolean 
		{
			for each(var com:Boolean in _inputsComplete) {
				if (!com) return false;
			}
			return true;
		}
		
		private function onInputFieldArrowRightOut(e:CustomEvent):void 
		{
			var field:SpecialInputField = e.param.specialInputField as SpecialInputField
			var nextF:SpecialInputField = getNextUnsolvedInputFieldTo(field);
			if (nextF) {
				field.unsetFocus()
				nextF.activateElem(0);
			}
		}
		
		private function onInputFieldArrowLeftOut(e:CustomEvent):void 
		{
			var field:SpecialInputField = e.param.specialInputField as SpecialInputField
			var prevF:SpecialInputField = getPreviousUnsolvedInputFieldTo(field);
			if (prevF) {
				field.unsetFocus()
				prevF.activateElem(prevF.elemsNum-1);
			}
		}
		
		private function onInputFieldAllFilled(e:CustomEvent):void 
		{
			var field:SpecialInputField = e.param.specialInputField as SpecialInputField
			activateNextInputField(field);
			
		}
		
		private function activateNextInputField(field:SpecialInputField):void {
			var nextF:SpecialInputField = getNextUnsolvedInputFieldTo(field);
			if (nextF) {
				field.unsetFocus()
				nextF.activateElem(0);
			}
		}
		
		
		private function getNextUnsolvedInputFieldTo(f:SpecialInputField):SpecialInputField {
			for (var i:int = f.id + 1; i < _inputs.length; i++) {
				if (!_inputs[i].customData.isSolved) return _inputs[i];
			}
			return null;
		}
		
		private function getPreviousUnsolvedInputFieldTo(f:SpecialInputField):SpecialInputField {
			for (var i:int = f.id - 1; i >= 0; i--) {
				if (!_inputs[i].customData.isSolved) return _inputs[i];
			}
			return null;
		}
		
		public function switchGap(gapId:int, gapXml:XML):void {
			var i:int = 0;
			for each(var elem:* in _elems) {
			//	trace ("elem", elem, i);
				if (elem is SpecialInputField && i == gapId) {
				//	trace("REPLACE", elem);
					var newElem:SpecialInputField = createSpecialInputField(gapXml, elem.id);
					_elems.splice(_elems.indexOf(elem), 1, newElem);
					_inputs.splice(_inputs.indexOf(elem), 1, newElem);
					elem.parent.removeChild(elem);
					i++
				}
				
			}
			positionElems();
			
			
		}
		
		public function help():void {
			
			var inpToFill:SpecialInputField 
			for (var i:int = _inputsComplete.length-1; i >= 0 ; i--) {// :SpecialInputField in _inputs) {
				if (_inputsComplete[i] == false) {
					inpToFill = (_inputs[i] as SpecialInputField)
				}
			}
			
			if (inpToFill != null) inpToFill.help();
			
			for each(var inp:SpecialInputField in _inputs) {
				if (inp != inpToFill) inp.unsetFocus();
			}
			
			
		}
		
		
		public function get inputs():Array 
		{
			return _inputs;
		}
		
	}

}