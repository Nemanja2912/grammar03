package modules.sentences 
{

	import base.events.CustomEvent;
	import base.gui.tooltip.Tooltip;
	import base.gui.tooltip.TooltipPosition;
	import base.video.BasicVideo;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import lt.uza.utils.Global;
	import utils.StringUtils2;
	import utils.TraceUtils;

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
		private var _sentenceContainer:SentenceContainer;
		public var id:int;
		public var customData:Object = { };
		private var _args:Object ;
		private var _elemArgs:Object
		

		public static const HEIGHT:int = 34;
		
		/**
		 * 
		 * @param	xml
		 * @param	args  fixGrammar
		 *  @param	elemArgs   boxPadding, cornerRadius, fontSize, fontColor, colorHighlight, colorUnHighlight, alphaUnHighlight
		 */
		public function Sentence(xml:XML, args:Object = null, elemArgs:Object = null) // TODO commonXml unnötig?
		{	
			
			_args = args != null ? args : { };
			_elemArgs = elemArgs != null ? elemArgs : { };
			//_tooltip = global.tooltip;
			_xml = xml;
			if (_xml.@punctuationMark != undefined) _punctuationMark = _xml.@punctuationMark
			if (_xml.@customData != undefined) parseCustomData(_xml.@customData);
		//	_commonXml = commonXml;
			init();
		}
		
		private function init():void 
		{
			
			_text = "";
			_elems = [];
			var i:int = 0;
		//	var xp:Number = 0;
			for each (var xm:XML in _xml.elem ) {
				//trace(i,  _xml.elem.length() - 1)
				
				var tmpTxt:String = xm.text != undefined ? xm.text[0] : xm.toString();
				trace("tmpTxt", tmpTxt);
				_text += tmpTxt + ((i == _xml.elem.length()-1) ? _punctuationMark :  " ");
				var el:SentenceElement = new SentenceElement(this, i, xm, _elemArgs )
			//el.addEventListener(MouseEvent.CLICK, onElementClick);
				_elems.push(el);
				i++;
				//xp += el.width;
			}
			if (_args.fixGrammar == undefined || _args.fixGrammar != false) 	fixGrammar();
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
		
		public function addElement(el:SentenceElement):void {
			
			_elems.push(el);
			
		}
		
			
		public function removeElement(el:SentenceElement):void {
			//trace("Sentence::removeElement()");
			//TraceUtils.traceArray(_elems);
			if (_elems.indexOf(el) != -1) {
				_elems.splice(_elems.indexOf(el), 1);
			} else {
				trace("Sentence::removeElement() ERROR: Unable to remove element. Does not contain this element!");
			}
			//TraceUtils.traceArray(_elems);
			
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
			
			fixGrammar();
			
		}
		
		/**
		 * für MOD0104
		 * ändert die ids der SentElems anhand ihrer x-position
		 */
		public function reorderElementsByPosition( args_:Object = null):Boolean {
			var hasChanged:Boolean = false;
			
			if (args_ == null) args_ = { };
			var doFixGrammar:Boolean = (args_.fixGrammar != undefined) ? args_.fixGrammar : true;
			
			
			
			//TraceUtils.traceArray(_elems);
			
			
			
			//trace("=========================");
			
			_elems.sortOn(["x"],  Array.NUMERIC);

			
			var i:int = 0;
			for each (var el:SentenceElement in _elems) {
				if (el.id != i) {
					el.id = i;
					hasChanged = true;
				}
				i++;
			}
			if (doFixGrammar) fixGrammar();
			
			return hasChanged;
		}
		
			public function containsElement(el:SentenceElement):Boolean {
			//trace("containsElement ", _elems.indexOf(el) != -1);
			return _elems.indexOf(el) != -1;
			
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
		 * versetzt die Wörter in ihren Grundzustand, ohne Grammatik
		 */
		public function  removeGrammar():void {
			for each(var el:SentenceElement in _elems) {
				el.text = el.baseText
			}
		}
		
		/**
		 * nähestes element (auch das eigene)
		 * @param	elem
		 * @param	ignoreType
		 * @return
		 */
		public function getClosestElemTo(elem:SentenceElement, ignoreType:String = null):SentenceElement {
			var result:Object =  getClosestElemTo2(elem, ignoreType)
			return result.elem;
			
		}
		
		/**
		 * die hier gibt das element UND die distance zurück
		 * @param	elem
		 * @param	ignoreType
		 * @return
		 */
		public function getClosestElemTo2(elem:SentenceElement, ignoreType:String = null):Object {
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
			var result:Object = { elem:closestElem, dist:closestDistance } ;
			return result;
			
		}
		
		
			/**
		 * 
		 * @param	elInSentence element im satz, das ersetzt werden soll
		 * @param	newElement  element das an die stelle soll
		 */
		public function replaceElement(elInSentence:SentenceElement, newElement:SentenceElement):void {
			//trace("replaceElement ......... ");
			//trace(toString());
			
			for (var i:int = 0; i < _elems.length; i++) {
				var el:SentenceElement = _elems[i];
				
				
				
				if (el == elInSentence) {
					
					_elems.splice(i, 1, newElement);
					//newElement.x = el.basePos.x//.realX;
					newElement.x = el.basePos.x
					newElement.y =  el.basePos.y
					newElement.basePos = new Point(newElement.x, newElement.y);
					if (el.parent != null) {
						el.parent.addChild(newElement);
						el.parent.removeChild(el);
						//(newElement.parent.parent as SentenceContainer).updateSentencePositions(newElement.sentence); // hier nicht updaten, mach durcheinander
					}
					
						//trace("replaceElement _elems.length", _elems.length);
					break;
				}
				
			}
				//trace(toString());
			
		}
		
		
		private function parseCustomData(str:String):void 
		{
			var tmpObj:Object = StringUtils2.stringToObject(str);
			for (var key:String in tmpObj) {
				customData[key] = tmpObj[key];
			}
		}
		
		override public function toString():String {
			
			var str:String = (" [Sentence] ");
			for each (var el:SentenceElement in _elems) {
				str += el.toString();
			}
			return str;
			
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
		
		public function get currentText():String {
			var txt:String = "";
			var i:int = 0;
			for each(var el:SentenceElement in _elems) {
				txt += el.text + ((i == _elems.length - 1) ? _punctuationMark :  " ");
				i++;
			}
			
			return txt;
			
		}
		
		public function get sentenceContainer():SentenceContainer 
		{
			return _sentenceContainer;
		}
		
		public function set sentenceContainer(value:SentenceContainer):void 
		{
			_sentenceContainer = value;
		}
		
	
	}

}