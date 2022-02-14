package modules03.mod0302 
{
	import aze.motion.easing.Cubic;
	import aze.motion.eaze;
	import base.events.CustomEvent;
	import base.gui.Dim;
	import base.gui.Padding;
	import base.text.BasicInput;
	import base.text.BasicText;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import goethe.GoetheColors;
	import gui.bigButtons.BigButton;
	import gui.buttons.TextButton;
	import gui.frame.Frame;
	import gui.handCursor.HandCursor;
	import gui.iconButtons.IconBtnClose;
	import gui.iconButtons.IconBtnHelp;
	import gui.iconButtons.IconBtnNext;
	import gui.input.specialKeyboard.MobileKeyboard;
	import gui.popIcon.PopIcon;
	import lt.uza.utils.Global;
	import utils.TraceUtils;

	import modules.Module;

	import modules03.mod0301.ImperativeMenuBox;
	import modules03.mod0301.Klammer;
	import modules03.mod0301.Mod0301;
	import modules03.mod0301.Story;
	import shapes.ClosedArc;
	/**
	 * ...
	 * @author andreasmuench.de
	 */
	public class Mod0302 extends Module
	{
	
		private var _menuCont:Sprite;
		private var _menuBoxes:Array = [];
		private var _backBtn:BackBtn;
		private var _stepTasks:Array = [];
		private var _taskCont:Sprite;
		//private var _rubber:McRubber = new McRubber();
		private var _tasksComplete:int = 0;
		private var _dim:Dim = new Dim();
		private var _story:Story;
		private var _btnCloseStory:IconBtnNext = new IconBtnNext(40);
		private var _curTask:int = -1;
		private var _task2Shown:Boolean = false;
		
		
		
		
		
		public function Mod0302(xml:XML) 
		{
			super(xml);
			
			init();
			
		}
		
		private function init():void 
		{
			//addTaskTf(_xml.set[1].task[0].toUpperCase());
			//global.rubber = _rubber;
			// MENU
			showTaskBox(_xml.set[1].task[0]);
			
			_menuCont = new Sprite();
			_cont.addChild(_menuCont);
			//dicke Boxen
			var i:int = 0;
			for each(var bx:XML in _xml.set[0].imperativeBox) {
				var box:ImperativeMenuBox = new ImperativeMenuBox(bx, GoetheColors.LIGHT_BLUE);
				box.addInteractivity();
				box.addEventListener(MouseEvent.CLICK, onImperativeMenuBoxCLick);
				box.id = i;
				box.x = 500;
				box.y = 100 + i * 160;
				_menuCont.addChild(box);
				_menuBoxes.push(box);
				//eaze(box).apply( { alpha:0 } ).delay(1).to(.5, { alpha:1 } );
				
				i++;
				
			}
			_backBtn = new BackBtn();
			_backBtn.addEventListener(MouseEvent.CLICK, onBackBtnClick);
			_backBtn.y = box.y + box.height+40; 
			_backBtn.x = 500 + box.width - _backBtn.width;
			eaze(_backBtn).apply( { alpha:0 } );
			_menuCont.addChild(_backBtn);
			
			
			// kleine boxen mit Imperativen
			i = 0;
			var yposes:Array = [Mod0301.S2BOX_Y + 8, 
								Mod0301.S2BOX_Y + 8 + 55, 
								Mod0301.S2BOX_Y + Mod0301.S2BOX_HEIGHT + Mod0301.S2BOX_PADDING1 + 8, 
								Mod0301.S2BOX_Y + Mod0301.S2BOX_HEIGHT + Mod0301.S2BOX_PADDING1 + 8 + 55,
								Mod0301.S2BOX_Y + Mod0301.S2BOX_HEIGHT * 2 + Mod0301.S2BOX_PADDING1 + Mod0301.S2BOX_PADDING2 + 8, 
								Mod0301.S2BOX_Y + Mod0301.S2BOX_HEIGHT * 3 + Mod0301.S2BOX_PADDING1 * 2 + Mod0301.S2BOX_PADDING2 + 8];
			var yposes2:Array = [40, 40, 70, 70, 70, -5];
								
			for each(var sx:XML in _xml.set[0].sentence) {
				//var ty:int = yposes[i];
				var txt:String = "";
				for each(var ex:XML in sx.elem) {
					if (ex.@type == "verb") {
						txt += ex.text + " ";	
					}
				}
				var tbox:SimpleWordBox = new SimpleWordBox(txt);
				
				_menuCont.addChild(tbox);
				tbox.x = 310;
				tbox.y = yposes[i] + yposes2[i];
			
				
				//eaze(sentCont).apply( { alpha:0 } ).delay(1).to(.5, { alpha:1 } );
				//	eaze(tCont).apply( { alpha:0 } ).delay(1).to(.5, { alpha:1 } );
				
				i++;
				
			//	addChild(_rubber);
			//	eaze(_rubber).apply( { alpha:0.1 } );
				
			}
			
			for (i = 0; i < 3; i++) {
				var klammer:Klammer = new Klammer();
				klammer.x = 460;
				klammer.y = 82 + i * 160;
				_menuCont.addChild(klammer);
			}
			
			_taskCont = new Sprite();
			_taskCont.x = MainBase.STAGE_WIDTH;
			_cont.addChild(_taskCont);
			i = 0;
			for each (var txml:XML in  _xml.set[1].steptask) {
				trace("txml", txml);
				var steptask:ImperativeStepsTask = new ImperativeStepsTask(txml)
				steptask.addEventListener(ImperativeStepsTask.STEPTASK_COMPLETE, onStepTaskComplete);
				steptask.addEventListener(ImperativeStep3Element.RUBBING_COMPLETE, onRubbingComplete);
				
				steptask.id = i;
				steptask.x = 200;
				steptask.y = 130;
				_stepTasks.push(steptask);
				i++;
				
			}
			
		//	_cont.addChild(_stepTasks[0]);
			
			
			addHelpButton()
			addInfoButton();

			//showTaskBox();
			
			//minimizeMenu();
			

		}
		
		private function onRubbingComplete(e:CustomEvent):void 
		{
			
			eaze(this).delay(1.5).onComplete(function():void {  // vorher delay war .5 // TODO check dealy
			
				addChild(_dim);
				_dim.show();
				_dim.addEventListener(MouseEvent.CLICK, onCloseStoryClick);
				
				var soundB:Boolean = e.param.xml.story[0].@sound != undefined && e.param.xml.story[0].@sound == "B";
				_story = new Story(e.param.xml.story[0], e.param.xml.story[0].@id);
				_story.scale(Story.SCALE_FULL, 0);
				_story.x = MainBase.STAGE_WIDTH / 2;
				_story.y = 300;
				_story.playStory(null, soundB);
				addChild(_story);
				
				
				_btnCloseStory.x = _story.x + Story.IMG_WIDTH/2;
				_btnCloseStory.y = _story.y - Story.IMG_HEIGHT/2;
				addChild(_btnCloseStory);
				_btnCloseStory.show();
				_btnCloseStory.addEventListener(MouseEvent.CLICK, onCloseStoryClick);
			});
			
		
		}
		
		private function onCloseStoryClick(e:MouseEvent):void 
		{
			_btnCloseStory.hide(.5);
			_dim.hide(.5);
			eaze(_story).to(.5, { alpha:0 } );
			_dim.removeEventListener(MouseEvent.CLICK, onCloseStoryClick);
			_btnCloseStory.removeEventListener(MouseEvent.CLICK, onCloseStoryClick);
			
		}
		
		private function onStepTaskComplete(e:Event):void 
		{
			_tasksComplete ++;
			_menuBoxes[_curTask].boxColor = GoetheColors.GREEN
			if (_tasksComplete >= 3) {
				showNextButton();
			}
		}
		
		private function onBackBtnClick(e:MouseEvent):void 
		{
			eaze(_menuCont).to(.5, { x: 0 } );
			for each(var box:ImperativeMenuBox in _menuBoxes) {
				box.hideSideText();
				box.highlight();
			}
			eaze(_taskCont).to(.5, { x: MainBase.STAGE_WIDTH } );
			eaze(_backBtn).to(.1 , { alpha:0 } );
			_curTask = -1;
		}
		
		private function onImperativeMenuBoxCLick(e:MouseEvent , clickedBox_:ImperativeMenuBox = null):void 
		{
			
			dispatchEvent(new CustomEvent(MobileKeyboard.HIDE_KEYS, true));
			
			var clickedBox:ImperativeMenuBox = (e != null) ? e.currentTarget as ImperativeMenuBox : clickedBox_;
			for each(var box:ImperativeMenuBox in _menuBoxes) {
				if (box == clickedBox) {
					box.highlight()
				} else {
					box.unhighlight();
				}
			}
			
			for each(var task:ImperativeStepsTask in _stepTasks) {
				if (task.id == clickedBox.id) {
					_taskCont.addChild(task);
					task.activate();
				} else {
					task.deactivate();
					if (_taskCont.contains(task)) _taskCont.removeChild(task);
				}
				
			}
			eaze(_taskCont).to(.5, { x:80 } );
			minimizeMenu();
			_curTask = clickedBox.id;
			
			if (!_task2Shown) {
				_task2Shown = true;
				//showTaskBox(_xml.set[1].task[1], _xml.set[1].taskHl[0].toString().toUpperCase()); // hacky
			}
			
		}
		
		private function minimizeMenu():void 
		{
			eaze(_menuCont).to(.5, { x: -690 } );
			for each(var box:ImperativeMenuBox in _menuBoxes) {
				box.showSideText();
			}
			eaze(_backBtn).delay(.5).to(.25 ,{ alpha:1 } );
		}

		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////// HELP BUTTON
		///////////////////////////////////////////////////////////////////////////////////////////////
		

		override protected function onHelpButtonClick(e:MouseEvent):void 
		{
			
			
			if (_curTask == -1) {
				// noch nicht fertige task finden
				help_clickUndoneTask()

			} else {
				
				var task:ImperativeStepsTask = _stepTasks[_curTask];
				
				if (task.done) {
					if (allTasksDone()) help_clickNextButton();
					else help_clickUndoneTask();
					
				} else {
					
					if (task.currentVarIsDone()) {
						help_chooseVariant(_stepTasks[_curTask].getStep1OtherImperativeButton());
						
					} else {
						
						// welcher schritt ist aktiv?
						var curStep:int = task.getCurrentStep();
						
						switch(curStep) {
							case 1:
								help_chooseVariant(task.getStep1FirstImperativeButton());
								break;
								
							case 2: // texteingabe
								task.currentStep2Elem.inputBox.specialInputField.help();
								break;
								
							case 3: //radieren
								help_rub(task);
								break;
						}
						
					}
					
				}
				
			}
			
		}
		
		private function allTasksDone():Boolean 
		{
			
			for each(var task:ImperativeStepsTask in _stepTasks) {
				if (!task.done) return false;
			}
			return true
		}
		
		/**
		 * andere infinitivForm auswählen
		 */
		private function help_chooseVariant(btnToClick:TextButton):void 
		{
			deactivateHelpButton()
			_helpOverlay.show(this);
			addChild(_handCursor);
			_handCursor.x = _btnHelp.x- 40
			_handCursor.y = _btnHelp.y + 10;
			_handCursor.show();
			
		//	var btnToClick:TextButton = 
			
			
			var btnPos:Point = new Point(btnToClick.parent.parent.x+btnToClick.parent.x+ btnToClick.x, Frame.MINI_HEIGHT+ btnToClick.parent.y+btnToClick.y);
			
			eaze(_handCursor).to(1, { x:btnPos.x+btnToClick.width/2, y:btnPos.y+btnToClick.height/2-60} ).easing(Cubic.easeInOut).onComplete(function():void {
						_handCursor.click();
						_stepTasks[_curTask].onChooseInfinitiveClick(null,btnToClick );
					}).delay(.5).onComplete(function():void { _handCursor.hide(); activateHelpButton(); _helpOverlay.hide()} );
			
			
		}
		
		
		private function help_clickNextButton():void 
		{
			_helpOverlay.show(this);
			addChild(_handCursor);
			_handCursor.x = _btnHelp.x- 40
			_handCursor.y = _btnHelp.y + 10;
			_handCursor.show();
			eaze(_handCursor).to(1, { x:_btnNext.x+_btnNext.width/2, y:_btnNext.y+_btnNext.height/2 } ).easing(Cubic.easeInOut).onComplete(function():void {
				_btnNext.onOver()
			}).delay(.5).onComplete(function():void {
				_handCursor.click();
				onNextClick();
			}).delay(.5).onComplete(function():void { _handCursor.hide(); _helpOverlay.hide() } );
		}
		
		private function help_rub(task:ImperativeStepsTask):void 
		{
			deactivateHelpButton();
			var s3el:ImperativeStep3Element = task.currentStep3Elem;
			TraceUtils.traceDisplayObjectParents(s3el);
			var rubberPos:Point = new Point(s3el.parent.x + s3el.parent.parent.x + s3el.parent.parent.parent.x+ s3el.x + s3el.rubber.x , Frame.MINI_HEIGHT+s3el.parent.y + s3el.parent.parent.y + s3el.parent.parent.parent.y+s3el.y + s3el.rubber.y); // + Frame.MINI_HEIGHT
			//var btnPos:Point = 
			var box:Sprite = s3el.box;
			
			var boxPos:Point = new Point(box.parent.x + box.parent.parent.x + box.parent.parent.parent.x + box.parent.parent.parent.parent.x + box.parent.parent.parent.parent.parent.x + box.x, 
			Frame.MINI_HEIGHT+box.parent.y + box.parent.parent.y + box.parent.parent.parent.y + box.parent.parent.parent.parent.y + box.parent.parent.parent.parent.parent.y +box.y);
			//trace("BOXPOS", boxPos.toString())
		//	boxPos = s3el.box.parent.localToGlobal(boxPos);
			boxPos.x -= 20;
			boxPos.y += 0;
			//trace("BOXPOS", boxPos.toString())
			var RUBBER_Y_OFFSET:int = 30;
			//trace("box", box);
			//trace("box.parent.x", box.parent.x)
			_helpOverlay.show(this);
			addChild(_handCursor);
			_handCursor.x = _btnHelp.x- 40
			_handCursor.y = _btnHelp.y + 10;
			_handCursor.show();
			var rubx1:int = box.parent.x//260
			trace("task.id", task.id);
			
			if (task.id < 2) { // hin und her rubbeln
				trace("SCHNELL RUBBELN");
				eaze(_handCursor).to(1, { x:rubberPos.x-30, y:rubberPos.y-30} ).easing(Cubic.easeInOut).onComplete(function():void { // +s3el.rubber.height/2 // +s3el.rubber.width/2
					_handCursor.click();
					//s3el.onRubberMouseDown(null);
					eaze(s3el.rubber).to(.5, { x:rubx1, y:box.y+RUBBER_Y_OFFSET } ).to(.25, { x:rubx1+box.width } ).onUpdate(s3el.rub).to(.25, { x:rubx1} ).onUpdate(s3el.rub).to(.25, { x:rubx1+box.width } ).onUpdate(s3el.rub).to(.25, { x:rubx1 } ).onUpdate(s3el.rub).to(.25, { x:rubx1+box.width } ).onUpdate(s3el.rub).to(.25, { x:rubx1} ).onUpdate(s3el.rub).to(.25, { x:rubx1+box.width } ).onUpdate(s3el.rub)//.to(.25, { x:rubx1} ).onUpdate(s3el.rub).to(.25, { x:rubx1+box.width } ).onUpdate(s3el.rub)//.to(.25, { x:rubx1 } ).onUpdate(s3el.rub).to(.25, { x:rubx1+box.width } ).onUpdate(s3el.rub).to(.25, { x:rubx1} ).onUpdate(s3el.rub);
					
				}).to(.5, { x:boxPos.x, y:boxPos.y } ).to(.25, { x:boxPos.x+box.width } ).to(.25, { x:boxPos.x } ).to(.25, { x:boxPos.x+box.width } ).to(.25, { x:boxPos.x } ).to(.25, { x:boxPos.x+box.width } ).to(.25, { x:boxPos.x } ).to(.25, { x:boxPos.x+box.width } )//.to(.25, { x:boxPos.x } ).to(.25, { x:boxPos.x+box.width } )//.to(.25, { x:boxPos.x } ).to(.25, { x:boxPos.x+box.width } ).to(.25, { x:boxPos.x } )
				.delay(.5).onComplete(function():void { _handCursor.hide(); activateHelpButton();_helpOverlay.hide() } );
				
			} else { // LANGSAM SCHIEBEN
				trace("LANGSAM SCHIEBEN");
				eaze(_handCursor).to(1, { x:rubberPos.x-30, y:rubberPos.y-30} ).easing(Cubic.easeInOut).onComplete(function():void { // +s3el.rubber.height/2 // +s3el.rubber.width/2
					_handCursor.click();
					eaze(s3el.rubber).to(.5, { x:rubx1, y:box.y + RUBBER_Y_OFFSET } ).to(3, { x:rubx1 + box.width } ).onUpdate(s3el.rub)
				}).to(.5, { x:boxPos.x, y:boxPos.y } ).to(3, { x:boxPos.x + box.width } )
				.delay(.5).onComplete(function():void { _handCursor.hide(); activateHelpButton();_helpOverlay.hide() } );
			}
			
		}
		
		
		
		private function help_clickUndoneTask():void 
		{
			deactivateHelpButton()
			var menuBoxToClick:ImperativeMenuBox;
				var i:int = 0;
				for each(var task:ImperativeStepsTask in _stepTasks) {	
					if (!task.done) break;
					else i++;
				}
				menuBoxToClick = _menuBoxes[i];
				var menuBoxX:Number = _curTask == -1 ? menuBoxToClick.x + menuBoxToClick.width / 2 : 20;
				
				_helpOverlay.show(this);
				addChild(_handCursor);
				_handCursor.x = _btnHelp.x- 40
				_handCursor.y = _btnHelp.y + 10;
				_handCursor.show();
				eaze(_handCursor).to(1, { x:menuBoxX, y:menuBoxToClick.y+menuBoxToClick.height/2} ).easing(Cubic.easeInOut).onComplete(function():void {
						_handCursor.click();
						onImperativeMenuBoxCLick(null, menuBoxToClick);
					}).delay(.5).onComplete(function():void { _handCursor.hide(); activateHelpButton(); _helpOverlay.hide()} );
		}
		
		
		
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////// HELP BUTTON ENDE
		///////////////////////////////////////////////////////////////////////////////////////////////		
		




		
	}

}