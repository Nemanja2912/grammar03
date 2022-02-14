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
	import modules.Module;
	/**
	 * ...
	 * @author 
	 */
	public class ImperativeTableRow extends Sprite
	{
		static public const ALL_RUBBING_COMPLETE:String = "allRubbingComplete";
		
		private var global:Global = Global.getInstance();
		private var _stage:Stage;
		private var _rubTexts:Array = [];
		private var _presentRow:ImperativeTableRowPresent;
		private var _rubbingsComplete:int = 0;
		private var _lastRubPoint:Point;
		
		private var _rubber:Rubber;
		private var _helpMode:Boolean = false;
		private var _mod:Module;
		//private var _mouseDownPoint:Point = new Point();
		public function ImperativeTableRow(xml:XML, mod:Module) 
		{
			
			_mod = mod;
			_stage = global.stage;
			
			var w:int = Mod03Table.COL_WIDTH
			var h:int = Mod03Table.ROW_HEIGHT
			
			graphics.beginFill(GoetheColors.LIGHT_BLUE);
			graphics.drawRect(-w-1, 0, w , h);
			graphics.drawRect(0, 0, w , h);
			graphics.drawRect(w+1, 0, w, h);
			graphics.drawRect(w * 2 + 2, 0, w, h);
			
			var tf:BasicText = new BasicText( { text:"IMPERATIV" } );
			tf.x = -tf.textWidth - (w - tf.textWidth) / 2;
			tf.y = 10;
			addChild(tf)
		
			
			
			var i:int = 0;
			for each(var cx:XML in xml.col) {
				var rt:RubberText = new RubberText(cx);
				rt.customData.id = i;
				rt.addEventListener(RubberText.RUBBING_COMPLETE, onRubbingComplete);
				rt.x = i *  Mod03Table.COL_WIDTH + 10 + i;
				rt.y = 10;
				addChild(rt);
				_rubTexts.push(rt);
				i++;
			}
			
			_rubber = new Rubber();
			_rubber.doubleArrow.visible  = false;
			_rubber.buttonMode = true;
			_rubber.y = 50;
			addChild(_rubber);
			_rubber.addEventListener(MouseEvent.MOUSE_DOWN, onRubberMouseDown);
			
			_presentRow = new ImperativeTableRowPresent(xml);
			_presentRow.y = h + 1;
			addChildAt(_presentRow,0)
			
			
		}
		
		private function onRubbingComplete(e:CustomEvent):void 
		{
			(e.param.currentTarget as RubberText).removeEventListener(RubberText.RUBBING_COMPLETE, onRubbingComplete);
			_rubbingsComplete ++;
			if (_rubbingsComplete >= 3) {
				_rubber.removeEventListener(MouseEvent.MOUSE_DOWN, onRubberMouseDown);
				eaze(_rubber).to(.25, { alpha:0 } );
				dispatchEvent(new Event(ALL_RUBBING_COMPLETE));
			}
		}
		
		
		public function onRubberMouseDown(e:MouseEvent=null):void 
		{
			if (e != null) {
				_lastRubPoint =  new Point(mouseX, mouseY)
			} else {
				_lastRubPoint =  new Point(_mod.handCursor.x, _mod.handCursor.y);
				_helpMode = true;
			}
			
			
			trace("onRubberMouseDown");
			//_mouseDownPoint = new Point(_rubber.mouseX, _rubber.mouseY);
			_stage.addEventListener(Event.ENTER_FRAME, onEFMove);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_rubber.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			//_rubber.startDrag();
		}
		
		public function onMouseUp(e:MouseEvent):void 
		{
			trace("onMouseUp");
			_stage.removeEventListener(Event.ENTER_FRAME, onEFMove);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_rubber.stopDrag();
			_helpMode = false;
		}
		
		
		private function onEFMove(e:Event=null):void //, pos:Point = null):void 
		{
			
			//if (pos == null) pos = new Point(mouseX, mouseY)
			var pos:Point;
			if (_helpMode) {
				pos =  new Point(_mod.handCursor.x, _mod.handCursor.y);
			} else {
				pos = new Point(mouseX, mouseY)
			}
			
			_rubber.x +=  pos.x - _lastRubPoint.x ;
			_rubber.y += pos.y -_lastRubPoint.y ;
			
			var rubAmnt:Number = Math.min(.25, Point.distance(_lastRubPoint, pos) / 200);
			_lastRubPoint =  pos//new Point(mouseX, mouseY)
			
			if (_helpMode) rubAmnt *= 1.7;
			
			trace("onEFMove rubAmnt",rubAmnt);
			
			for each(var rt:RubberText in _rubTexts) {
				
				if (rt.hits(_rubber.rubArea) ) {
					//trace("rt.hits");
					rt.rub(rubAmnt);
					_rubber.doubleArrow.visible = (rt.showRubberDoubleArrow);
				}
			}
			
		//	if (_rubberText.box.hitTestObject(_rubber)) _rubberText.rub(rubAmnt);
		

		}
		
		public function get rubber():Rubber 
		{
			return _rubber;
		}
		

		public function getUnsolvedRubbertext():RubberText {
			
			for each(var rt:RubberText in _rubTexts) {
				trace(">>>>>>>>", rt.rubbable);
				if (rt.rubbable) return rt;
			}
			return null;
			
		}
		
		/*
		private function onMouseMove(e:MouseEvent):void 
		{
			//trace(hitTestPoint(_rubber.x - this.x, _rubber.y - this.y));
			//trace(_box.hitTestObject(_rubber));
			for each(var rt:RubberText in _rubTexts) {
				if (rt.box.hitTestObject(_rubber)) rt.rub();
			}
			
			
			//trace(_rubber.x, localToGlobal(new Point(this.x, this.y)).x);
			//_rubber.x = mouseX - _mouseDownPoint.x;
			//_rubber.y = mouseY - _mouseDownPoint.y;
		}
		*/
	}

}