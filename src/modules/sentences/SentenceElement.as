package modules.sentences 
{
	import aze.motion.easing.Back;
	import aze.motion.easing.Elastic;
	import aze.motion.eaze;
	import base.events.CustomEvent;
	import base.gui.Padding;
	import base.text.BasicText;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import goethe.GoetheColors;
	import utils.StringUtils2;
	import utils.TraceUtils;
	/**
	 * ...
	 * @author andreasmuench.de
	 */
	public class SentenceElement extends Sprite
	{
		
		private  var _xml:XML;
		private var _type:String;
		private var _args:Object;
		private var _baseText:String;
		private var _id:int;
		private var _sentence:Sentence ; // Parent Sentence
		private var _cont:Sprite;
		private var _box:Sprite;
		private var _tf:BasicText;
		private var _basePos:Point; // gemerkte position, auf die je nach modul zurückgesetzt wird
		private var _targetPos:Point; // position, zu der z.b. bewegt wird
		//private var _sentX:Number ; // x-pos of this element in the sentence
		private var  _boxPadding:Padding = new Padding([1, 2, 1, 2]);
		private var _cornerRadius:Number = 10;
		private var _colorHighlight:uint = 0xdddddd;
		//private var _alphaHighlight:Number = 1;
		private var _colorUnHighlight:uint = 0xffffff;
		private var _alphaUnHighlight:Number = 0;
		private var _linebreakAfter:Boolean = false; // Zeilenumbruch nach diesem Element
		private var _noSpaceBefore:Boolean = false; // wenn true, wird vor diesem Element kein Space eingebaut (sinnvoll wegen Satzzeichn)
		private var _boxAlphaTar:Number = -1 // alpha zu dem die box tweent
		private var _original:SentenceElement; // wenn es ein clone ist, ist das das original
		public var customData:Object = { }
		

		public static const ELEM_CLICKED:String = "elementClicked";
		public static const ELEM_MOUSE_DOWN:String = "elementMouseDown";
		
		
		private static const SHAKE_STRENGTH:int = 6;
		private var _fontColor:uint = 0x000000;
		private var _fontSize:Number = -1;
		
		
		/**
		 * 
		 * @param	sentence
		 * @param	id_
		 * @param	xml
		 * @param	args boxPadding, cornerRadius, fontColor, fontSize, colorHighlight, colorUnHighlight, alphaUnHighlight
		 */
		public function SentenceElement(sentence:Sentence , id_:int, xml:XML,  args:Object = null) 
		{
			_args = args//eigentlich nur für clone
			if (args != null) {
				if (args.colorHighlight != undefined) _colorHighlight = args.colorHighlight;
				if (args.colorUnHighlight != undefined) _colorUnHighlight = args.colorUnHighlight;
				if (args.alphaUnHighlight != undefined) _alphaUnHighlight = args.alphaUnHighlight;
				if (args.boxPadding != undefined) _boxPadding = args.boxPadding;
				if (args.cornerRadius != undefined) _cornerRadius = args.cornerRadius;
				if (args.fontColor != undefined) _fontColor = args.fontColor;
				if (args.fontSize != undefined) _fontSize = args.fontSize;
			}
			
			//TraceUtils.traceObject(args);
			
			_id = id_;
			_sentence = sentence;
			//_sentX = sentX;
			_xml = xml;
			
			if (_xml.@noSpaceBefore == "true") _noSpaceBefore = true;
			if (_xml.@linebreakAfter == "true") _linebreakAfter = true;
			if (_xml.@customData != undefined) parseCustomData(_xml.@customData);
			
			
			_type = _xml.@type;
			if (_type == "") _type = "unknownElement";
			
			_cont = new Sprite();
			addChild(_cont);
			
			_box = new Sprite();
			_cont.addChild(_box);
			
			_baseText = _xml.text.toString() != "" ? _xml.text.toString() : _xml.toString() //+ (lastElement ? "." : "");
		//	trace("_fontSize", _fontSize);
			var txtArgs:Object =  { txt:_baseText, fontColor:_fontColor }// , fontSize:_fontSize}
			if (_fontSize != -1) txtArgs.fontSize = _fontSize
			_tf = new BasicText(txtArgs );
			_tf.mouseChildren = _tf.mouseEnabled = false;
			_cont.addChild(_tf);
			
			if (_xml.@width != undefined) {
				_tf.width =_xml.@width;
			}
			if (_xml.@height != undefined) {
				_tf.height  =_xml.@height;
			}
			
			drawBox();
			
			addInteractivity();
			
			unhighlight(0);
			
			
			
		}
		
	
		
		private function drawBox():void {
			_box.graphics.clear();
			_box.graphics.beginFill(0xffffff);
			//var tmpTfHeight:Number = Math.max(int(_xml.@height), _tf.height);
			var tmpHeight:Number = Math.max(_tf.height + _boxPadding.top + _boxPadding.bottom, Math.max(int(_xml.@height), _fontSize + 6 + _boxPadding.top + _boxPadding.bottom) )
			//trace("tmpHeight", tmpHeight, _fontSize, _boxPadding.top , _boxPadding.bottom);
			_box.graphics.drawRoundRect(-_boxPadding.left, -_boxPadding.top, _tf.width+_boxPadding.left+_boxPadding.right, tmpHeight, _cornerRadius, _cornerRadius);
		}
		
		
		public function moveTo(xp:Number, yp:Number, alp:Number = 0, dur:Number = 1):void {
			alpha = alp;
			_targetPos = new Point(xp, yp);
		//	trace("SentenceElemen::moveTo", x+"/"+y+" =>>> "+xp+"/"+yp);
			eaze(this).to(dur, { x:xp, y:yp, alpha:1 } ).easing(Elastic.easeOut);
			
		}
		
		
		public function addInteractivity():void {
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			buttonMode = true;
		}
		
		public function removeInteractivity():void {
			removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			removeEventListener(MouseEvent.CLICK, onClick);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			buttonMode = false;
		}
		
		
		public function onMouseDown(e:MouseEvent = null):void 
		{
			//trace("md");
			
			var param:Object = { elem:this };
			if (e != null) {
				param.localX = e.localX;
				param.localY = e.localY;
			}
			dispatchEvent(new CustomEvent(ELEM_MOUSE_DOWN, true, false, param));
		}
		
		
		public function onClick(e:MouseEvent = null):void  // public für help-demonstration
		{
			dispatchEvent(new CustomEvent(ELEM_CLICKED, true, false, { elem:this } ));
		}
		
		public function shake():void {
			eaze(_cont).to(.1, { x: -SHAKE_STRENGTH } ).to(.1, { x:SHAKE_STRENGTH } ).to(.1, { x: -SHAKE_STRENGTH } ).to(.1, { x:0 } );
			
			
			
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////// MOD 0102
		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * andere satzelemente werden hinterhergezogen (bei drag)
		 */
		public function pullSiblingElements():Boolean { // retunrs ob alle Elemente angekommen sind
			
			var allInPos:Boolean = true;
			for each (var el:SentenceElement in _sentence.elems) {
				
				if (el != this) {
					var leaderEl:SentenceElement;
					if (el.id > this.id) {
						leaderEl = _sentence.elems[el.id - 1];
					} else {
						leaderEl = _sentence.elems[el.id + 1];
	
					}
					var tarX:Number = leaderEl.x + el.sentX - leaderEl.sentX;
					el.x += (tarX - el.x)/2;
					el.y += (leaderEl.y - el.y) / 2;
					
					if (Math.abs(tarX - el.x) > .12 || Math.abs(leaderEl.y - el.y) > .12) {
						//trace(Math.abs(tarX - el.x) , Math.abs(leaderEl.y - el.y));
						allInPos = false; // noch nicht am ziel
					}
			
				}
			}
			return allInPos;
		}
		
		public function placeOnVerbBar(xp:Number , yp:Number, barWidth:Number):void {
			//trace("placeOnVerbBar");
			for each (var el:SentenceElement in _sentence.elems) {
				eaze(el).killTweens();
				el.alpha = 1;
				el.visible = true;
				//el.y =  yp;
				var tx:Number;
				if (el.id < this.id) {
					//el.x = xp + el.sentX - this.sentX;
					tx = xp + el.sentX - this.sentX;
				} else if (el.id == this.id) {
					//el.x = xp + (barWidth - el.width)/2 ;
					tx= xp + (barWidth - el.width)/2 ;
				
				} else {
					//el.x = xp + barWidth + el.sentX - this.sentX - this.width;
					tx = xp + barWidth + el.sentX - this.sentX - this.width;
				}
				//trace(el.y, el.x);
				//el.basePos = el.targetPos = new Point(el.x, el.y);
				el.basePos = el.targetPos = new Point(tx, yp)
				el.moveTo(tx, yp);
			}
			
		}
		
	
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////// /MOD 0102
		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		public function onOver(e:MouseEvent=null):void 
		{
			highlight()
		}
		
		public function onOut(e:MouseEvent=null):void 
		{
			unhighlight();
		}
		
		
		
		
		public function highlightCustom(color:uint, alpha_:Number = 1, dur:int = .2):void  {
			//trace("highlightCustom");
			if (dur == 0) _box.alpha = alpha_; // fix
			eaze(_box).to(.2, { tint:color, alpha:alpha_ } );
			_boxAlphaTar = alpha_
			
			
		}
		
		public function highlight(dur:Number = .2):void  {
			if (dur == 0) _box.alpha = 1; // fix
			eaze(_box).to(dur, { tint:_colorHighlight, alpha:1 } );
			_boxAlphaTar  =1
			//eaze(_box).to(dur, { alphaVisible:1 } );
			
		}
		
		public function unhighlight(dur:Number = .2):void  {
			// trace("unhighlight", dur , _alphaUnHighlight);
			if (dur == 0) _box.alpha = _alphaUnHighlight; // fix
			eaze(_box).to(dur, { tint:_colorUnHighlight, alpha:_alphaUnHighlight } );
			_boxAlphaTar = _alphaUnHighlight
			
			//eaze(_box).to(dur, { alphaVisible:0 } );
			
		}
		
		
		public function setCurPosAsBasePos():void {
			
			if (targetPos != null) {
				basePos = targetPos;
			} else {
				basePos = new Point(x, y);
			}
	
		}
		
		
		private function parseCustomData(str:String):void 
		{
			var tmpObj:Object = StringUtils2.stringToObject(str);
			for (var key:String in tmpObj) {
				trace("SentElem::parseCustomData", key, " -> ", tmpObj[key]);
				customData[key] = tmpObj[key];
				//TraceUtils.traceObject(customData);
			}
		}
		
		
		override public function toString():String {
			
			return "[SentenceElement  id:"+id+"  text:"+text+" ]";
			
		}
		
		
		public function clone():SentenceElement {
			
			var clone:SentenceElement = new SentenceElement(_sentence, id, _xml, _args);
			clone.original = this;
			clone.basePos = _basePos;
			clone.customData = { };
			for (var key:String in customData) {
				clone.customData[key] =  customData[key];
			}
			return clone;
			
			
		}
		
		////////////////////////////////////////////////////////////////////////////////
		//////////  GETTERS / SETTERS
		////////////////////////////////////////////////////////////////////////////////
		
		public function get type():String 
		{
			return _type;
		}
		
		override public function get height():Number 
		{
			//trace("_tf.text>>" + _tf.text + "<<");
			var hg:Number = _tf.height;
			if (hg < 4) {
				//trace("hg", hg);
				hg = _box.height; // bei emptyElements
			}
			return hg;
		}
		
		public function get text():String {
			return _tf.text;
		}
		

		
		public function set text(val:String):void {
			_tf.text = val;
			drawBox();
			
		}
		
	
		
	/*	public function set htmlText(val:String):void {
			_tf.htmlText = val;
			drawBox();
			
		}
		*/
		
		/**
		 * x-pos of this element in the sentence
		 */
		public function get sentX():Number 
		{
			//return _sentX;
			var i:int = 0;
			var xp:Number = 0;
			while (i < id) {
				xp += _sentence.elems[i].width + _sentence.sentenceContainer.elementPadding; // 
				i++;
			}
			return xp;
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function get sentence():Sentence 
		{
			return _sentence;
		}
		
		public function get colorUnHighlight():uint 
		{
			return _colorUnHighlight;
		}
		
		public function set colorUnHighlight(value:uint):void 
		{
			_colorUnHighlight = value;
		}
		
		public function get basePos():Point 
		{
			return _basePos;
		}
		
		public function set basePos(value:Point):void 
		{
			_basePos = value;
		}
		
		public function get targetPos():Point 
		{
			return _targetPos;
		}
		
		public function set targetPos(value:Point):void 
		{
			_targetPos = value;
		}
		
		public function set id(value:int):void 
		{
			_id = value;
		}
		
		public function get baseText():String 
		{
			return _baseText;
		}
		
		public function get xml():XML 
		{
			return _xml;
		}
		/**
		 * rechnet container-offset mit ein
		 */
		public function get realX():Number 
		{
			return x;
		}
		
		public function set alphaUnHighlight(value:Number):void 
		{
			_alphaUnHighlight = value;
		}
		
		public function set colorHighlight(value:uint):void 
		{
			_colorHighlight = value;
		}
		
		public function get textWidth():Number {
			
			return _tf.textWidth;
		}
		
		/**
		 * gibt die passende Größe an.
		 * Wenn die Box sichtbar ist, wird sie in die Größe mit einbezogen, ansonsten nur das sichtbare Textfeld
		 */
		public function get widthAdvanced():Number {
			var w:Number;
			//trace("widthAdvanced", _box.visible, _box.alpha, _boxAlphaTar);
			if (_box.visible && _box.alpha > 0 && _boxAlphaTar != 0) {
				w = _box.width - _boxPadding.left - _boxPadding.right;
			} else {
				w = _tf.textWidth +5
			}
			//trace("w", w);
			return w;
		}
		
		public function get noSpaceBefore():Boolean 
		{
			return _noSpaceBefore;
		}
		
		public function get linebreakAfter():Boolean 
		{
			return _linebreakAfter;
		}
		
		public function get original():SentenceElement 
		{
			return _original;
		}
		
		public function set original(value:SentenceElement):void 
		{
			_original = value;
		}
		
		public function get box():Sprite 
		{
			return _box;
		}
		
		public function get tf():BasicText 
		{
			return _tf;
		}
		
		
		/**
		 * gibt die passende Größe an.
		 * Wenn die Box sichtbar ist, wird sie in die Größe mit einbezogen, ansonsten nur das sichtbare Textfeld
		 */
	/*	public function get heightAdvanced():Number {
			var w:Number;
			if (_box.visible && _box.alpha > 0) {
				w = _box.width;
			} else {
				w = _tf.textWidth
			}
			return w;
		}
		*/
		
	}

}