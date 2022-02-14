package modules03.mod0304 
{
	import aze.motion.eaze;
	import base.events.CustomEvent;
	import base.gui.Dim;
	import base.images.SimpleImage;
	import base.text.BasicText;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import goethe.GoetheColors;
	import gui.buttons.TextButton;
	import gui.frame.Frame;
	import gui.iconButtons.IconBtnClose;
	import gui.iconButtons.IconBtnNext;
	import gui.input.SpecialInputField;
	import gui.input.specialKeyboard.MobileKeyboard;
	import gui.popIcon.PopIcon;
	import lt.uza.utils.Global;
	import text2speech.TextToSpeech;
	import utils.CollisionUtils;
	import utils.GoetheUtils;
	/**
	 * ...
	 * @author 
	 */
	public class Mod04TableRowImperative extends Sprite
	{
		
		private var global:Global = Global.getInstance();
		private var _stage:Stage;
		private var _xml:XML;
		private var _elems:Vector.<TextButton> = new Vector.<TextButton>();
		private var _inputs:Vector.<SpecialInputField> = new Vector.<SpecialInputField>();
		private var _imgCont:Sprite ;
		private var _img:SimpleImage;
		protected var _textsComplete:Array = [];
		
		private var _gapTextCont:Sprite;
		private var _gapTextContWidth:Number;
		private var  _gapTf:BasicText
		private var _boxToDragOn:Sprite;
		private var _dragBtn:TextButton;
		private var _dim:Dim = new Dim();
		private var _btnClose:IconBtnNext = new IconBtnNext(40);
		private var _bg:Sprite = new Sprite();
		private var _bgs:Array = [];
		private var _id:int ;
		
		public static const HEIGHT:int = 60;
		static public const IMPERATIVE_ROW_COMPLETE:String = "imperativeRowComplete";
		static public const IMPERATIVE_DONE:String = "imperativeDone";
		
		public function Mod04TableRowImperative(xml:XML, id:int) 
		{
			
			_stage = global.stage;
			_xml = xml;
			_id = id;
			
			addChild(_bg);
			_bg.graphics.beginFill(GoetheColors.LIGHT_BLUE);
			_bg.graphics.drawRect(0, 0, 159, HEIGHT-1);
			
			var tf:BasicText = new BasicText( { text: "Imperativ-Formen bilden", multiline:true, width:130,  fontSize:16,  textAlign:"center" , fontColor:0xffffff } );
			tf.x = 10;
			tf.y = 7;
			addChild(tf);
			
			var i:int = 0;
			var txt:String;
			var txt2:String;
			for each(var ex:XML in xml.elem) {
				if (ex.toString().indexOf(" ") != -1) {
					var tmpTxts:Array = ex.toString().split(" ");
					txt = tmpTxts[0];
					txt2 = tmpTxts[1];
				} else {
					txt = ex;
					txt2 = null;
				}
				
				var bg:Sprite = new Sprite();
				bg.graphics.beginFill(GoetheColors.GREY_30);
				bg.graphics.drawRect(160 +  (i * Mod04TableRowPresentElement.WIDTH), 0, Mod04TableRowPresentElement.WIDTH - 1, HEIGHT - 1);
				_bgs.push(bg);
				addChild(bg);
				
				var inp:SpecialInputField = new SpecialInputField( { targetText:txt } )//xml.elem.(@pp == pp)[0] } );
				inp.id = i;
				inp.addEventListener(SpecialInputField.TEXT_COMPLETE, onTextComplete);
				inp.addEventListener(SpecialInputField.ALL_FILLED_OUT_WRONG, onTextFilledWrong);
				inp.addEventListener(SpecialInputField.ELEMENT_ACTIVATED, onInputElementActivated);
				inp.y = 13;
				inp.x = 160 +  i * Mod04TableRowPresentElement.WIDTH + (Mod04TableRowPresentElement.WIDTH - inp.width) / 2;
				addChild(inp);
				_inputs.push(inp);
				_textsComplete.push(0);
				i++;
				if (txt2 != null) {
					var inp2:SpecialInputField = new SpecialInputField( { targetText:txt2 } )
					inp2.addEventListener(SpecialInputField.TEXT_COMPLETE, onTextComplete);
					inp2.addEventListener(SpecialInputField.ALL_FILLED_OUT_WRONG, onTextFilledWrong);
					inp2.addEventListener(SpecialInputField.ELEMENT_ACTIVATED, onInputElementActivated);
					inp2.id = i;
					inp2.y = inp.y
					inp.x = 160 +  ((i-1) * Mod04TableRowPresentElement.WIDTH) + (Mod04TableRowPresentElement.WIDTH - (inp.width + 10 + inp2.width) )/ 2;
					inp2.x = inp.x + inp.width + 10;
					addChild(inp2);
					_inputs.push(inp2);
					_textsComplete.push(0)
				}
				
			}
			
			// img schonmal laden
			_imgCont = new Sprite();
			_imgCont.addChild(_dim);
			
			if (global.isMobile) {
				_img = new SimpleImage( { bitmap:new global.assets03.imageClasses04[_id](), smoothing:true }, true);
			} else {
				_img = new SimpleImage( { url:_xml.img[0], smoothing:true }, true); 
			}
			
			_imgCont.addChild(_img);
		//	startStep2();
		}
		
	
		
		private function onInputElementActivated(e:CustomEvent):void 
		{
			var input:SpecialInputField = e.param.specialInputField as SpecialInputField;
			for each(var inp:SpecialInputField in _inputs) {
				if (inp != input) inp.unsetFocus();
				
			}
			
			
		}
		
		
		private function onTextFilledWrong(e:CustomEvent):void 
		{
			
			trace("onTextFilledWrong");
			var inp:SpecialInputField = e.param.specialInputField;
			
			// feld rot machen
			var bg:Sprite = _bgs[Math.min(inp.id,2)] as Sprite;
			bg.graphics.clear();
			bg.graphics.beginFill(GoetheColors.ORANGE);
			bg.graphics.drawRect(160 +  (Math.min(inp.id, 2) * Mod04TableRowPresentElement.WIDTH), 0, Mod04TableRowPresentElement.WIDTH - 1, HEIGHT - 1);
			
			dispatchEvent(new Event(PopIcon.EVENT_WRONG, true));
			
		}
		
		private function onTextComplete(e:CustomEvent):void 
		{
			dispatchEvent(new CustomEvent(MobileKeyboard.HIDE_KEYS, true));
			trace("onTextComplete");
			var inp:SpecialInputField = e.param.specialInputField;
			inp.deactivate();
			
			var doGreen:Boolean = false;
			if (inp.id < 2) doGreen = true;
			if (inp.id == 2 && _textsComplete[3] == 1) doGreen = true;
			if (inp.id == 3 && _textsComplete[2] == 1) doGreen = true;
			
			var bg:Sprite = _bgs[Math.min(inp.id,2)] as Sprite;

			bg.graphics.clear();
			bg.graphics.beginFill(doGreen ? GoetheColors.GREEN : GoetheColors.GREY_30);
			bg.graphics.drawRect(160 +  (Math.min(inp.id, 2) * Mod04TableRowPresentElement.WIDTH), 0, Mod04TableRowPresentElement.WIDTH - 1, HEIGHT - 1);
			

			_textsComplete[inp.id] = 1;
			if (_textsComplete.indexOf(0) == -1) {
				
				startStep2();
				dispatchEvent(new CustomEvent(IMPERATIVE_DONE, true));
			} else {
				if (inp.id < _inputs.length-1) { // nächstes input aktivieren
					for (var i:int = inp.id + 1; i < _inputs.length ; i++) {
						if (_textsComplete[i] == 0) {
							_inputs[i].activateElem(0);
							break;
						}
						
					}
					
					
				}
			
			}
			
			
			
		}
		
		
		private function startStep2():void {
			_bg.graphics.clear();
			_bg.graphics.beginFill(GoetheColors.GREY_75);
			_bg.graphics.drawRect(0, 0, 159, HEIGHT-1);
			
			
			for each(var inp:SpecialInputField in _inputs) {
				//inp.visible = false;
				removeChild(inp);
			}
			
			var i:int = 0;
			for each(var ex:XML in _xml.elem) {
				
				var el:TextButton = new TextButton( { text:ex, boxColor:GoetheColors.LIGHT_BLUE } );
				el.id = i;
				el.customData.pp = ex.@pp;
				el.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMD);
				el.x = Mod04Table.FIRST_COL_WIDTH + i * 216 + (216-el.width)/2;
				el.y = 6;
				addChild(el);
				_elems.push(el);
				el.setBasePos();
				i++;
			}
			
			
			
			_imgCont.x = 0//190
			_img.scaleX = _img.scaleY = .6;
			_img.x = (MainBase.STAGE_WIDTH - _img.width) / 2;
			_img.y = 280//(MainBase.STAGE_HEIGHT - Frame.MINI_HEIGHT - _img.height) / 2;
			//addChild(_imgCont);
			parent.parent.parent.parent.addChild(_imgCont);
			
			//_imgCont.mouseChildren = _imgCont.mouseEnabled = false;
			
		//	_dim.show();
			
			
			_imgCont.y = 0//80;
			
			_gapTextCont = new Sprite();
			_gapTextCont.y = _img.y + 480 * _img.scaleY + 10
			
			_boxToDragOn = new Sprite();
			_boxToDragOn.name = _xml.gapText[0].@pp;
			_boxToDragOn.graphics.beginFill(GoetheColors.GREY_30);
			_boxToDragOn.graphics.drawRoundRect(0, 0, 140, 48, 20, 20);
			_gapTextCont.addChild(_boxToDragOn);
			
			 _gapTf = new BasicText( { text: _xml.gapText[0] } );
			
			_gapTf.y= 9;
			_gapTextCont.addChild(_gapTf);
			
			_gapTextCont.x = _img.x + (640*_img.scaleX - _boxToDragOn.width - 16 - _gapTf.width) / 2;
			_gapTf.x = _boxToDragOn.width + 16;
			
			_gapTextCont.graphics.beginFill(GoetheColors.LIGHT_BLUE);
			_gapTextCont.graphics.drawRoundRect(-10, 0, _gapTextCont.width+20, 48,20,20);
			
			_imgCont.addChild(_gapTextCont);
				
		}
		
		private function onButtonMD(e:MouseEvent):void 
		{
			
			
			_dragBtn = e.currentTarget as TextButton;
			//_dragBtn.parent.addChild(_dragBtn);
			var pos:Point = GoetheUtils.getGlobalPos(_dragBtn)
			_dragBtn.parent.removeChild(_dragBtn);
			_dragBtn.x = _dragBtn.basePos.x = pos.x;
			_dragBtn.y = _dragBtn.basePos.y = pos.y;
			parent.parent.parent.parent.addChild(_dragBtn);
			_dragBtn.startDrag();
			_stage.addEventListener(MouseEvent.MOUSE_UP, onStageMU);
		
		}
		
		public function onStageMU(e:MouseEvent, dragBtn:TextButton=null):void 
		{
			if (dragBtn != null) _dragBtn = dragBtn;
			
			//trace("onStageMU");
			_dragBtn.stopDrag();
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMU);
			var hit:Boolean = CollisionUtils.hittestBoxBox(_dragBtn, _boxToDragOn)
			if (hit) {
				if (_dragBtn.customData.pp == _boxToDragOn.name) {
					
					dispatchEvent(new Event(PopIcon.EVENT_RIGHT, true));
					eaze(_dragBtn).to(.25, { x:_imgCont.x+_gapTextCont.x+_boxToDragOn.x + _boxToDragOn.width - _dragBtn.width, y:_imgCont.y+_gapTextCont.y+_boxToDragOn.y } );
					eaze(_boxToDragOn).to(.25, { alpha:0 } );
					var i:int = 0;
					for each (var tb:TextButton in _elems) {
						tb.interactive = false;
						tb.removeGlow();
						tb.removeEventListener(MouseEvent.MOUSE_DOWN, onButtonMD);
						eaze(tb).to(.25, { alpha:0 } ).onComplete(tb.parent.removeChild,tb);
						var tf:BasicText = new BasicText( { text:tb.text } );
						tf.x = 160 + 216 * i + (216 - tf.width) / 2;
						tf.y = 13;
						addChild(tf);
						i++
					}
					//_dim.x = -_dim.parent.x-_dim.parent.parent.x - 108;
					//_dim.y = -_dim.parent.y-_dim.parent.parent.y-_dim.parent.parent.parent.y -40;
					_dim.show();
					_dim.addEventListener(MouseEvent.CLICK, onClickClose);
					_imgCont.parent.addChild(_imgCont);
					_gapTextCont.parent.addChild(_gapTextCont);
					_dragBtn.parent.addChild(_dragBtn);
					eaze(_img).to(.5, { scaleX:1, scaleY:1, y: 90, x:(MainBase.STAGE_WIDTH - 640) / 2  } );
					_img.addChild(_btnClose);
					_btnClose.x = 640;
					_btnClose.show();
					_btnClose.addEventListener(MouseEvent.CLICK, onClickClose);
					
					fixImgText();
					
					_gapTextCont.graphics.clear();
					_gapTextCont.graphics.beginFill(GoetheColors.GREEN);
					_gapTextCont.graphics.drawRoundRect(0, 0, _gapTextCont.width + 20, 48, 20, 20);
					
					dispatchEvent(new CustomEvent(IMPERATIVE_ROW_COMPLETE, true, false, {id:_id}));
					
				} else {
					dispatchEvent(new Event(PopIcon.EVENT_WRONG, true));
					eaze(_dragBtn).to(.5, { x:_dragBtn.basePos.x, y:_dragBtn.basePos.y } );
				
				}
			} else {
				eaze(_dragBtn).to(.5, { x:_dragBtn.basePos.x, y:_dragBtn.basePos.y } );
			}
			_dragBtn = null;
		}
		
		private function fixImgText():void 
		{
			var tf:BasicText = new BasicText( { text:_dragBtn.text } );
			_gapTextCont.addChild(tf);
			tf.alpha = 0;
			tf.y = _gapTf.y;
			tf.x = _gapTf.x - tf.width - 6;
			eaze(tf).to(.5, { x:0 , alpha:1} );
			eaze(_gapTf).to(.5, { x:0 + tf.width + 6 } )
			eaze(_gapTextCont).to(.5, {x: _img.x + (640*_img.scaleX - tf.width - 6 - _gapTf.width) / 2});
			_gapTextContWidth = _gapTextCont.width;
			eaze(this).to(.5, { gapTextContWidth: 20 + tf.width + 6 + _gapTf.width } ).onUpdate(drawGaptextBox);
		}
		
		private function drawGaptextBox():void 
		{
			_gapTextCont.graphics.clear();
			_gapTextCont.graphics.beginFill(GoetheColors.GREEN);
			_gapTextCont.graphics.drawRoundRect(-10, 0, _gapTextContWidth, 48,20,20);
		}
		
		private function onClickClose(e:MouseEvent):void 
		{
		//	dispatchEvent(new CustomEvent(IMPERATIVE_ROW_COMPLETE, true, false, {id:_id}));
			_btnClose.hide();
			_dim.hide();
			eaze(_img).to(.5, { scaleX:.6, scaleY:.6, y:280, x:(MainBase.STAGE_WIDTH - _img.width*.6) / 2  } );
			
		}
		
		
		public function activateFocus():void {
			var i:int = 0;
			for each(var inp:SpecialInputField in _inputs) {
				trace("activateFocus", i, _textsComplete[i]);
				if (_textsComplete[i] == 0) {
				//	eaze(this).delay(0).onComplete(inp.activateElem,0);
					inp.activateElem(0)
					break;
				}
				i++
			}
			
		}
		
		public function deactivateFocus():void 
		{
			for each(var inp:SpecialInputField in _inputs) {
			
					inp.unsetFocus();
					
				
			}
		}
		
		
		public function help():void {
			var curInp:SpecialInputField;
			if (_textsComplete[0] == 0) curInp = _inputs[0];
			else if (_textsComplete[1] == 0) curInp = _inputs[1];
			else if (_textsComplete[2] == 0) curInp = _inputs[2];
			else  curInp = _inputs[3]; // helfen SIE
			
			curInp.help();
			
		}
		
		
		public function getBtnToDrag():TextButton {
			for each(var btn:TextButton in _elems) {
				if (btn.customData.pp == _boxToDragOn.name) return btn;
			}
			return null
		}
		
		public function setImgContVisible(boolean:Boolean):void 
		{
			if (_imgCont) _imgCont.visible = boolean;
		}
		
	
		
		public function get gapTextContWidth():Number 
		{
			return _gapTextContWidth;
		}
		
		public function set gapTextContWidth(value:Number):void 
		{
			_gapTextContWidth = value;
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function set id(value:int):void 
		{
			_id = value;
		}
		
		public function get boxToDragOn():Sprite 
		{
			return _boxToDragOn;
		}
		
		public function get boxToDragOnPos():Point {
			//trace("A>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>KJHKJKJ");
			var pos:Point = GoetheUtils.getGlobalPos(_boxToDragOn);
			pos.y -= Frame.MINI_HEIGHT;
			return pos; 
			//return new Point(_imgCont.x + _gapTextCont.x + _boxToDragOn.x, _imgCont.y + _gapTextCont.y + _boxToDragOn.y);
		}
		
		
		
	}

}