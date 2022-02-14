package modules03.mod0302 
{
	import aze.motion.eaze;
	import base.events.CustomEvent;
	import base.text.BasicText;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import goethe.GoetheColors;
	import gui.handCursor.HandCursor;
	import lt.uza.utils.Global;

	import modules03.mod0303.Rubber;
	import modules03.mod0303.RubberText;
	import utils.StringToObject;
	/**
	 * ...
	 * @author 
	 */
	public class ImperativeStep3Element extends Sprite
	{
		static public const RUBBING_COMPLETE:String = "rubbingComplete";

		private var global:Global = Global.getInstance();
		private var _stage:Stage;
		private var _xml:XML
		private var _box:Sprite;
		private var _elems:Array = [];
		private var _textWidth:Number = 10;
		private var _rubbedPerc:Number = 0; // 0 - 1
		private var _rubber:Rubber;
		private var _mouseDownPoint:Point = new Point();
		private var _rubberText:RubberText;
		private var _lastRubPoint:Point  
		private var _foot3:Sprite = new McFoot();
		private var _tf:BasicText;
		private var _firstActivation:Boolean = true;
		private var _rubberTouched:Boolean = false;
		protected var _handCursor:HandCursor 
		private var _tutorialAnimRunning:Boolean = false;
		
		
		public function ImperativeStep3Element(xml:XML, parentXml:XML) 
		{
			_stage = global.stage;
			
			_xml = xml;
			
			
			addChild(_foot3);
			eaze(_foot3).to(0, { tint:GoetheColors.GREY_30 } );
			_foot3.scaleX = -1;
			_foot3.y = 20;
			_tf = new BasicText( { text:parentXml.common.step3, fontColor:GoetheColors.GREY_30  } );
			_tf.x = 30
			addChild(_tf);
			
			_box = new Sprite();
			addChild(_box);
			
			_rubberText = new RubberText(xml, true);
			_rubberText.x = _tf.x + _tf.width + 30;
			_rubberText.addEventListener(RubberText.RUBBING_COMPLETE, onRubbingComplete);
			addChild(_rubberText);
			_rubberText.alpha = 0;
			
		
		
			_rubber = new Rubber();
			//_rubber.x = _rubberText.x;
			_rubber.alpha = 0;
			_rubber.doubleArrow.visible = xml.@rubberDoubleArrow == "true" ? true : false;
			addChild(_rubber);
			
		
			
			
		}
		
		
		
		private function onRubbingComplete(e:Event):void 
		{
			_stage.addEventListener(Event.ENTER_FRAME, onEFMove);
			eaze(_rubber).to (.2, { alpha:0 } );
			
			eaze(_foot3).to( .5, { tint:GoetheColors.GREEN } );
			//eaze(_box).to( .5, { tint:0xff0000} );
	
		}
		
		public function onRubberMouseDown(e:MouseEvent=null):void 
		{
			if (_tutorialAnimRunning) {
				stopTutorialAnim();
			}
			_rubberTouched = true;
			trace("onRubberMouseDown");
			//_mouseDownPoint = new Point(_rubber.mouseX, _rubber.mouseY);
			_lastRubPoint = new Point(mouseX, mouseY);
			_stage.addEventListener(Event.ENTER_FRAME, onEFMove);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_rubber.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_rubber.startDrag();
			
		}
		
		
		/*private function onMouseDown(e:MouseEvent):void 
		{
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}*/
		
		private function onMouseUp(e:MouseEvent):void 
		{
			trace("onMouseUp");
			_stage.removeEventListener(Event.ENTER_FRAME, onEFMove);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_rubber.stopDrag();
		}
		
		private function onEFMove(e:Event):void 
		{

			if (_lastRubPoint != null) var rubAmnt:Number = Math.min(.25, Point.distance(_lastRubPoint, new Point(mouseX, mouseY)) / 200);
			_lastRubPoint =  new Point(mouseX, mouseY)
			
		//	trace("rubAmnt", rubAmnt);
			
		//	if (_rubberText.box.hitTestObject(_rubber)) _rubberText.rub(rubAmnt);
			if (_rubberText.hits(_rubber.rubArea) ) {
				_rubberText.rub(rubAmnt);
				trace("HIT!");
			}

		}
		

		
		public function activate():void {
			trace("ImperativeStep3Element::activate");
			_rubber.x = _rubberText.x;
			_rubber.y = 30;
			
			
			
			if (_firstActivation) {
				eaze(_foot3).delay(0).to(.5, { tint:GoetheColors.GREY } )
				eaze(_tf).delay(0).to(.5, { tint:GoetheColors.BLACK } )
				_firstActivation = false;
			}
			
			eaze(_rubberText).delay(1).to(.5, { alpha:1 } )
			eaze(_box).delay(1).to(.5, { alpha:1 } )
			trace("_rubbedPerc", _rubbedPerc);
			if (_rubbedPerc < 1) eaze(_rubber).delay(1.5).to(.5, { alpha:1 } )//.onUpdate(rubberupdate);
			
			_rubber.addEventListener(MouseEvent.MOUSE_DOWN, onRubberMouseDown);
			//_rubber.alpha = 1;
			
				trace(">>>>>>>>>>>><eaze(this).delay(2).onComplete(rubberTutorialAnimation);");
			eaze(this).delay(4).onComplete(rubberTutorialAnimation);
			
		}
		
		private function rubberTutorialAnimation():void 
		{
			trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><rubberTutorialAnimation");
			if (!_rubberTouched) {
				_tutorialAnimRunning = true;
				if (!_handCursor) _handCursor = new HandCursor();
				_handCursor.x = _rubber.x+50;
				_handCursor.y = _rubber.y;
				addChild(_handCursor);
				_handCursor.show();
				var pos1:Point = new Point(_rubber.x, _rubber.y);
				var pos2:Point = new Point(_rubber.x+50, _rubber.y);
				eaze(_handCursor).to(.5, {  x:pos1.x } ).onComplete(function():void {
				eaze(_rubber).to(.3, { x:pos2.x, y:pos2.y } ).to(.3, { x:pos1.x, y:pos1.y } ).to(.3, { x:pos2.x, y:pos2.y } ).to(.3, { x:pos1.x, y:pos1.y } ).to(.3, { x:pos2.x, y:pos2.y } ).to(.3, { x:pos1.x, y:pos1.y } )  } )
				.to(.3, { x:pos2.x, y:pos2.y } ).to(.3, { x:pos1.x, y:pos1.y } ).to(.3, { x:pos2.x, y:pos2.y } ).to(.3, { x:pos1.x, y:pos1.y } ).to(.3, { x:pos2.x, y:pos2.y } ).to(.3, { x:pos1.x, y:pos1.y } )
				.onComplete(function():void { _handCursor.hide(.3); _tutorialAnimRunning=false } ).delay(5).onComplete(rubberTutorialAnimation);
			}
		}
		
		private function stopTutorialAnim():void 
		{
			_tutorialAnimRunning = false;
			eaze(_handCursor).killTweens();
			eaze(_rubber).killTweens();
			_handCursor.hide(.3);
		}
		
		

		
		public function deactivate():void {
			//eaze(this).to(dur, { alpha:0 } );
			//eaze(_rubber).to(.5, { alpha:0 } );
			//_rubber.removeEventListener(MouseEvent.MOUSE_DOWN, onRubberMouseDown);
		}
		
		public function rub():void 
		{
			_rubberText.rub();
		}
		
		public function get rubber():Rubber 
		{
			return _rubber;
		}
		
		public function get box():Sprite 
		{
			return _rubberText.box;
		}
		
	}

}