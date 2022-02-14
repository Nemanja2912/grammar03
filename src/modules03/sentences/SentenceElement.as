package modules03.sentences 
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
	/**
	 * ...
	 * @author andreasmuench.de
	 */
	public class SentenceElement extends Sprite
	{
		
		private  var _xml:XML;
		private var _type:String;
		private var _baseText:String;
		private var _id:int;
		private var _sentence:Sentence ; // Parent Sentence
		private var _cont:Sprite;
		private var _box:Sprite;
		private var _tf:BasicText;
		private var _basePos:Point; // gemerkte position, auf die je nach modul zurückgesetzt wird
		private var _targetPos:Point; // position, zu der z.b. bewegt wird
		//private var _sentX:Number ; // x-pos of this element in the sentence
		private const PADDING:Padding = new Padding([1, 2, 1, 2]);
		private var _colorHighlight:uint = 0xdddddd;
		//private var _alphaHighlight:Number = 1;
		private var _colorUnHighlight:uint = 0xffffff;
		private var _alphaUnHighlight:Number = 0;

		public static const ELEM_CLICKED:String = "elementClicked";
		public static const ELEM_MOUSE_DOWN:String = "elementMouseDown";
		
		private static const SHAKE_STRENGTH:int = 6;
		
		public function SentenceElement(sentence:Sentence , id_:int, xml:XML,  args:Object = null) 
		{
			
			if (args != null) {
				
				if (args.colorHighlight != undefined) _colorHighlight = args.colorHighlight;
				if (args.colorUnHighlight != undefined) _colorUnHighlight = args.colorUnHighlight;
				if (args.alphaUnHighlight != undefined) _alphaUnHighlight = args.alphaUnHighlight;
				
				
			}
			
			_id = id_;
			_sentence = sentence;
			//_sentX = sentX;
			_xml = xml;
			
			_type = _xml.@type;
			if (_type == "") _type = "unknownElement";
			
			_cont = new Sprite();
			addChild(_cont);
			
			_box = new Sprite();
			_cont.addChild(_box);
			
			_baseText = _xml.text.toString() //+ (lastElement ? "." : "");
			_tf = new BasicText( { txt:_baseText } );
			_tf.mouseChildren = _tf.mouseEnabled = false;
			_cont.addChild(_tf);
			
			drawBox();
			
			addInteractivity();
			
			unhighlight(0);
			
		}
		
		
		private function drawBox():void {
			_box.graphics.clear();
			_box.graphics.beginFill(0xffffff);
			_box.graphics.drawRoundRect(-PADDING.left, -PADDING.top, _tf.width+PADDING.left+PADDING.right, _tf.height+PADDING.top+PADDING.bottom, 10, 10);
		}
		
		
		public function moveTo(xp:Number, yp:Number):void {
			alpha = 0;
			_targetPos = new Point(xp, yp);
		//	trace("SentenceElemen::moveTo", x+"/"+y+" =>>> "+xp+"/"+yp);
			eaze(this).to(1, { x:xp, y:yp, alpha:1 } ).easing(Elastic.easeOut);
			
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
						trace(Math.abs(tarX - el.x) , Math.abs(leaderEl.y - el.y));
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
			
			eaze(_box).to(.2, { tint:color, alpha:alpha_ } );
			
		}
		
		public function highlight(dur:int = .2):void  {
			eaze(_box).to(.2, { tint:_colorHighlight, alpha:1} );
			//eaze(_box).to(dur, { alphaVisible:1 } );
			
		}
		
		public function unhighlight(dur:int = .2):void  {
			eaze(_box).to(.2, { tint:_colorUnHighlight, alpha:_alphaUnHighlight} );
			//eaze(_box).to(dur, { alphaVisible:0 } );
			
		}
		
		
		
		override public function toString():String {
			
			return "[SentenceElement  id:"+id+"  text:"+text+" ]";
			
		}
		
		
		public function clone():SentenceElement {
			
			var clone:SentenceElement = new SentenceElement(_sentence, id, _xml);
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
			return _tf.height;
		}
		
		public function get text():String {
			return _tf.text;
		}
		
		public function set text(val:String):void {
			_tf.text = val;
			drawBox();
			
		}
		
		/**
		 * x-pos of this element in the sentence
		 */
		public function get sentX():Number 
		{
			//return _sentX;
			var i:int = 0;
			var xp:Number = 0;
			while (i < id) {
				xp += _sentence.elems[i].width + SentenceContainer.ELEMENT_PADDING;
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
		
	}

}