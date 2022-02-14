package modules03.mod0303 
{
	import aze.motion.eaze;
	import base.events.CustomEvent;
	import base.text.BasicText;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import goethe.GoetheColors;
	import lt.uza.utils.Global;
	import utils.StringToObject;
	/**
	 * ...
	 * @author 
	 */
	public class RubberText extends Sprite
	{
		static public const RUBBING_COMPLETE:String = "rubbingComplete";
		private var global:Global = Global.getInstance();
		private var _stage:Stage;
		private var _xml:XML
		private var _box:Sprite;
		private var _elems:Array = [];
		private var _textWidth:Number = 10;
		private var _rubbedPerc:Number = 0; // 0 - 1
	//	private var _rubber:McRubber;
		//private var _mouseDownPoint:Point = new Point();
		private var _showBox:Boolean ;
		private var _showRubberDoubleArrow:Boolean ;
		public var customData:Object = { };
		
		
		
		public function RubberText(xml:XML, showBox:Boolean = false ) 
		{
			_stage = global.stage;
			
			_xml = xml;
			_showBox = showBox;
			
			
			//graphics.beginFill(0xff0000);
			//graphics.drawCircle(0, 0, 100);
			
			//trace("RubberText", xml);
			
			_box = new Sprite();
			addChild(_box);
			
			var xp:Number = 0
			for each(var ex:XML in _xml.elem) {
				trace("RubberText", ex);
				
				var elem:BasicText = new BasicText( { text:ex, fontColor:0xffffff } );
				elem.mouseChildren = elem.mouseEnabled = false;
				elem.customData.rubbable = ex.@rubbable == "true" ? true : false;
				if (ex.@start != undefined) {
					var startObj:Object = StringToObject.parseString(ex.@start)
					eaze(elem).apply(startObj);
					if (startObj.x != undefined) xp = startObj.x;
				}
				elem.x = xp;
				xp += elem.textWidth+10
				addChild(elem);
				_elems.push(elem);
				
				elem.customData.rubbable = ex.@rubbable == "true" ? true : false;
				
				
			}
			
			_showRubberDoubleArrow = _xml.@rubberDoubleArrow == "true" ? true : false;
			
			updateBox();
			
		//	eaze(_rubber).to(.5, { alpha:1 } );
			/*_rubber = new McRubber();
			_rubber.buttonMode = true;
			addChild(_rubber);
			_rubber.addEventListener(MouseEvent.MOUSE_DOWN, onRubberMouseDown);
			*/
			
		}
		
		/*public function onRubberMouseDown(e:MouseEvent=null):void 
		{
			trace("onRubberMouseDown");
			//_mouseDownPoint = new Point(_rubber.mouseX, _rubber.mouseY);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_rubber.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_rubber.startDrag();
		}
		*/
		
		/*private function onMouseDown(e:MouseEvent):void 
		{
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}*/
		
	/*	private function onMouseUp(e:MouseEvent):void 
		{
			trace("onMouseUp");
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_rubber.stopDrag();
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			//trace(hitTestPoint(_rubber.x - this.x, _rubber.y - this.y));
			//trace(_box.hitTestObject(_rubber));
			if (_box.hitTestObject(_rubber)) rub();
			
			//trace(_rubber.x, localToGlobal(new Point(this.x, this.y)).x);
			//_rubber.x = mouseX - _mouseDownPoint.x;
			//_rubber.y = mouseY - _mouseDownPoint.y;
		}
		*/
		
		public function rub(amount:Number = .02):void {
			
			if (_rubbedPerc < 1) {
				_rubbedPerc += amount
				//trace("rub", _rubbedPerc);;
				
				var i:int = 0;
				for each(var ex:XML in _xml.elem) {
					if (ex.@start != undefined && ex.@end != undefined) {
						var startObj:Object = StringToObject.parseString(ex.@start)
						var endObj:Object = StringToObject.parseString(ex.@end)
						var setObj:Object = { };
						for (var prop:String in startObj) {
							///trace("prop", prop);
							if (endObj[prop] != undefined) {
								
								setObj[prop] = Number(startObj[prop]) + (Number(endObj[prop]) - Number(startObj[prop]) ) * _rubbedPerc;
							///	trace(">>>> ", startObj[prop], endObj[prop], setObj[prop]);
							}
						}
						eaze(_elems[i]).apply(setObj);
						//eaze(_elems[i]).to(.1, setObj);
					}
					i++;
				}
				
				updateBox();
				
				if (_rubbedPerc >= 1) {
					rubbingComplete();
				}
			}
		}
		
		private function rubbingComplete():void 
		{
			//addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			//_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			//_rubber.buttonMode = false;
			//_rubber.stopDrag();
			
			var i:int = 0;
			for each(var ex:XML in _xml.elem) {
				if (ex.@complete != undefined) {
					var complObj:Object = StringToObject.parseString(ex.@complete)
					eaze(_elems[i]).to(.5, complObj);
				}
				i++;
			}
			
			eaze(this).to(.5, { } ).onUpdate(updateBox);
			//eaze(_rubber).to (.25, { alpha:0 } );
			
			dispatchEvent(new CustomEvent(RUBBING_COMPLETE, true, false, {xml:_xml, currentTarget:this}));
		}
		
		
		public function updateBox():void {
			
			updateTextWidth();
			_box.graphics.clear();
			if (_showBox) {
				var col:uint = _rubbedPerc < 1 ? GoetheColors.LIGHT_BLUE : GoetheColors.GREEN;
				_box.graphics.beginFill(col, 1)
			} else {
				_box.graphics.beginFill(0xff0000, .0)//GoetheColors.GREEN);
			}
			
			//_box.graphics.drawRect(0,0,
			_box.graphics.drawRoundRect( -10, -7, _textWidth + 25, 46, 20, 20);
			
			
			
		}
		
		
		
		private function updateTextWidth():void 
		{
			_textWidth = 0;
			for each(var elem:BasicText in _elems) {
				if (elem.alpha > 0) 	_textWidth = Math.max(_textWidth, elem.x + elem.textWidth); // nur sichtbare beachten
			}
			
			
		}
		
		
		public function show(dur:Number = .25):void {
			trace("SHOW");
			eaze(this).to(dur, { alpha:1 } );
			//_rubber.x = -60;
		//	_rubber.y = 30;
			//if(_rubbedPerc < 1) eaze(_rubber).to(dur, { alpha:1 } )//.onUpdate(rubberupdate);
			
			//_rubber.alpha = 1;
		}
		
		private function rubberupdate():void 
		{
			//trace("rubberupdate");
		}
		
		public function hide(dur:Number=0):void {
			eaze(this).to(dur, { alpha:0 } );
			//eaze(_rubber).to(dur, { alpha:0 } );
		}
		
		

		/**
		 * checks if the sprite hits an area that is "rubbable"
		 * @param	rubArea
		 * @return hits a area to rub or not
		 */
		public function hits(rubArea:Sprite):Boolean 
		{
			for each(var el:BasicText in _elems) {
				if (el.customData.rubbable  && rubArea.hitTestObject(el)) return true;
			}
			return false;
		}


		

		public function get rubbable():Boolean {
			trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>_rubbedPerc", _rubbedPerc);
			return _rubbedPerc < 1 ? true : false;
		/*	for each(var el:BasicText in _elems) {
				if (el.customData.rubbable ) return true;
			}
			return false;*/
		}
		
		/*public function get rubber():McRubber 
		{
        //return _rubber;
		}
		*/
		
		public function get box():Sprite 
		{
			return _box;
		}
		
		public function get showRubberDoubleArrow():Boolean 
		{
			return _showRubberDoubleArrow;
		}
		
	
		
	}

}