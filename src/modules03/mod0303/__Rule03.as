package modules03.mod03 
{
	import aze.motion.easing.Elastic;
	import aze.motion.eaze;
	import base.gui.Padding;
	import base.text.BasicText;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import goethe.GoetheColors;
	import gui.bigButtons.BigButton;
	import gui.buttons.TextButton;
	import lt.uza.utils.Global;
	/**
	 * ...
	 * @author andreasmuench.de
	 */
	public class Rule03 extends Sprite
	{
		private var global:Global = Global.getInstance();
		private var _stage:Stage ;
	//	private var _cont:Sprite;
		private var _curBtn:TextButton
		//private var _dropArea:Sprite;
		private var _mouseDownPoint:Point;
		private var _dropAreas:Array = [];
		private var _solved:Array = [0, 0, 0];
		
		
		public static const SOLVED:String = "solved";
		public static const WRONG:String = "WRONG";
		public static const RIGHT:String = "RIGHT";
		
		public function Rule03(xml:XML)
		{
			
			_stage = global.stage;
			
			var xp:Number = 0;
			var yp:Number = 20;
			
			//_cont = new Sprite();
			//addChild(_cont);
			
		/*	var hl:BasicText = new BasicText( { txt:xml.headline.toString().toUpperCase(), fontWeight:"bold", fontColor:0xffffff } );
			hl.y = yp;
			hl.x = 24;
			yp += hl.height + 15;
			addChild(hl);
			
			var copy:BasicText = new BasicText( { txt:xml.copy } );
			copy.x = hl.x;
			copy.y = 	yp
			yp += copy.height + 30;
			addChild(copy);
			*/
			
			
			xp = 70;
			
			var btnPositions:Array = [0, 1, 2];
			var btnPositionsShuffled:Array = [];
			while (btnPositions.length > 0) {
				btnPositionsShuffled.push(btnPositions.splice(Math.round(Math.random() * (btnPositions.length - 1)), 1)[0]);
			}
		//trace(xml);
			var i:int = 0;
			for each (var sx:XML in xml.sentence) {
				//trace(bx);
				var splitTxt:Array = sx.text.toString().split("|");
				//trace("splitTxt[0]", splitTxt[0]);
				//trace("splitTxt[1]", splitTxt[1]);
				//trace("splitTxt[2]", splitTxt[2]);
				
				var txt1:BasicText = new BasicText( { txt:splitTxt[0] } );
				txt1.y = yp;
				txt1.x = 24;
				addChild(txt1);
				
				var btn:TextButton = new TextButton( { text:splitTxt[1], width:200, textAlign:"center", color:GoetheColors.GREEN, padding:new Padding([3,6,4,6]) } );
				btn.id = i;
				btn.addEventListener(MouseEvent.MOUSE_DOWN, onBtnDown);
				btn.y = 180;
				btn.x = 24 + btnPositionsShuffled [i] * 210;
				btn.setBasePos();
				xp += btn.width + 12;
				addChild(btn);
				
				var dropArea:Sprite = new Sprite();
				dropArea.name = String(i);
				dropArea.graphics.beginFill(0xffffff);
				dropArea.graphics.drawRoundRect( 0, 0, btn.width, btn.height, 16);
				dropArea.x = txt1.x + txt1.width + 10;
				dropArea.y = yp;
				_dropAreas.push(dropArea);
				addChild(dropArea);
				
				var txt2:BasicText = new BasicText( { txt:splitTxt[2] } );
				txt2.y = txt1.y;
				txt2.x = dropArea.x + dropArea.width + 12;
				addChild(txt2);
			
				
				i++;
				
				yp += 50;
			}
			

			graphics.beginFill(GoetheColors.GREY);
			graphics.drawRoundRect(0, 0, this.width+48, this.height+60, 30);
			
			//_cont.x = (this.width - _cont.width) / 2;
			//_cont.y = (this.height - _cont.height) / 2;
			
			alpha = 0;
			eaze(this).to(.5, { alpha:1 } );
			
			
		}
		
		private function onBtnDown(e:MouseEvent):void 
		{
			_curBtn = e.currentTarget as TextButton
			addEventListener(Event.ENTER_FRAME, onDragEnterFrame);
			_stage.addEventListener(MouseEvent.MOUSE_UP , onMouseUp)
			
			_curBtn.parent.addChild(_curBtn); // nach vorne
			_mouseDownPoint = new Point(e.localX, e.localY);

		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			_stage.removeEventListener(MouseEvent.MOUSE_UP , onMouseUp)
			removeEventListener(Event.ENTER_FRAME, onDragEnterFrame);
			
			var moveBack:Boolean = true;
			
			for each (var dropArea:Sprite in _dropAreas) {

				if (_curBtn.x < dropArea.x + dropArea.width && _curBtn.x +_curBtn.width >dropArea.x
					&& _curBtn.y < dropArea.y + dropArea.height && _curBtn.y +_curBtn.height > dropArea.y ) {
					trace("GETROFFEN");
					if (_curBtn.id == int(dropArea.name)) { // richtiger "position 2"
						trace("RICHTIG");
						moveBack = false;
						eaze(_curBtn).to(.5, { x:dropArea.x, y:dropArea.y } ).easing(Elastic.easeOut);
						dispatchEvent(new Event(RIGHT));
						_solved[_curBtn.id] = 1;
						if (_solved.indexOf(0) == -1) {
							deactivateInteractivity();
							dispatchEvent(new Event(SOLVED));
						}
						
						
					} else { // falsch
						trace("FALSCH");
						//eaze(_curBtn).to(.5, { x:_curBtn.basePos.x, y:_curBtn.basePos.y } ).easing(Elastic.easeOut);
					//	_curBtn.boxColor = GoetheColors.ORANGE ;
						dispatchEvent(new Event(WRONG));
					}
					
					
				} else { //daneben
					trace("DANEBEN");
					
				}
			
			}
			
			if (moveBack) eaze(_curBtn).to(.5, { x:_curBtn.basePos.x, y:_curBtn.basePos.y } ).easing(Elastic.easeOut);
			
		}
		
		private function deactivateInteractivity():void 
		{
			for (var i:int = 0; i < this.numChildren; i++) {
				var mc:DisplayObject = this.getChildAt(i);
				if (mc is TextButton) mc.removeEventListener(MouseEvent.MOUSE_DOWN, onBtnDown);
			}
		}
		
		private function onDragEnterFrame(e:Event):void 
		{
			_curBtn.x = mouseX - _mouseDownPoint.x;
			_curBtn.y = mouseY - _mouseDownPoint.y
		}
		
	}

}