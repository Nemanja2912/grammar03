package modules.sentences 
{
	import aze.motion.eaze;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author andreasmuench.de
	 */
	public class SentenceContainer extends Sprite
	{
		public var id:int = 0;
		private var _cont:Sprite
		private var _width:int;
		private var _height:int;
		private var _curPos:Point = new Point();
		private var _sentences:Array;
		private var _xOff:int;
		private var _yOff:int;
		
		private var _elementPadding:int = 0;
		private var _leading:int = 10; // 
		
		
		
		/**
		 * 
		 * @param	w
		 * @param	xOff
		 * @param	yOff
		 * @param	args elementPadding
		 */
		public function SentenceContainer(w:int, xOff:int = 0, yOff:int=0, args:Object = null) 
		{
			_width = w;
			_xOff = xOff;
			_yOff = yOff;
			
			if (args != null) {
				if (args.elementPadding != undefined) _elementPadding = args.elementPadding;
				if (args.leading != undefined) _leading = args.leading;
			}
			
			
			//_curPos = new Point(xp, yp); // starting offset
			_cont = new Sprite();
			_cont.name = "SentenceContainer._cont";
			addChild(_cont);
			_sentences = [];
		}
		
		/**
		 * 
		 * @param	sent
		 * @param	args   setPosInstantly, elementPadding
		 */
		public function addSentence(sent:Sentence, args:Object = null):void {
			
			if (_sentences.indexOf(sent) == -1) {
			
				sent.sentenceContainer = this;

				_sentences.push(sent);
				for each (var el:SentenceElement in sent.elems) {
				/*	if (_curPos.x + el.width +_elementPadding > _width) { // next line
						_curPos.y += el.height+LEADING;
						_curPos.x = 0;
					}
					el.alpha = 0;
					if (el.x == 0) el.x = _xOff; // nur wenn 0, siehe Mod0204, hier werden die Elemente von einem zum anderen container gezogen, sollen also nicht von _xOff starten
					if (el.y == 0)el.y = _yOff;
					if (setPosInstantly) {
						el.x = _curPos.x + _xOff;
						el.y = _curPos.y + _yOff;
						el.alpha = 1;
					} else {
						el.moveTo( _curPos.x + _xOff, _curPos.y + _yOff);
					}
					_curPos.x += el.width +_elementPadding;
					*/
					el.alpha = 0;
					_cont.addChildAt(el,0);
					
				}
			} else {
				trace("SentenceContainer ALREADY CONTAINS THIS SENTENCE");
			}
			
			// elemente platzieren
			reorderSentences (args);
		}
		
		
		public function removeSentence(sent:Sentence):void {
			
			if (_sentences.indexOf(sent) != -1) {
			
				_sentences.splice(_sentences.indexOf(sent), 1);
				
			} else {
				trace("SentenceContainer DOES NOT CONTAIN THIS SENTENCE");
			}
		}
		
		
		
		/**
		 * platziert alle Satzelemente
		 * @param	args  setPosInstantly
		 */
		public function reorderSentences(args:Object = null):void {
			
			
			_curPos = new Point();
			
			var setPosInstantly:Boolean  = false;
			//var useTextWidth:Boolean  = false;
			if (args != null) {
				if (args.setPosInstantly != undefined) setPosInstantly = args.setPosInstantly;
				if (args.elementPadding != undefined) _elementPadding = args.elementPadding;
				//if (args.useTextWidth != undefined) useTextWidth = args.useTextWidth;
			}
			//trace("reorderSentences:: _elementPadding", _elementPadding);
			//trace("useTextWidth", useTextWidth);
			var elH:Number = 0;
			for (var i:int = 0; i < _sentences.length; i++) {
			
				var sent:Sentence = _sentences[i];
				for each (var el:SentenceElement in sent.elems) {
					var elW:Number = el.widthAdvanced//(!useTextWidth) ?  el.width : el.textWidth; // backward compatibility ... wenn box drumrum größer, will ich bei einigen Modulen haben, dass trotzdem nach der Textgröße ausgerichtet wird.
					//if (elW <= 0) elW = el.width-4; // kein Text? dann doch die boxbreite
				//	trace("el.width", el.width, "el.textWidth", el.textWidth, "elW", elW);
					
					if (el.height > elH) elH = el.height; // doofer hack: nachdem man mit Sentence.replaceElement() ein element ersetzt hat durch einen platzhalter, stimmt die höhe des elements nicht mehr mit einem normalen Textelement überein
					if (_curPos.x + elW  > _width) { // next line // +_elementPadding
						_curPos.y += elH+_leading;
						_curPos.x = 0;
					}
					if (el.noSpaceBefore) _curPos.x -= _elementPadding; // 
					if (setPosInstantly) {
						eaze(el).killTweens();
						el.x = _curPos.x + _xOff;
						el.y = _curPos.y + _yOff;
						el.alpha = 1;
					} else {
						el.moveTo( _curPos.x + _xOff, _curPos.y + _yOff, 1);
					}
					_curPos.x += elW +_elementPadding
					
					if (el.linebreakAfter ) { // linebreak
						_curPos.y += elH+_leading;
						_curPos.x = 0;
					}
					
					
				}
			} 
			
		}
		/* geht so nicht!
		public function linebreak():void {
			
			_curPos.x = 0;
			_curPos.y += Sentence(_sentences[_sentences.length - 1]).elems[0].height + LEADING;
			
			
		}
		*/

	
		public function removeAll():void {
			
			for each(var s:Sentence in _sentences) {
				//_sentences.splice(s, 1);
				for each (var el:SentenceElement in s.elems) {
					if (_cont.contains(el)) _cont.removeChild(el);
					
				}
			}	
			_sentences = [];
			_curPos.y = 0;
			_curPos.x = 0;
		}
		
		
		public function addSentenceElement(sent:Sentence, el:SentenceElement):void {
			for each(var s:Sentence in _sentences) {
				
				if (sent == null) {
					if (el.parent) el.parent.removeChild(el);
					_cont.addChild(el);
				}
				
				if (s == sent) {
					s.addElement(el);
					_cont.addChild(el);
				}
			}
		}
		
		/*
		public function updatePositions(instantPos:Boolean = false):void {
			
			_curPos = new Point();
			var positions:Array = [];
			
			_lineWidths = [];
			var line:int = 0;
			for each (var sent:Sentence in _sentences) {
				
				sent.basePosX = _curPos.x;
				sent.basePosY = _curPos.y;
				
				for each (var el:SentenceElement in sent.elems) {
					_elementHeight = el.height;  // speichern für linebreak;
					if (_curPos.x + el.width + ELEMENT_PADDING > _width) { // next line
						_lineWidths[line] = _curPos.x + el.width; // linewidth for align = center
						_curPos.y += el.height + LEADING;
						_curPos.x = 0;
						line ++;
					}
					
					positions.push(new Point(_curPos.x + _xOff, _curPos.y + _yOff));
					
					_curPos.x += el.width +ELEMENT_PADDING;
				}
				
				
			}
			_lineWidths[line] = _curPos.x -ELEMENT_PADDING // letzte nicht volle zeile
			
			// zentrieren
			var line:int = 0;
			var i:int = 0;
			if (_textAlign == "center") {
				_curPos = new Point();
				trace("SentenceContainer::updatePositions() ====>> ZENTRIEREN!");
				for each (var sent:Sentence in _sentences) {
					for each (var se:SentenceElement in sent.elems) {
						if (_curPos.x + el.width + ELEMENT_PADDING > _width) { // next line
							line ++;
						}
						positions[i].x += (_width - _lineWidths[line]) / 2;
						
						i++;
					}
				}
			}
			
			//  neue positionen zuweisen:
			var i:int = 0;
			for each (var sent:Sentence in _sentences) {	
				for each (var el:SentenceElement in sent.elems) {
					if (instantPos) {
						el.x = positions[i].x;
						el.y = positions[i].y;
					} else {
						el.moveTo( positions[i].x, positions[i].y, el.alpha);
					}
					i++;
				}
			}
			
			
		}
		*/
		
		public function removeSentenceElement(sent:Sentence, el:SentenceElement):void {
			
			//trace("SentenceContainer::removeSentenceElement()");
			for each(var s:Sentence in _sentences) {
				
				if (s == sent) {
					s.removeElement(el);
					if (_cont.contains(el)) _cont.removeChild(el);
					else trace("SentenceContainer::removeSentenceElement() WARNING: _cont does not contain this element.");
				}
				break;
			}
		}
		
	
		
		public function containsSentence(sent:Sentence):Boolean {
			
			return _sentences.indexOf(sent) != -1;
			
		}
		
		/**
		 * nähestes element (auch das eigene)
		 * @param	elem
		 * @param	ignoreType
		 * @return
		 */
		public function getClosestElemTo(elem:SentenceElement, ignoreType:String = null):Object {
			var closestElem:SentenceElement ;
			var closestDistance:Number = 9999999999;
			var sentenceWithClosestElem:Sentence;
			for each(var s:Sentence in sentences) {
				var r:Object = s.getClosestElemTo2(elem, ignoreType);
				if (r.dist < closestDistance) {
					closestElem = r.elem;
					closestDistance = r.dist;
					sentenceWithClosestElem = s;
				}
			}
			var result:Object = { elem:closestElem, dist:closestDistance, sent:sentenceWithClosestElem };
			return result
			
		}
		
		
		
		
		public function getSentence(id:int):Sentence {
			return _sentences[id];
		}
		
		override public function get numChildren():int {
			return _sentences.length;
			
		}
		
		public function get xOff():int 
		{
			return _xOff;
		}
		
		public function get yOff():int 
		{
			return _yOff;
		}
		
		public function get sentences():Array 
		{
			return _sentences;
		}
		
		public function get elementPadding():int 
		{
			return _elementPadding;
		}
		
		public function get curPos():Point 
		{
			return _curPos;
		}
		
		public function set w(value:int):void 
		{
			_width = value;
		}
		
		public function set xOff(value:int):void 
		{
			_xOff = value;
		}
		
		public function set yOff(value:int):void 
		{
			_yOff = value;
		}
		
		
	}

}