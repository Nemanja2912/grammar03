package modules03.sentences 
{
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
		
		public static const ELEMENT_PADDING:int = 0;
		private static const LEADING:int = 10; // 
		
		public function SentenceContainer(w:int, xOff:int = 0, yOff:int=0) 
		{
			_width = w;
			_xOff = xOff;
			_yOff = yOff;
			
			
			
			//_curPos = new Point(xp, yp); // starting offset
			_cont = new Sprite();
			addChild(_cont);
			_sentences = [];
		}
		
		public function addSentence(sent:Sentence, args:Object = null):void {
			
			if (_sentences.indexOf(sent) == -1) {
			
				var setPosInstantly:Boolean  = false;
				if (args != null) {
					if (args.setPosInstantly != undefined) setPosInstantly = args.setPosInstantly;
				}
				
				
				_sentences.push(sent);
				for each (var el:SentenceElement in sent.elems) {
					if (_curPos.x + el.width +ELEMENT_PADDING > _width) { // next line
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
					_curPos.x += el.width +ELEMENT_PADDING;
					
					_cont.addChildAt(el,0);
					
				}
			} else {
				trace("SentenceContainer ALREADY CONTAINS THIS SENTENCE");
			}
			
		}
		
		
		public function removeSentence(sent:Sentence):void {
			
			if (_sentences.indexOf(sent) != -1) {
			
				_sentences.splice(_sentences.indexOf(sent), 1);
				
			} else {
				trace("SentenceContainer DOES NOT CONTAIN THIS SENTENCE");
			}
		}
		
		
		public function reorderSentences(args:Object = null):void {
			
			_curPos = new Point();
			
			var setPosInstantly:Boolean  = false;
				if (args != null) {
				if (args.setPosInstantly != undefined) setPosInstantly = args.setPosInstantly;
			}
			
			for (var i:int = 0; i < _sentences.length; i++) {
			
				var sent:Sentence = _sentences[i];
				for each (var el:SentenceElement in sent.elems) {
					if (_curPos.x + el.width +ELEMENT_PADDING > _width) { // next line
						_curPos.y += el.height+LEADING;
						_curPos.x = 0;
					}
					//el.alpha = 0;
					//el.x = _xOff;
				//	el.y = _yOff;
					if (setPosInstantly) {
						el.x = _curPos.x;
						el.y = _curPos.y;
						el.alpha = 1;
					} else {
						el.moveTo( _curPos.x + _xOff, _curPos.y + _yOff);
					}
					_curPos.x += el.width +ELEMENT_PADDING;
					
					//_cont.addChildAt(el,0);
					
				}
			} 
			
		}
		
		
		public function containsSentence(sent:Sentence):Boolean {
			
			return _sentences.indexOf(sent) != -1;
			
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
		
		
	}

}