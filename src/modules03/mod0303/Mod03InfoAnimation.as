package modules03.mod0303 
{
	import aze.motion.easing.Elastic;
	import aze.motion.eaze;
	import base.config.TextConfig;
	import base.gui.Padding;
	import base.text.BasicText;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import goethe.GoetheColors;
	import gui.buttons.TextButton;
	import gui.popIcon.PopIcon;
	import lt.uza.utils.Global;
	import rule.GenericRule;
	/**
	 * ...
	 * @author 
	 */
	public class Mod03InfoAnimation extends Sprite
	{
		
		private var global:Global = Global.getInstance();
		private var _stage:Stage;
		private var _xml:XML;
		private var _onComplete:Function;
		private var _txtCont:Sprite = new Sprite();
		private var _btn1:TextButton ;
		private var _btn2:TextButton;
		private var _curBtn:TextButton;
		private var _gap:Sprite = new Sprite();
		private var _txts:Array = [];
		private var _solved:Boolean = false;
		

		
		
		private static const X1:int =400;
		private static const Y1:int = 320;
		
		public function Mod03InfoAnimation(xml:XML, onComplete:Function=null) 
		{
			_xml = xml;
			_onComplete = onComplete;
			
			_stage = global.stage;
			
			trace("XML", xml);
			
		
			var txt:BasicText;
			var txt2:BasicText;
			
			var yp:Number = 100;
			for each( var sx:XML in xml.sent) {
				var arrTxt:Array = sx.toString().split("|");
				
				txt = new BasicText( { text:arrTxt[0] } );
				txt.x = X1;
				txt.y = yp;
				_txtCont.addChild(txt);
				
				txt2 = new BasicText( { text:arrTxt[1] } );
				txt2.x = txt.x + txt.textWidth + 6;
				txt2.y = yp;
				_txtCont.addChild(txt2);
				_txts.push(txt2);
				yp += 50;
				
			}
			addChild(_txtCont);
			_txtCont.alpha = 0;
			eaze(_txtCont).delay(0).to(.5, { alpha:1 } );
			

			
		
			 
			 

		}
		
		/*
		public function onBtnMD(e:MouseEvent=null, btn:TextButton=null ):void 
		{
			if (e != null) {
				_curBtn = e.currentTarget as TextButton;
				_curBtn.startDrag();
			} else {
				_curBtn = btn;
			}
			
			_stage.addEventListener(MouseEvent.MOUSE_UP, onBtnMU);
			
		}
		
		public function onBtnMU(e:MouseEvent):void 
		{
			_curBtn.stopDrag();
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onBtnMU);
			if (_curBtn.hitTestObject(_gap)) {
				
				if (_curBtn == _btn1) {
					eaze(_curBtn).to(.5, { x:_gap.x + _gap.parent.x, y:_gap.y + _gap.parent.y } ).easing(Elastic.easeOut).onComplete(splitTexts);
					_btn1.removeEventListener(MouseEvent.MOUSE_DOWN, onBtnMD);
					_btn2.removeEventListener(MouseEvent.MOUSE_DOWN, onBtnMD);
					_btn1.removeGlow();
					_btn1.interactive = false;
					eaze(_btn2).to(.25, { alpha:0 } );
					dispatchEvent(new Event(PopIcon.EVENT_RIGHT, true));
					_solved = true;
					
				} else {
					moveBtnBack(_curBtn);
					dispatchEvent(new Event(PopIcon.EVENT_WRONG, true));
				}
				
			} else {
				
				moveBtnBack(_curBtn);
					
			}
			
			
		}
		
		private function moveBtnBack(btn:TextButton):void {
			eaze(btn).to(.5, { x:btn.basePos.x, y:btn.basePos.y } ).easing(Elastic.easeOut);
		}
		
		
		private function splitTexts():void {
			
			
			
			var i:int = 0;
			for each(var tx:BasicText in _txts) {
				eaze(tx).delay(0).to(.5, { x: X1 + 150 } );
				i++;
			}
			
			var box:Sprite = new Sprite();
			box.graphics.beginFill(GoetheColors.GREEN);
			box.graphics.drawRoundRect(X1 - 20, 20, 140, 240, 20);
			addChildAt(box, 0);
			box.alpha = 0;
			eaze(box).delay(1).to(.5, { alpha:1 } );
			
			var txt:BasicText = new BasicText( { text:_xml.pos1, fontColor:0xffffff } );
			txt.x = X1;
			txt.y = 40;
			addChild(txt);
			txt.alpha = 0;
			eaze(txt).delay(2).to(.5, { alpha:1 } ).delay(2).onComplete(_onComplete);
			
		}
		
		public function get btn1():TextButton 
		{
			return _btn1;
		}
		
		public function get gap():Sprite 
		{
			return _gap;
		}
		
		public function get solved():Boolean 
		{
			return _solved;
		}
		*/
		
	}

}