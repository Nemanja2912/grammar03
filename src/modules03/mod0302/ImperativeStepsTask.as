package modules03.mod0302 
{
	import aze.motion.eaze;
	import base.gui.Padding;
	import base.text.BasicText;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import goethe.GoetheColors;
	import gui.buttons.TextButton;
	import gui.input.SpecialInputField;
	import lt.uza.utils.Global;
	/**
	 * ...
	 * @author 
	 */
	public class ImperativeStepsTask extends Sprite
	{
		private var global:Global = Global.getInstance();
		private var _xml:XML
		public var id:int = 0;
		static public const STEPTASK_COMPLETE:String = "steptaskComplete";
		private var _foot1:Sprite = new McFoot();
		
		
		private var _feet4:Sprite = new Sprite();
		private var _step1Btns:Array = [];
		private var _step2Cont:Sprite = new Sprite();
		private var _step2Elems:Array = [];
	//	private var _step2a:Sprite = new Sprite();
	//	private var _step2b:Sprite = new Sprite();
		private var _step3Cont:Sprite = new Sprite();
		private var _step3Elems:Array = [];
		private var _step4Cont:Sprite = new Sprite();
		private var _step4Elems:Array = [];
		private var _step4Tf:BasicText;
		private var _stepDistance:int = 120;
		private var _curVarId:int = -1;
		private var _step2Complete:Array = [false, false];
		private var _imperativesComplete:int = 0;
		private var _done:Boolean = false;
		private var _variantDone:Array = [false, false];
		private var _stepActive:Array = [0, 0];
		
		public function ImperativeStepsTask(xml:XML) 
		{
			_xml = xml;
			
			// 1
			addChild(_foot1);
			eaze(_foot1).to(0, { tint:GoetheColors.GREY } );
			_foot1.scaleX = -1;
			_foot1.y = 20;
			
			var tf:BasicText
			tf = new BasicText( { text:xml.common.step1 } );
			tf.x = 30;
			addChild(tf);
			var xp:int = tf.x + tf.width + 30;
			var i:int = 0;
			for each(var ixml:XML in _xml.step1.infinitive) {
	
				var btn:TextButton = new TextButton( { text:ixml, fontColor:0xffffff, boxColor:GoetheColors.LIGHT_BLUE } );
				btn.id = i;
				btn.addEventListener(MouseEvent.CLICK, onChooseInfinitiveClick);
				btn.x = xp;
				btn.y = -7
				xp += btn.width + 20;
				addChild(btn);
				_step1Btns.push(btn);
				i++;
			}
			
			// 2
			addChild(_step2Cont);
			_step2Cont.y = _stepDistance
			
			
		
			for each(var txml:XML in _xml.step2) {
				//trace("txml", txml)
				var step2Elem:ImperativeStep2Element = new ImperativeStep2Element(txml, xml);
				step2Elem.addEventListener(SpecialInputField.TEXT_COMPLETE, onStep2TextComplete);
				step2Elem.x = 0//tf.x + tf.width + 30;
				_step2Cont.addChild(step2Elem);
				step2Elem.visible  = false;
				_step2Elems.push(step2Elem);
			}
			_step2Elems[0].visible = true;
			
			// 3
			addChild(_step3Cont);
			_step3Cont.y = _stepDistance*2
			
			
			for each( txml in _xml.step3) {
				var step3Elem:ImperativeStep3Element = new ImperativeStep3Element(txml, xml);
				step3Elem.addEventListener(ImperativeStep3Element.RUBBING_COMPLETE, onStep3Complete);
				step3Elem.x = 0//tf.x + tf.width + 30;
				_step3Cont.addChild(step3Elem);
				step3Elem.visible  = false;
				_step3Elems.push(step3Elem);
			}
			_step3Elems[0].visible = true;
			
			// 4
			
			addChild(_step4Cont);
			var foot:Sprite = new McFoot();
			foot.scaleX = -1;
			_feet4.addChild(foot);
			_feet4.x = -10;
			_feet4.y = _foot1.y;
			foot = new McFoot();
			foot.x = 35;
			foot.y = -3
			_feet4.addChild(foot);
			eaze(_feet4).to(0, { tint:GoetheColors.GREY_30 } );
			_step4Cont.addChild(_feet4);
			_step4Cont.y =  _stepDistance*3
			_step4Tf = new BasicText( { text:xml.common.step4, fontColor:GoetheColors.GREY_30 } );
			_step4Tf.x = 70;
			_step4Cont.addChild(_step4Tf);
			
			 xp = _step4Tf.x + _step4Tf.width + 20;
			for each( txml in _xml.step4.imperative) {
				var tbtn:TextButton = new TextButton( { text:txml } );
				tbtn.y = -7;
				tbtn.x = xp;
				tbtn.interactive = false;
				tbtn.removeGlow();
				tbtn.boxColor = GoetheColors.GREEN;
				xp += tbtn.width + 20;
				_step4Cont.addChild(tbtn);
				_step4Elems.push(tbtn);
				tbtn.alpha = 0;
				
			}
			
			
			addChild(_step3Cont); // nach vorne wegen rubber
			
		}
		
		
		
	
	
		
		public function onChooseInfinitiveClick(e:MouseEvent, clickedBtn_:TextButton = null):void 
		{
			var clickedBtn:TextButton = e != null ?  (e.currentTarget as TextButton) : clickedBtn_;
			_curVarId = clickedBtn.id;
			
			var otherId:int = _curVarId == 0 ? 1 : 0;
			for each(var btn:TextButton in _step1Btns) {
				if (btn == clickedBtn) {
					btn.boxColor = GoetheColors.GREEN;
					btn.interactive = false;
					btn.removeEventListener(MouseEvent.CLICK, onChooseInfinitiveClick);
				} else {
					
					btn.boxColor = _variantDone[otherId] ? GoetheColors.GREEN : GoetheColors.LIGHT_BLUE;
					btn.interactive = true;
					btn.addEventListener(MouseEvent.CLICK, onChooseInfinitiveClick);
				}
			}
			// step2
			// 
			var step2:ImperativeStep2Element = (_step2Elems[clickedBtn.id] as ImperativeStep2Element);
			var otherStep2:ImperativeStep2Element = (_step2Elems[otherId] as ImperativeStep2Element);
			otherStep2.visible = false;
			otherStep2.deactivate();
			
			step2.visible = true;
			if (!_step2Complete[_curVarId]) step2.activate();
			
			
			// step3
			//if (_step2Complete[_curVarId]) {
				(_step3Elems[clickedBtn.id] as ImperativeStep3Element).visible = true;//show()// = true;
			//}
			(_step3Elems[otherId] as ImperativeStep3Element).visible = false;
			
			
			eaze(_step4Tf).apply( { tint:_variantDone[_curVarId] ? GoetheColors.BLACK : GoetheColors.GREY_30 } );
			
			
			// foot-colors berichtigen
			eaze(_foot1).to(.5, { tint:GoetheColors.GREEN } );
			
			
			eaze(_feet4).apply( { tint:_variantDone[_curVarId] ? GoetheColors.GREEN : GoetheColors.GREY_30 } );
			
			_stepActive[_curVarId] = Math.max(_stepActive[_curVarId], 1);
		
		}
		
		
		private function onStep2TextComplete(e:Event):void 
		{
			var el:ImperativeStep2Element = e.currentTarget as ImperativeStep2Element
			el.deactivate();
		//	el.alpha = .2;
			_step2Complete[_curVarId] = true;
			startStep3();
			
		}
		
		
		private function startStep3():void 
		{
			trace("startStep3");
			(_step3Elems[_curVarId] as ImperativeStep3Element).visible = true;
			(_step3Elems[_curVarId] as ImperativeStep3Element).activate();
			var tmp:ImperativeStep3Element = (_step3Elems[(_curVarId == 0) ? 1 : 0] as ImperativeStep3Element);
			tmp.visible = false;
			tmp.deactivate();
			
			
		}
		
		private function onStep3Complete(e:Event):void 
		{
			eaze((_step4Elems[_curVarId] as TextButton)).delay(2).to (.25, {alpha:1})//.visible = true //.boxColor = GoetheColors.GREEN;
			//eaze(global.rubber).to (.25, { alpha:0 } );;
			_variantDone[_curVarId] = true;
			
			_imperativesComplete ++;
			if (_imperativesComplete >= 2) {
				dispatchEvent(new Event(STEPTASK_COMPLETE));
				_done = true;
			}
			
			eaze(_feet4).delay(1).to( .5, { tint:GoetheColors.GREEN } );
			eaze(_step4Tf).delay(1).to( .5, { tint:GoetheColors.BLACK } );
			
		}
		
		
		public function deactivate():void {
			
			for each(var el:ImperativeStep2Element in _step2Elems) {
				el.deactivate();
				
			}
			
		}
		
		public function activate():void {
			if (_curVarId != -1) {
				if (!_step2Complete[_curVarId]) (_step2Elems[_curVarId] as ImperativeStep2Element).activate();
			}
			
		}
		
		
		/**
		 * ist der ausgewählte imperativ schon durchgearbeitet?
		 */
		public function currentVarIsDone():Boolean 
		{
			return _variantDone[_curVarId];
		}
		
		public function getStep1OtherImperativeButton():TextButton {
			
			return _step1Btns[(_curVarId == 0) ? 1 : 0]; 
			
		}
		
		public function getStep1FirstImperativeButton():TextButton {
			
			return _step1Btns[0]; 
			
		}
		
		
		public function getCurrentStep():int {
			
			if (_curVarId == -1) {
				return 1;
			} else if (!_step2Complete[_curVarId]) {
				return 2;
			} else {
				return 3;
			}
			
		}
		
		public function get done():Boolean 
		{
			return _done;
		}
		
		public function get currentStep2Elem():ImperativeStep2Element {
			
			return _step2Elems[_curVarId];
		}
		
		public function get currentStep3Elem():ImperativeStep3Element {
			
			return _step3Elems[_curVarId];
		}
	}

}