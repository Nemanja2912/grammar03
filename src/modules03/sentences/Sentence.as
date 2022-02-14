package modules03.sentences 
{

	import base.events.CustomEvent;
	import base.gui.tooltip.Tooltip;
	import base.gui.tooltip.TooltipPosition;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import lt.uza.utils.Global;

	/**
	 * ...
	 * @author andreasmuench.de
	 */
	public class Sentence extends Sprite
	{
		//private var global:Global = Global.getInstance();
		//private var _tooltip:Tooltip;
		private  var _xml:XML;
		private var _commonXml:XML;
		private var _text:String; // complete Sentence
		private var _elems:Array;
		private var _punctuationMark:String = ".";
		public var id:int;
		public var customData:Object = { };
		

		public static const HEIGHT:int = 34;
		
		public function Sentence(xml:XML) // TODO commonXml unnötig?
		{	
			//_tooltip = global.tooltip;
			_xml = xml;
			if (_xml.@punctuationMark != undefined) _punctuationMark = _xml.@punctuationMark
		//	_commonXml = commonXml;
			init();
		}
		
		private function init():void 
		{
			
			_text = "";
			_elems = [];
			var i:int = 0;
		//	var xp:Number = 0;
			for each (var x:XML in _xml.elem ) {
			//	trace(i,  _xml.elem.length()-1)
				_text += x.toString() + (i == _xml.elem.length()-1) ? _punctuationMark :  " ";
				var el:SentenceElement = new SentenceElement(this, i, x)
			//el.addEventListener(MouseEvent.CLICK, onElementClick);
				_elems.push(el);
				i++;
				//xp += el.width;
			}
			
			fixGrammar();
		}
		
		
		
		public function removeInteractivity():void {
			//for (var i:int = 0; i < numChildren; i++) {
			//	var el:SentenceElement = getChildAt(i) as SentenceElement;
			for each(var el:SentenceElement in _elems) {
				//el.removeEventListener(MouseEvent.CLICK, onElementClick);
				el.removeInteractivity();
			}
			
			
			
		}
		
		public function addInteractivity(type:String = null):void {
			//for (var i:int = 0; i < numChildren; i++) {
			//	var el:SentenceElement = getChildAt(i) as SentenceElement;
			for each(var el:SentenceElement in _elems) {
				//el.removeEventListener(MouseEvent.CLICK, onElementClick);
				if (type == null || el.type == type) {
					el.addInteractivity();
				}
				
			}
			
		}
		
		public function moveToBase():void {
			for each (var el:SentenceElement in _elems) {
				el.moveTo(el.basePos.x, el.basePos.y);
			}
			
			
		}
		
		/**
		 * remembers the current position in _basePos
		 */
		public function setCurPosAsBasePos():void {
			for each (var el:SentenceElement in _elems) {
				if (el.targetPos != null) {
					el.basePos = el.targetPos;
				}
				else {
					el.basePos = new Point(el.x, el.y);
				}
			}
			
			
		}
		
		
		
		/**
		 * für MOD0103
		 * @param	el1 dieses element ...
		 * @param	el2 soll an die stelle von diesem Element
		 */
		public function reorderSentence(el1:SentenceElement, el2:SentenceElement):void {
			
			var tmpId:int = el1.id;
			el1.id = el2.id;
			el2.id = tmpId;
			
			_elems.sortOn(["id"]);
			//trace("sortedElems", _elems);
			
			fixGrammar();
			
		}
		
		/**
		 * repariert nach umsortierung des Satzes den 1. Großen Buchstaben sowie den Punkt am Ende.
		 */
		public function  fixGrammar():void {
			//3trace("Sentnce::fixGrammar()");
			for each(var el:SentenceElement in _elems) {
				if (el.id == 0) { // erster Satzteil -> Buchstabe groß
					el.text = el.baseText.substr(0, 1).toUpperCase() + el.baseText.substr(1);
					//trace( el.baseText.substr(0, 1).toUpperCase() + el.baseText.substr(1))
					
				} else if (el.id == _elems.length - 1) { // letzter Satzteil -> Punkt
					el.text = el.baseText + _punctuationMark;
				} else {
					el.text = el.baseText;
				}
				
				//trace("el.text", el.id,el.text);
			}
			
		}
		
		/**
		 * nähestes element (auch das eigene)
		 * @param	elem
		 * @param	ignoreType
		 * @return
		 */
		public function getClosestElemTo(elem:SentenceElement, ignoreType:String = null):SentenceElement {
			var closestDistance:Number = 9999999999;
			
			for each (var el:SentenceElement in _elems) {
				if ((ignoreType == null || ignoreType != el.type)) {//el != elem && 
					var dist:Number = Math.abs((el.basePos.x + el.width / 2) - (elem.x + elem.width / 2));
					if (dist < closestDistance) {
						var closestElem:SentenceElement = el;
						closestDistance = dist;
					}
				}
			}
			return closestElem;
			
		}
		
		////////////////////////////////////////////////////////////////////////////////
		//////////  GETTERS / SETTERS
		////////////////////////////////////////////////////////////////////////////////
		
		public function get text():String {
			return _text;
			
		}
		
		public function get elems():Array 
		{
			return _elems;
		}
		
	
	}

}