package modules03.mod0302 
{
	import aze.motion.eaze;
	import base.events.CustomEvent;
	import base.gui.tooltip.Tooltip;
	import base.text.BasicText;
	import flash.display.Sprite;
	import flash.events.Event;
	import goethe.GoetheColors;
	import gui.buttons.TextButton;
	import gui.input.InputBox;
	import gui.input.SpecialInputField;
	import gui.input.specialKeyboard.MobileKeyboard;
	import lt.uza.utils.Global;
	/**
	 * ...
	 * @author 
	 * 
	 * 
	 * 	<step2>
			<form><![CDATA[du|probierst an]]></form>
			<error><![CDATA[Das ist leider falsch. <br />Tipp: Ich probiere an, du probier_ _ an.]]></error>
		</step2>
			
	 * 
	 * 
	 */
	public class ImperativeStep2Element extends Sprite
	{
		private var global:Global = Global.getInstance();
		private var _xml:XML;
		private var _tf:BasicText;
		private var _formBox:TextButton;
		private var _inputBox:InputBox
		private var _tt:Tooltip;
		private var _foot2:Sprite = new McFoot();
		//private var _inputBg:Sprite = new Sprite();pri
		private var _isDone:Boolean = false;
		private var _firstActivation:Boolean = true;
		
		public function ImperativeStep2Element(xml:XML, xmlParent:XML) 
		{
			_xml = xml;
			trace("ImperativeStep2Element");
			//addChild(_inputBg);
			
			eaze(_foot2).to(0, { tint:GoetheColors.GREY_30 } );
			_foot2.y = 20;
			_foot2.x = 0
			addChild(_foot2);
			//_foot2.scaleX = -1;
			_tf = new BasicText( { text:xmlParent.common.step2, fontColor:GoetheColors.GREY_30 } );
			_tf.x = 60;
			addChild(_tf);
			
			
			//var splitTxt:Array = xml.form.toString().split("|");
			
			//trace("------------------xml", xml);
			//trace("------------------splitTxt[0]", splitTxt[0]);
			_formBox = new TextButton( { text:xml.textBefore, boxColor:GoetheColors.LIGHT_BLUE } );
			_formBox.x = _tf.x + _tf.width +30;
			_formBox.y = -7
			_formBox.interactive = false;
			_formBox.removeGlow();
			addChild(_formBox);
			_formBox.alpha = 0;
			
			_tt = global.tooltip;
			
			
			_inputBox = new InputBox( { text:xml.textInput, textAfter:xml.textAfter } );
			//_inputBox.addEventListener(SpecialInputField.PRESS_ENTER, onPressEnter);
			_inputBox.x = _formBox.x + _formBox.width + 20;
			_inputBox.alpha = 0;
			addChild(_inputBox);
			
			_inputBox.addEventListener(SpecialInputField.TEXT_COMPLETE, onTextComplete);
			_inputBox.addEventListener(SpecialInputField.ALL_FILLED_OUT_WRONG, onAllFilledOutWrong);
			
			//_inputBg.graphics.beginFill(GoetheColors.LIGHT_BLUE);
			//_inputBg.graphics.drawRoundRect(_inputBox.x, _inputBox.y, _inputBox.width, 50, 20,20);
			
		}
		
		private function onTextComplete(e:Event):void 
		{
			trace("sttep2::onTextComplete");
			_formBox.boxColor = GoetheColors.GREEN;
			eaze(_foot2).to( .5, { tint:GoetheColors.GREEN } )//.onUpdate(function():void { trace(">>>>>>>>>>>>>>>>>>>>>>-----") } );;
			//eaze(_foot2).apply( { tint:GoetheColors.GREEN } );
			
			dispatchEvent (new CustomEvent(MobileKeyboard.HIDE_KEYS, true));
		}
		
		private function onAllFilledOutWrong(e:Event):void 
		{
			
			addChild(_tt);
			_tt.setPos(_inputBox.x + _inputBox.width / 2-20, 0);
			_tt.show(_xml.error[0], 4);
		}
		
		public function activate():void 
		{
			if (_firstActivation) {
				eaze(_foot2).delay(1).to(.5, { tint:GoetheColors.GREY } );
				eaze(_tf).delay(1).to(.5, { tint:GoetheColors.BLACK } );
				eaze(_formBox).delay(2).to(.5, { alpha:1 } );
				eaze(_inputBox).delay(2.5).to(.5, { alpha:1 } ).onComplete(function():void { _firstActivation = false; _inputBox.setFocus()});
			} else {
				_inputBox.setFocus()
			}
			
			//_inputBox.setFocus();
		}
		
		public function deactivate():void {

			trace("deactivate");
			if (_firstActivation) {
				eaze(_foot2).killTweens();
				eaze(_tf).killTweens();
				eaze(_formBox).killTweens();
				eaze(_inputBox).killTweens();
			}
		
			_inputBox.deactivate();
			dispatchEvent(new CustomEvent(MobileKeyboard.HIDE_KEYS, true));
		}
		
		public function get inputBox():InputBox 
		{
			return _inputBox;
		}
		
		public function get isDone():Boolean 
		{
			return _isDone;
		}
		
	}

}