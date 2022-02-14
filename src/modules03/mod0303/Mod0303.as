package modules03.mod0303 
{
	import aze.motion.easing.Cubic;
	import aze.motion.eaze;
	import base.events.CustomEvent;
	import base.gui.Padding;
	import base.text.BasicText;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import goethe.GoetheColors;
	import gui.bigButtons.BigButton;
	import gui.buttons.TextButton;
	import gui.frame.Frame;
	import gui.handCursor.HandCursor;
	import gui.popIcon.PopIcon;
	import modules03.mod0301.Story;
	import rule.GenericRule;
	import utils.GoetheUtils;

	import utils.ArrayUtils;

	import modules.Module;

	/**
	 * ...
	 * @author andreasmuench.de
	 */
	public class Mod0303 extends Module
	
	{
		
		

		private var _mouseDownPoint:Point;
		private var _step1Cont:Sprite;
		private var _dragOnBoxes:Array = [];
		private var _stories:Array = [];
		private var _curStory:Story;
		private var _storiesRight:int = 0;
		// step2
		private var _step2Cont:Sprite;
		private var _table:Mod03Table;
		private var _boxes:Array = [];
		private var _curBox:Mod03TableBox;
		private var _boxesDone:int = 0;
		private var _row:ImperativeTableRow
		private var _curRowId:int = -1;
		private var _curStep:int = 1
		//step3
		private var _inf:Mod03InfoAnimation;
		private var _rule:GenericRule;
		
		//private var _helpMode:Boolean = false;
		
		
		public function Mod0303(xml:XML) 
		{
			trace("Mod03");
			super(xml);
			
			init();
			
			//endStep1();
			
			//startStep3();
			
		}
		
	
		private function init():void 
		{
			


			addHelpButton();
			addInfoButton();
			
			showTaskBox(_xml.set[2].task[0], "AUFGABE" );
			
			startStep1();
			//addImperativeTableRow();
			
			//startStep3()
			
			
		
		}
		
		private function startStep1():void 
		{
			_step1Cont = new Sprite();
			_cont.addChild(_step1Cont);
			for (var i:int = 0; i < 3; i++) {
				
				var box:StoryDragOnBox = new StoryDragOnBox(_xml.set[0].button[i]);
				_step1Cont.addChild(box);
				box.x = MainBase.STAGE_WIDTH / 2 + (i - 1) * 260 - box.width/2;
				box.y = 100;
				box.id = i;
				_dragOnBoxes.push(box);
				
			}
			
			var storyPositions:Array = [0, 1, 2];
			storyPositions = ArrayUtils.shuffle(storyPositions);
			i = 0;
			for each(var sxml:XML in _xml.set[2].story) {
				var s:Story = new Story(sxml, i);
				s.scale(Story.SCALE_SMALL, 0, true);
				s.y = 460;
				s.x = MainBase.STAGE_WIDTH / 2 + (storyPositions[i] - 1) * 240;
				s.customData.basePos = new Point(s.x, s.y);
				s.customData.isPlaced = false;
				s.addEventListener(MouseEvent.MOUSE_DOWN, onStoryMouseDown);
				s.buttonMode = true;
				_stories.push(s);
				_step1Cont.addChild(s);
				i++;
			}
		}
		
		
		
		private function onStoryMouseDown(e:MouseEvent = null, story:Story = null):void 
		{
			trace("onStoryMouseDown");
			if (story != null) {
				_curStory = story;
				_mouseDownPoint = new Point(_handCursor.x - _curStory.x, _handCursor.y - _curStory.y);
				_helpMode = true;
			} else {
				_curStory = e.currentTarget as Story;
				_mouseDownPoint = new Point(mouseX-_curStory.x, mouseY-_curStory.y);
			}
			_curStory.parent.addChild(_curStory);
			
			addEventListener(Event.ENTER_FRAME, onDragStoryEF);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onDragMouseUp);
		}
		
		private function onDragMouseUp(e:MouseEvent):void 
		{
			if (_helpMode && e != null) return;
			trace("onDragMouseUp");
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onDragMouseUp);
			removeEventListener(Event.ENTER_FRAME, onDragStoryEF);
			
			// auf welcher Box liegt die story?
			var leftSpace:Number = (MainBase.STAGE_WIDTH - 260 * 3);
			var pos:int = (_curStory.x +_curStory.width/2 +40 - leftSpace) / 260;
			pos  = Math.min(2, Math.max(0, pos));
			
			var right:Boolean = false;
			for each(var box:StoryDragOnBox in _dragOnBoxes) {	
			//	trace("box.hitTestPoint(mouseX, mouseY)", box.hitTestPoint(mouseX, mouseY))
				//if (box.hitTestPoint(mouseX, mouseY)) {
				//trace("pos ", pos, box.id);
				if (pos == box.id) {
					//trace("box.id == _curStory.id", box.id == _curStory.id);
					if (box.id == _curStory.id) {
						_popIcon.show(PopIcon.RIGHT, this, MainBase.STAGE_WIDTH, MainBase.STAGE_HEIGHT - 200 );
						eaze(_curStory).to(.5, { x:MainBase.STAGE_WIDTH / 2 + (box.id - 1) * 260 , y:230 } );
						_curStory.removeEventListener(MouseEvent.MOUSE_DOWN, onStoryMouseDown);
						_curStory.buttonMode = false;
						_curStory.customData.isPlaced = true;
						right = true;
						_storiesRight++;
						if (_storiesRight >= 3) {
							
							var tf:BasicText = new BasicText( { text : "Der Imperativ hat diese drei Funktionen." } ) 
							tf.y = 420;
							tf.x = (MainBase.STAGE_WIDTH - tf.width)/2
							_step1Cont.addChild(tf);
							eaze(tf).from(.5, { alpha: 0 } );
							
							eaze(this).delay(2).onComplete(function():void { showCustomButton( { hl: "weiter", onClick:endStep1 } ); } );
						}
					}
					break;
				}
				
			}
			
			if (!right) {
				_popIcon.show(PopIcon.WRONG, this, MainBase.STAGE_WIDTH, MainBase.STAGE_HEIGHT - 200 );
				eaze(_curStory).to(.5, { x:_curStory.customData.basePos.x, y:_curStory.customData.basePos.y } );
			}
			
			
		}
		
		
		
		private function onDragStoryEF(e:Event):void 
		{
			//trace("onDragStoryEF");
			trace("_curStory.x", _curStory.x, _curStory.y);
			if (_helpMode) {
				_curStory.x = _handCursor.x - _mouseDownPoint.x;
				_curStory.y = _handCursor.y - _mouseDownPoint.y
			} else {
				_curStory.x = mouseX - _mouseDownPoint.x;
				_curStory.y = mouseY- _mouseDownPoint.y
			}
			
			
		}
	
		
		private function endStep1(e:Event = null):void {
			if (_btnCustom) _btnCustom.hide();
			eaze(_step1Cont).to (.25, { alpha:0 } ).onComplete(startStep2)
			
			
	
			
			
		}
		
			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////// STEP 2
		///////////////////////////////////////////////////////////////////////////////////////////////
		private function ____________________________step2__________________________():void {}
		
		
		
		private function startStep2(e:Event=null):void 
		{
			_curStep = 2;
			showTaskBox(_xml.set[2].task[1], "AUFGABE" );
			
			_step2Cont = new Sprite();
			_cont.addChild(_step2Cont);
			
			_table = new Mod03Table(_xml.set[2].table[0]);
			_table.x = 300
			_table.y = 40;
			_step2Cont.addChild(_table);
			
			var i:int = 0;
			var positions:Array = [0, 1, 2];
			positions = ArrayUtils.shuffle(positions);
			for each(var bx:XML in _xml.set[2].table.box) {
				var box:Mod03TableBox = new Mod03TableBox(bx.toString());
				box.id = i;
				box.buttonMode = true;
				box.addEventListener(MouseEvent.MOUSE_DOWN, onBoxMD);
				box.y   = box.customData.y = 250 + i * 80;
				
				//box.x = box.customData.x = MainBase.STAGE_WIDTH / 2 + (positions[i] -1) * 160 - box.width / 2;
				box.x = box.customData.x = MainBase.STAGE_WIDTH / 2 - box.width / 2;
				box.customData.isPlaced = false;
				_step2Cont.addChild(box);
				_boxes.push(box);
				i++;
			}
			
			
			
			//addImperativeTableRow()
			
		}
		
		private function onBoxMD(e:MouseEvent=null, box:Mod03TableBox=null):void 
		{
			if (box != null) {
				_curBox = box;
				_mouseDownPoint = new Point(_handCursor.x - _curBox.x, _handCursor.y - _curBox.y);
				_helpMode = true;
			} else {
				_curBox = e.currentTarget as Mod03TableBox;
				_mouseDownPoint = new Point(mouseX-_curBox.x, mouseY-_curBox.y);
			}
			
			_curBox.parent.addChild(_curBox);
			
			addEventListener(Event.ENTER_FRAME, onDragBoxEF);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onDragBoxMU);
		}
		
		private function onDragBoxMU(e:MouseEvent=null):void 
		{
			if (_helpMode && e != null) return;
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onDragBoxMU);
			removeEventListener(Event.ENTER_FRAME, onDragBoxEF);
			
			var tx:Number ;
			var ty:Number;
			
			if (_helpMode) {
				tx = _handCursor.x - _table.x
				ty = _handCursor.y-_cont.y
			} else {
				tx = (mouseX - _table.x) ;
				ty = mouseY-_cont.y
			}
			
			if (ty > _table.y+Mod03Table.ROW_HEIGHT*.5 && ty < _table.y+Mod03Table.ROW_HEIGHT*2.5) {
			
				var id:int = Math.floor(tx / Mod03Table.COL_WIDTH);
				trace("id", id);
				if ((id == 2 && _curBox.id == 2) || ((id == 1 || id == 0) && (_curBox.id == 1 || _curBox.id == 0)   )) {
					_curBox.buttonMode = false;
					_curBox.removeEventListener(MouseEvent.MOUSE_DOWN, onBoxMD);
					_popIcon.show(PopIcon.RIGHT, this, MainBase.STAGE_WIDTH, MainBase.STAGE_HEIGHT - 200 );
					eaze(_curBox).to(.5, { x:_table.x + _curBox.id * (Mod03Table.COL_WIDTH + 1), y:_table.y+Mod03Table.ROW_HEIGHT+1 } );
					_boxesDone ++;
					_curBox.removeInteractivity();
					_curBox.drawBox(GoetheColors.GREEN);
					_curBox.customData.isPlaced = true
				} else {
					_popIcon.show(PopIcon.WRONG, this, MainBase.STAGE_WIDTH, MainBase.STAGE_HEIGHT - 200 );
					eaze(_curBox).to(.5, { x: _curBox.customData.x , y:_curBox.customData.y } );
				}
				
			} else {
				eaze(_curBox).to(.5, { x: _curBox.customData.x , y:_curBox.customData.y } );
			}
			
			if (_boxesDone >= 3) {
				addImperativeTableRow();
			}
			
		}

		
		private function addImperativeTableRow():void 
		{
			_curRowId ++;
			if (_curRowId >= _xml.set[2].table.row.length()) {
				
			
				
				showCustomButton( {hl: "weiter", onClick:endStep2 } );
				
			} else {
				_row = new ImperativeTableRow(_xml.set[2].table.row[_curRowId], this)//_xml.set[2].table.row[0]);
				_row.addEventListener(ImperativeTableRow.ALL_RUBBING_COMPLETE, onImperativeTableRowRubComplete, false, 0, true);
				_row.x = _table.x;
				_row.y = _table.y + _table.height + 1 + _curRowId*(_row.height+10);
				_step2Cont.addChild(_row);
				_row.alpha = 0;
				eaze(_row).to(.5, { alpha:1 } );
			}
		}
		
	
		
		private function onImperativeTableRowRubComplete(e:Event):void 
		{
			addImperativeTableRow();
		}
		
		
		
		private function onDragBoxEF(e:Event):void 
		{
			if (_helpMode) {
				_curBox.x = _handCursor.x - _mouseDownPoint.x;
				_curBox.y = _handCursor.y - _mouseDownPoint.y
			} else {
				_curBox.x = mouseX - _mouseDownPoint.x;
				_curBox.y = mouseY - _mouseDownPoint.y
			}
		}
		
		private function endStep2(x:*=null):void 
		{
			_btnCustom.hide();
			eaze(_step2Cont).to(.5, { alpha:0 } ).onComplete(startStep3);;
		}
		
		
		
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////// STEP 3
		///////////////////////////////////////////////////////////////////////////////////////////////
		private function ____________________________step3__________________________():void { }
		
		
		
		
		private function startStep3():void 
		{
			_curStep = 3;
			//trace(_xml.set[2]);
			_inf = new Mod03InfoAnimation(_xml.set[2].infoAnimation[0])//, onInfoAnimComplete);
			_inf.addEventListener(PopIcon.EVENT_RIGHT, onRuleRight);
			_inf.addEventListener(PopIcon.EVENT_WRONG, onRuleWrong);
			_inf.y = 40;
			_cont.addChild(_inf);
			eaze(this).delay(2).onComplete(showRule);
			
		}
		
		private function showRule():void {
				
			_rule = new GenericRule(_xml.set[2].rule[0], this);
			_rule.addEventListener(GenericRule.RIGHT, onRuleFeedback);
			_rule.addEventListener(GenericRule.WRONG, onRuleFeedback);
			_rule.addEventListener(GenericRule.SOLVED, onRuleSolved, false, 0, true);
			_rule.y = 360;
			_rule.x = (MainBase.STAGE_WIDTH - _rule.width) / 2;
			_cont.addChild(_rule);
		}
		
		private function onRuleFeedback(e:Event):void 
		{
			if (e.type == GenericRule.RIGHT) dispatchEvent(new Event(PopIcon.EVENT_RIGHT));
			else  dispatchEvent(new Event(PopIcon.EVENT_WRONG));
		}
		
		private function onRuleSolved(e:Event = null):void 
		{

			showNextButton();
		}
		

		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////// HELP BUTTON
		///////////////////////////////////////////////////////////////////////////////////////////////
		private function ____________________________help__________________________():void {}
		
		
		override protected function onHelpButtonClick(e:MouseEvent):void 
		{
			trace("onHelpButtonClick", _curStep);
			var pos:Point 
			var pos1:Point 
			var pos2:Point
			switch(_curStep) {
				
				case 1:
					var story:Story;
					for each(var s:Story in _stories) {
						if (!s.customData.isPlaced) {
							story = s;
							break;
						}
					}
					if (story) {
						var box:StoryDragOnBox = _dragOnBoxes[_stories.indexOf(story)];
					
						_btnHelp.removeEventListener(MouseEvent.CLICK, onHelpButtonClick);
						_helpOverlay.show(this);
						addChild(_handCursor);
						_handCursor.x = _btnHelp.x- 40
						_handCursor.y = _btnHelp.y + 10;
						_handCursor.show();
						
						//var pos:Point = new Point(story.x + story.width / 2, story.y + story.height / 2);
						pos = new Point(story.x , story.y );
						 pos2 = new Point(box.x + box.width / 2, box.y + box.height / 2);
						
						eaze(_handCursor).to(1, { x:pos.x, y:pos.y } ).easing(Cubic.easeInOut).onComplete(function():void {
							//ballToClick.onOver();
							_handCursor.click();
						}).delay(.25).onComplete(function():void {
							
						}).delay(.25).onComplete(function():void {
					
							onStoryMouseDown(null, story);
							//eaze(btn).to(1.5, { x:_rule.x+drop.x+drop.width/2, y:_rule.y+drop.y+drop.height/2} )//.onUpdate(onHelpDrag);
							//onSentenceElementMouseDown(null, _dragElem);
						}).to(1.5,  { x:pos2.x, y:pos2.y }  ).onComplete(function():void {
							//_dragBall.onOut();
							onDragMouseUp(null)//onBallMouseUp();
						}).delay(1).onComplete(onHelpComplete );
					
					}
					
					break;
					
					
				case 2:
					if (_boxesDone < 3) {
						trace("_boxesDone", _boxesDone);
						var bx:Mod03TableBox;
						for each(var b:Mod03TableBox in _boxes) {
							if (!b.customData.isPlaced) {
								bx = b;
								break;
							}
						}
						
						if (bx) {
							_btnHelp.removeEventListener(MouseEvent.CLICK, onHelpButtonClick);
							_helpOverlay.show(this);
							addChild(_handCursor);
							_handCursor.x = _btnHelp.x- 40
							_handCursor.y = _btnHelp.y + 10;
							_handCursor.show();
							
							pos = new Point(bx.x +bx.width/2, bx.y+bx.height/2 );
							pos2 = new Point(_table.x+bx.id*bx.width+bx.width/2, _table.y+bx.height+bx.height/2 );
							
							eaze(_handCursor).to(1, { x:pos.x, y:pos.y } ).easing(Cubic.easeInOut).onComplete(function():void {
								//ballToClick.onOver();
								_handCursor.click();
							}).delay(.5).onComplete(function():void {
		
								onBoxMD(null, bx);
								//eaze(btn).to(1.5, { x:_rule.x+drop.x+drop.width/2, y:_rule.y+drop.y+drop.height/2} )//.onUpdate(onHelpDrag);
								//onSentenceElementMouseDown(null, _dragElem);
							}).to(1.5,  { x:pos2.x, y:pos2.y }  ).onComplete(function():void {
								//_dragBall.onOut();
								onDragBoxMU(null)//onBallMouseUp();
							}).delay(1).onComplete(function():void { activateHelpButton(); _handCursor.hide(); _helpOverlay.hide(); _helpMode = false } );
							
						}
					} else {
						var textToRub:RubberText = _row.getUnsolvedRubbertext();
						if (textToRub) {
							//trace("textToRub", textToRub.customData.id);
							var rubAmnt:int  = textToRub.width-10//-20;
							pos = new Point(_row.x + _row.rubber.x, _row.y + _row.rubber.y); // wo der rubber liegt und abgeholt werden muss
							var handPos1:Point = new Point(_row.x + 10 + textToRub.customData.id*Mod03Table.COL_WIDTH, _row.y+40);
							var handPos2:Point = new Point(handPos1.x + rubAmnt, handPos1.y);
							var rubPos1:Point = new Point(handPos1.x-_row.x, handPos1.y-_row.y);
							var rubPos2:Point =  new Point(rubPos1.x + rubAmnt, rubPos1.y);
							var RUBBER_Y_OFFSET:int = 30;
							
							_btnHelp.removeEventListener(MouseEvent.CLICK, onHelpButtonClick);
							_helpOverlay.show(this);
							addChild(_handCursor);
							_handCursor.x = _btnHelp.x - 40
							_handCursor.y = _btnHelp.y + 10;
							_handCursor.show();
							
							// RUBBELN
							if (textToRub.customData.id < 2) { // hin und her rubbeln
								trace("SCHNELL RUBBELN");
								eaze(_handCursor).to(1, { x:pos.x, y:pos.y} ).easing(Cubic.easeInOut).onComplete(function():void { 
									_handCursor.click();
									_row.onRubberMouseDown(null);
								}).to(1, { x:handPos1.x, y:handPos1.y } ).to(.25, { x:handPos2.x, y:handPos2.y } ).to(.25, { x:handPos1.x, y:handPos1.y  } ).to(.25, { x:handPos2.x, y:handPos2.y } ).to(.25, { x:handPos1.x, y:handPos1.y  } ).to(.25, { x:handPos2.x, y:handPos2.y } ).to(.25, { x:handPos1.x, y:handPos1.y  } ).to(.25, { x:handPos2.x, y:handPos2.y } )
								.delay(.5).onComplete(function():void { _row.onMouseUp(null); _handCursor.hide(); activateHelpButton(); _helpOverlay.hide() } );
								
							} else { // LANGSAM SCHIEBEN
								trace("LANGSAM SCHIEBEN");
								eaze(_handCursor).to(1, { x:pos.x, y:pos.y} ).easing(Cubic.easeInOut).onComplete(function():void {
									_handCursor.click();
									_row.onRubberMouseDown(null);
								}).to(1, { x:handPos1.x, y:handPos1.y } ).to(3, { x:handPos2.x, y:handPos2.y } ).onComplete(function():void { _row.onMouseUp(null); _handCursor.hide(); activateHelpButton(); _helpOverlay.hide() } );

							}
						}
					}
					
					break;
				
				case 3:

					if (_rule) {
						var btn:TextButton = _rule.getNextTextButton();
						if (btn) {
							var dropArea:Sprite = _rule.getDropArea(btn);
							if (dropArea) {
								pos1 = GoetheUtils.getGlobalPos(btn, true);
								pos2 = GoetheUtils.getGlobalPos(dropArea, true );
								onHelpStart();
								eaze(_handCursor).to(1, { x:pos1.x, y:pos1.y } ).easing(Cubic.easeInOut).onComplete(function():void { // .onUpdate()
									//_btnCustom.onOver();
								}).delay(.25).onComplete(function():void {
									_handCursor.click();
									_rule.onBtnDown(null, btn)
								}).delay(.5).to(1, { x:pos2.x, y:pos2.y } ).easing(Cubic.easeInOut).onComplete(function():void {
									_rule.onMouseUp(null)
								
								}).delay(.5).onComplete(function():void {   onHelpComplete();   } );
							}
						}
					}
					
					/*if (!_inf.solved) {
					
						pos1 = new Point(_inf.x + _inf.btn1.x + _inf.btn1.width/2, _inf.y + _inf.btn1.y+_inf.btn1.height/2);
						pos2 = new Point(_inf.x + _inf.gap.x + _inf.gap.width/2 +_inf.gap.parent.x, _inf.y + _inf.gap.y + _inf.gap.height/2 + _inf.gap.parent.y);
						
						
						
						_btnHelp.removeEventListener(MouseEvent.CLICK, onHelpButtonClick);
						_helpOverlay.show(this);
						addChild(_handCursor);
						_handCursor.x = _btnHelp.x - 40
						_handCursor.y = _btnHelp.y + 10;
						_handCursor.show();
						
						eaze(_handCursor).to(1, { x:pos1.x, y:pos1.y} ).easing(Cubic.easeInOut).onComplete(function():void { 
							_handCursor.click();
							_inf.onBtnMD(null, _inf.btn1);
							eaze(_inf.btn1).to(1, { x:pos2.x - _inf.x - _inf.btn1.width/2, y: pos2.y - _inf.y -  _inf.btn1.height/2} );
						}).to(1, { x:pos2.x, y:pos2.y } )
						.delay(.5).onComplete(function():void { _inf.onBtnMU(null); _handCursor.hide(); activateHelpButton(); _helpOverlay.hide() } );
					}*/
					
					break;
					
					
				
				
			}
			/*if (_rule != null) {
			
				_btnHelp.removeEventListener(MouseEvent.CLICK, onHelpButtonClick);
				addChild(_handCursor);
				_handCursor.x = _btnHelp.x- 40
				_handCursor.y = _btnHelp.y + 10;
				_handCursor.show();
				
				var btn:TextButton = _rule.getNextTextButton();
				
				if (btn != null) {
					var drop:Sprite = _rule.getDropArea(btn);
					
					var pos:Point =  new Point(_rule.x+btn.x+btn.width/2 ,_rule.y+btn.y+btn.height/2); 
					eaze(_handCursor).to(1, { x:pos.x, y:pos.y } ).easing(Cubic.easeInOut).onComplete(function():void {
						//ballToClick.onOver();
					}).delay(.5).onComplete(function():void {
						_handCursor.click();
						_rule.onBtnDown(null, btn);
						//eaze(btn).to(1.5, { x:_rule.x+drop.x+drop.width/2, y:_rule.y+drop.y+drop.height/2} )//.onUpdate(onHelpDrag);
						//onSentenceElementMouseDown(null, _dragElem);
					}).to(1.5,  { x:_rule.x+drop.x+drop.width/2+Math.random()*20-10, y:_rule.y+drop.y+drop.height/2+Math.random()*10-5 }  ).onComplete(function():void {
						//_dragBall.onOut();
						_rule.onMouseUp(null)//onBallMouseUp();
					}).delay(1.5).onComplete(function():void { activateHelpButton(); _handCursor.hide() } );
					
				} else {
					trace("Btn = null");
				}
					
			}
			*/
			
			
		}
		
	
		
		

		
		
	
		
	
		
		private function onRuleWrong(e:Event):void 
		{
			_popIcon.show(PopIcon.WRONG, this, MainBase.STAGE_WIDTH, MainBase.STAGE_HEIGHT-200 );
		}
		
	
		
		private function onRuleRight(e:Event):void 
		{
			_popIcon.show(PopIcon.RIGHT, this, MainBase.STAGE_WIDTH, MainBase.STAGE_HEIGHT-200);
		}
		

	
		
	}

}