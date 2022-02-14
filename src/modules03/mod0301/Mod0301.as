package modules03.mod0301 
{
	import aze.motion.easing.Cubic;
	import aze.motion.easing.Elastic;
	import aze.motion.easing.Quart;
	import aze.motion.eaze;
	import base.events.CustomEvent;
	import base.gui.Dim;
	import base.gui.Padding;
	import base.gui.tooltip.Tooltip;
	import base.images.BasicImage;
	import base.images.SimpleImage;
	import base.images.SimpleMultiImage;
	import base.text.BasicText;
	import base.text.FontUtils;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import gui.bigButtons.BigButton;
	import gui.buttons.TextButton;

	import modules03.sentences.Sentence;
	import modules03.sentences.SentenceContainer;
	import modules03.sentences.SentenceElement;
	import utils.ArrayUtils;


	
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import goethe.GoetheColors;
	import gui.frame.Frame;
	import gui.handCursor.HandCursor;
	import gui.iconButtons.IconBtnHelp;
	import gui.iconButtons.IconBtnPlay;
	import gui.popIcon.PopIcon;
	import modules.Module;


	import lt.uza.utils.Global;

	import text2speech.TextToSpeech;
	/**
	 * ...
	 * @author andreasmuench.de
	 */

	public class Mod0301 extends Module
	{

		private var _stories:Array = [];
		private var _btnCont:Sprite 
		private var _curStory:Story;
		private var _errorStory:Story;

		private var _btn1:TextButton;
		private var _btn2:TextButton;
		private var _btn3:TextButton;
		private var _storiesUnderButtons:Array = [0, 0, 0];
		private var _taskShowed:Boolean = false;
		private var _curHelpTask:int = 0;
		
		private static const BTNCONT_Y:int = 360;
		
		// step2
		private var _bgStep2:Step2Background;
		private var _mouseDownPoint:Point;
		private var _storiesInBoxes:Array = [[], [], [], []];
		public static const S2BOX_X:int =  30;
		public static const S2BOX_Y:int = 60;
		public static const S2BOX_WIDTH:int = 720
		public static const S2BOX_HEIGHT:int = 120
		public static const S2BOX_PADDING1:int = 10
		public static const S2BOX_PADDING2:int = 40;
		
		
		// step3
	//	private var _curImpBox:ImperativeBox;
		private var _sentConts:Array = [];
		private var _imperativeConts:Array = [];
		private var _dragElem:SentenceElement;
		private var _dragElemPartner:SentenceElement;
		//private var _helpMode:Boolean = false;
		private var _imperativesFound:int = 0;
		
		private var _klammern:Array = [];
		

		
		public function Mod0301(xml:XML) 
		{
			super(xml);
			
			init();
			
			//trace(xml);
		//	endStep1();
		
		}
		
		public function init():void {
			graphics.drawRect(0, 0, MainBase.STAGE_WIDTH, MainBase.STAGE_HEIGHT); // damit für popicon die richtigen maße stimmen
			
			
			startStep1();
			 
			addHelpButton()
			addInfoButton();
			//startStep3();
		}
			
		private function startStep1():void {
			var i:int = 0;
			for each(var sxml:XML in _xml.set[0].story) {
				
				var s:Story = new Story(sxml, i);
				if (sxml.@firstSentence == "true") s.customData.firstSentence = true
				_stories.push(s);
				_cont.addChild(s);
				i++;
			}
			
			// buttons
			_btnCont = new Sprite();
			_btnCont.y =500
			_btn1 = new TextButton( { text:_xml.set[0].button[0] } );
			_btn1.addEventListener(MouseEvent.CLICK, onBtnClick);
			_btn1.x = MainBase.STAGE_WIDTH / 2 - 250 - _btn1.width / 2;
			_btn2 = new TextButton( { text:_xml.set[0].button[1]  } );
			_btn2.addEventListener(MouseEvent.CLICK, onBtnClick);
			_btn2.x = MainBase.STAGE_WIDTH / 2  - _btn2.width / 2;
			_btn3 = new TextButton( { text:_xml.set[0].button[2] } );
			_btn3.addEventListener(MouseEvent.CLICK, onBtnClick);
			_btn3.x = MainBase.STAGE_WIDTH/ 2 + 250 - _btn3.width / 2;
			_btnCont.addChild(_btn1);
			_btnCont.addChild(_btn2);
			_btnCont.addChild(_btn3);
			
			setupStoriesToChoose();
			
			showTaskBox();
			
			//endStep1();
			
		}
		
		// stories anordnen damit eine ausgewählt wird
		private function setupStoriesToChoose():void {
			if (undoneStoriesNum() < 1) {
				endStep1();
			} else {
				_currentTask = _xml.set[0].task[0];
				_curHelpTask = 0;
				var i:int = undoneStoriesNum() - 1
				var rowsNum:int = undoneStoriesNum() > 2 ? 2 : 1;
				var yp:Number = rowsNum > 1 ? 220 : 300;
				//var colsNums:Array;
				//colsNums[0] = row
				var colNum:Number = Math.ceil(undoneStoriesNum() / rowsNum); // anzahl der bilder in der reihe
				var xp:Number = (MainBase.STAGE_WIDTH- (colNum-1) * 260) / 2
				var num:int = 0;
				
				for each (var s:Story in _stories) {
					if (!s.done) {
						s.addEventListener(MouseEvent.CLICK, onStoryClick);
						s.x = (MainBase.STAGE_WIDTH ) / 2 + i * 50;
						s.y = -300//
						s.scale(Story.SCALE_SMALL, 0, false);
						s.buttonMode = true;
						eaze(s).to(.5, {  alpha:1,x:xp, y:yp} );
						i--;	
						num++;
						xp += 260;
						if (num == colNum) {
							 
							colNum = Math.floor(undoneStoriesNum() / rowsNum) //  anzahl der bilder in 2. reihe
							xp = (MainBase.STAGE_WIDTH - (colNum-1) * 260) / 2 // xp zurücksetzen
							yp += 220;
						}
					} 
				}
				// buttons und gemachte Sätze unten rausfahren
				eaze(_btnCont).to(.5, { y:BTNCONT_Y+400 } );
				for each ( s in _stories) {
					if (s.done) eaze(s).to(.5, { y:s.customData.ypos+400 } );
				}
			}
			
			
		}
	
	
		
		
		private function onStoryClick(e:MouseEvent, curStory:Story = null):void 
		{
			//var clickedStory:Story
			deactivateHelpButton();
			_curStory = curStory != null ? curStory : e.currentTarget as Story;
			//addChild(_curStory);
			_curStory.parent.addChild(_curStory);
			
			for each (var s:Story in _stories) {
				s.removeEventListener(MouseEvent.CLICK, onStoryClick); // keine mehr anklickbar!
				s.buttonMode = false;
				if (s != _curStory && !s.done) eaze(s).to(.5, { y:-300, alpha: 0 } );
			}
			eaze(_curStory).to(.5, { x:MainBase.STAGE_WIDTH / 2, y:280,  scaleX:1, scaleY:1 } ).filter(BlurFilter, { blurX:0, blurY:0, quality:3 } )
			_curStory.scale(Story.SCALE_FULL);
			_curStory.playStory(onStoryPlayed);
			
			
			
		}
		
		private function onStoryPlayed():void 
		{
			eaze(this).delay(2).onComplete(function():void {
				if (_curStory.customData.firstSentence) _curStory.showFirstImage();
			//	_curStory.showImperativeTextOnly();
				_curStory.scale(Story.SCALE_MEDIUM);
				eaze(_curStory).to(.5, { y:160 } );
				showButtons();
				
				_currentTask = _xml.set[0].task[1];
				if (!_taskShowed) {
					showTaskBox();
					_taskShowed = true;
				}
				_curHelpTask = 1;
				activateHelpButton();
				
			});
		}
		
		private function showButtons():void {
			
			_btnCont.mouseEnabled = _btnCont.mouseChildren = true;
			_cont.addChild(_btnCont);
			// buttons und gemachte Sätze unten reinfahren
			eaze(_btnCont).to(.5, { y:BTNCONT_Y } );
			for each (var s:Story in _stories) {
				if (s.done) {
					eaze(s).to(.5, { y:s.customData.ypos, alpha:1 } );
					trace("s.customData.ypos", s.customData.ypos);
				}
			}
			
		}
		
		private function onBtnClick(e:MouseEvent , btn:TextButton=null):void 
		{
			var clickedBtn:TextButton = btn != null ? btn : e.currentTarget as TextButton;
			if (_curStory.type == 0 && clickedBtn == _btn1 ||	_curStory.type == 1 && clickedBtn == _btn2 ||	_curStory.type == 2 && clickedBtn == _btn3 ) {
				_curStory.parent.addChild(_curStory);
				_curStory.scale(Story.SCALE_TINY, .5, false);
				_curStory.done = true; //ist bearbeitet!
				_btnCont.mouseEnabled = _btnCont.mouseChildren = false; // buttons deaktivieren
				_popIcon.show(PopIcon.RIGHT, this, MainBase.STAGE_WIDTH, MainBase.STAGE_HEIGHT - 200 );
				eaze(this).delay(1.5).onComplete(setupStoriesToChoose);
				_curStory.customData.ypos = BTNCONT_Y + 120 + _storiesUnderButtons[_curStory.type] * 110;
				_curStory.customData.yposEndStep1 = BTNCONT_Y - 300 + 150 + _storiesUnderButtons[_curStory.type] * 200; // position am ende von step1
				eaze(_curStory).to(.5, { y:_curStory.customData.ypos, x:MainBase.STAGE_WIDTH/2 + (-1+_curStory.type)*250 } );
				_storiesUnderButtons[_curStory.type] ++; // markieren, dass hier eine story mehr drunter ist
			} else {
				_popIcon.show(PopIcon.WRONG, this, MainBase.STAGE_WIDTH, MainBase.STAGE_HEIGHT-200 );
			}
			
		}
		

		
	
		private function doneStoriesNum():int {
			var num:int = 0;
			for each (var s:Story in _stories) {
				if (s.done) num++;		
			}
			return num;
		}
			
		private function undoneStoriesNum():int {
			var num:int = 0;
			for each (var s:Story in _stories) {
				if (!s.done) num++;		
			}
			return num;
		}	
		
		
			
		private function endStep1():void 
		{
			eaze(_btnCont).to(.5, { y:BTNCONT_Y-300 } );
			for each (var s:Story in _stories) {
				s.removeEventListener(MouseEvent.CLICK, onStoryClick);
				eaze(s).to(.5, { y:s.customData.yposEndStep1, alpha:1 } );
				s.scale(Story.SCALE_SMALL);
				
			}
			
		//	eaze(this).delay(2).onComplete();
			showCustomButton( { hl:"Weiter", onClick:startStep2 } );
			_curHelpTask = 2;
		}
		
		
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////// STEP 2
		///////////////////////////////////////////////////////////////////////////////////////////////
		private function ____________________________step2__________________________():void {}
		
		
		
		private function startStep2(e:MouseEvent=null):void 
		{
			_curHelpTask = 3;
			if (_btnCustom != null) _btnCustom.hide();
			
			if (_btnCont) eaze(_btnCont).to(.3, { alpha:0 } );
			
			showTaskBox(_xml.set[0].task[2]);
			
			_stories = ArrayUtils.shuffle(_stories);
			
			var i:int = 0;
			for each (var s:Story in _stories) {
				
				s.done = false;
				s.scale(Story.SCALE_TINY, .5, false);
				s.customData.tmpy = 220 + i * 30 
				s.customData.tmpx = 920 - i * 15;
				eaze(s).to(.5, { x:s.customData.tmpx, y: s.customData.tmpy } );
				
				i++;
				s.addEventListener(MouseEvent.MOUSE_DOWN, onStoryMouseDown);
				//s.addEventListener(MouseEvent.MOUSE_OVER, onStoryMouseOver);
				s.buttonMode = true;
				s.parent.addChild(s);
				s.filters = [new DropShadowFilter(2, 45, 0, 1, 4, 4, .4, 3)];
			}
			
			_bgStep2 = new Step2Background();
			_cont.addChild(_bgStep2);

		}
		
		
		
		
		
		/*
		private function onStoryMouseOver(e:MouseEvent):void 
		{
			var storyFound:Boolean = false;
			var yp:int = 120;
			for each (var s:Story in _stories) {
				if (s == e.currentTarget) {
					
					eaze(s).to(.5, { y:yp});
					yp += 180;
					s.parent.addChild(s);
				} else {
					eaze(s).to(.5, { y:yp});
					yp += 50;
				}
				
			}
		}*/
		
		private function onStoryMouseDown(e:MouseEvent):void 
		{
			trace("onStoryMouseDown");
			_curStory = e.currentTarget as Story;
			_curStory.showTf(Story.SCALE_TINY, true);
			_curStory.parent.addChild(_curStory);
			_mouseDownPoint = new Point(mouseX-_curStory.x, mouseY-_curStory.y);
			addEventListener(Event.ENTER_FRAME, onDragStoryEF);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onDragMouseUp);
		}
		
		private function onDragMouseUp(e:MouseEvent):void 
		{
			if (_helpMode && e != null) return;
			
			var endStep2delay:Number = 1;
			
			trace("onDragMouseUp");
			if (_curStory != null) {
				_errorStory = _curStory;
			
				var yFormalInformal:Number = S2BOX_Y + S2BOX_HEIGHT * 2 + S2BOX_PADDING1 + S2BOX_PADDING2 / 2; // grenze zwischen formell und informell
				
				removeEventListener(Event.ENTER_FRAME, onDragStoryEF);
				trace("_curStory.y", _curStory.y);
				if (_curStory.x < S2BOX_X+S2BOX_WIDTH) {
					if (_curStory.y < yFormalInformal) { ////////////////////////////// INFORMELL		
						
						if (!_curStory.isFormal) {
							
							_curStory.removeEventListener(MouseEvent.MOUSE_DOWN, onStoryMouseDown);
							_curStory.buttonMode = false;
							_curStory.done = true;
							
							if (_curStory.y < yFormalInformal - S2BOX_PADDING2 / 2 - S2BOX_HEIGHT - S2BOX_PADDING1 / 2) { //// SINGULAR
							
								if (_curStory.isSingular) {
									moveStoryToRightBox(_curStory);
									_popIcon.show(PopIcon.RIGHT, this, MainBase.STAGE_WIDTH,MainBase.STAGE_HEIGHT- 200 );
								} else {  
									if (undoneStoriesNum() < 1) endStep2delay = 5;
									eaze(this).delay(0).onComplete(showError);
								}
							
							} else { //// PLURAL
								if (!_curStory.isSingular) {
									moveStoryToRightBox(_curStory);
									_popIcon.show(PopIcon.RIGHT, this, MainBase.STAGE_WIDTH,MainBase.STAGE_HEIGHT - 200 );
								} else {  
									if (undoneStoriesNum() < 1) endStep2delay = 5;
									eaze(this).delay(0).onComplete(showError);
								}
							}
							

						} else {
							_popIcon.show(PopIcon.WRONG, this, MainBase.STAGE_WIDTH,MainBase.STAGE_HEIGHT - 200 );
							returnStory(_curStory);
						}
						
					} else { // ////////////////////////////// FORMELL

						if (_curStory.isFormal) {
							
							_curStory.removeEventListener(MouseEvent.MOUSE_DOWN, onStoryMouseDown);
							_curStory.buttonMode = false;
							_curStory.done = true;
							
							if (_curStory.y < yFormalInformal + S2BOX_PADDING2 / 2 + S2BOX_HEIGHT + S2BOX_PADDING1 / 2) { //// SINGULAR
							
								if (_curStory.isSingular) {
									_popIcon.show(PopIcon.RIGHT, this, MainBase.STAGE_WIDTH, MainBase.STAGE_HEIGHT - 200 );
									moveStoryToRightBox(_curStory);
								} else {  
									if (undoneStoriesNum() < 1) endStep2delay = 5;
									eaze(this).delay(0).onComplete(showError);
								}
								
							} else {  // PLURAL
								
								if (!_curStory.isSingular) {
									_popIcon.show(PopIcon.RIGHT, this, MainBase.STAGE_WIDTH,MainBase.STAGE_HEIGHT - 200 );
									moveStoryToRightBox(_curStory);
								} else {  
									if (undoneStoriesNum() < 1) endStep2delay = 5;
									eaze(this).delay(0).onComplete(showError);
								}
							}
							
						} else {
							_popIcon.show(PopIcon.WRONG, this, MainBase.STAGE_WIDTH, MainBase.STAGE_HEIGHT - 200 );
							returnStory(_curStory);
						}
						
					}
					
				} else { // nicht über einer box -> einfach zurück
					
					
					returnStory(_curStory);
				}
			}
			
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onDragMouseUp);
			
			if (undoneStoriesNum() < 1) {
				eaze(_cont).delay(endStep2delay).onComplete(endStep2);
			}
			
		}
		
		private function showError():void //(txt:String):void 
		{
			trace(">>>>>>>>>>>>>>>>>>>>>>>>> SHOW ERROR!!");
			_tooltip.setPos(_errorStory.x, _errorStory.y+40);
			_tooltip.show( _errorStory.xml.error, 4);
			eaze(this).delay(4.1).onComplete(moveStoryToRightBox, _errorStory);
			
			for each(var s:Story in _stories) { // deaktiviern während Fehler gezeigt wird
				s.mouseChildren = s.mouseEnabled = false;
			}
		}
		
		private function moveStoryToRightBox(s:Story):void {
			var yp:Number = S2BOX_Y
			
			
			
			if (!s.isFormal) {
				if (s.isSingular) {
					yp +=  8
					if (_storiesInBoxes[0].length > 0) {
						yp += 55;
					}
					_storiesInBoxes[0].push(s);
				} else {
					yp += S2BOX_HEIGHT + S2BOX_PADDING1 + 8
					if (_storiesInBoxes[1].length > 0) {
						yp += 55;
					}
					_storiesInBoxes[1].push(s);
				}
				
			} else {
				yp += S2BOX_HEIGHT*2+S2BOX_PADDING1+S2BOX_PADDING2 
				if (s.isSingular) {
					yp += 8
					if (_storiesInBoxes[2].length > 0) {
						yp += 55;
					}
					_storiesInBoxes[2].push(s);
				} else {
					yp += S2BOX_HEIGHT + S2BOX_PADDING1 + 8
					if (_storiesInBoxes[3].length > 0) {
						yp += 55;
					}
					_storiesInBoxes[3].push(s);
				}
				
			}
			s.scale(Story.SCALE_WIDE);
			yp += s.nextHeight / 2;
			//trace("x: S2BOX_X + s.nextWidth/2+ 20", S2BOX_X + s.nextWidth / 2 + 20);
			eaze(s).to(.5, { y:yp, x: 120 + s.nextWidth/2 } );
			_curStory = null
			
			for each(var s:Story in _stories) { // wieder aktiviern nachdem Fehler gezeigt wurde
				s.mouseChildren = s.mouseEnabled = true;
			}
			
		}
		
		
		private function getStoryRightBoxPosition(s:Story):Point {
			var pos:Point = new Point();
			var yp:Number = S2BOX_Y
			
			if (!s.isFormal) {
				if (s.isSingular) {
					yp +=  30
				} else {
					yp += S2BOX_HEIGHT + S2BOX_PADDING1 + 30
				}
				
			} else {
				yp += S2BOX_HEIGHT*2+S2BOX_PADDING1+S2BOX_PADDING2 
				if (s.isSingular) {
					yp += 30
					
				} else {
					yp += S2BOX_HEIGHT + S2BOX_PADDING1 + 30
				}
				
			}
			
			pos.y = yp;
			pos.x = 260
			return pos;
		}
		
		
		
		private function returnStory(s:Story):void {
			s.hideTf();
			eaze(s).to(.5, { x:s.customData.tmpx , y:  s.customData.tmpy  } ).onComplete(function():void {
				for each(var st:Story in _stories) {
					st.parent.addChild(st);
				}
			});
			
		}
		
		private function onDragStoryEF(e:Event):void 
		{
			//trace("onDragStoryEF");
			_curStory.x = mouseX - _mouseDownPoint.x;
			_curStory.y = mouseY- _mouseDownPoint.y
		}
		
		private function endStep2():void {
			
			for each (var s:Story in _stories) {
				eaze(s).delay(1).to(.5, { alpha:0 } );
			}
			eaze(_bgStep2).delay(1).to(.5, { alpha:0 } );
			
			eaze(this).delay(1).onComplete(startStep3);
			
			
		}
		
		
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////// STEP 3
		///////////////////////////////////////////////////////////////////////////////////////////////
		private function ____________________________step3__________________________():void { }
		
		
		private function startStep3(e:MouseEvent = null):void  {
			
			_curHelpTask = 4
			showTaskBox(_xml.set[0].task[3]);
			
			trace("startStep3");
			var i:int = 0;
			var yposes:Array = [S2BOX_Y + 8, 
								S2BOX_Y + 8 + 55, 
								S2BOX_Y + S2BOX_HEIGHT + S2BOX_PADDING1 + 8, 
								S2BOX_Y + S2BOX_HEIGHT + S2BOX_PADDING1 + 8 + 55,
								S2BOX_Y + S2BOX_HEIGHT * 2 + S2BOX_PADDING1 + S2BOX_PADDING2 + 8, 
								S2BOX_Y + S2BOX_HEIGHT*3 + S2BOX_PADDING1*2+S2BOX_PADDING2 + 8];
								
			for each(var sx:XML in _xml.set[0].sentence) {
				
				var ty:int = yposes[i];
				var sentCont:SentenceContainer = new SentenceContainer(500, 380, ty +5);
				sentCont.addEventListener(SentenceElement.ELEM_MOUSE_DOWN, onSentenceElementMouseDown);
				_cont.addChild(sentCont);
				var sent:Sentence = new Sentence(sx);
				for each(var se:SentenceElement in sent.elems) {
					se.colorUnHighlight = GoetheColors.LIGHT_BLUE;
					se.alphaUnHighlight = 1;
					se.unhighlight(0);
					se.colorHighlight = GoetheColors.LIGHT_BLUE_DARKER;
				}
				sent.id = i;
				sent.customData.done = false;
				sentCont.addSentence(sent, { setPosInstantly:true } )//addChild(sent);
				_sentConts.push(sentCont);
				// Container für die rausgezogenen Teile anlegen
				var tCont:Sprite = new Sprite();
				var tbox:Sprite = new Sprite();
				tbox.graphics.beginFill(GoetheColors.GREY_30);
				tbox.graphics.drawRoundRect(180, ty, 150, 40, 20, 20);
				tCont.addChild(tbox);
				_imperativeConts.push(tCont);
				_cont.addChild(tCont);
				
				eaze(sentCont).apply( { alpha:0 } ).delay(1).to(.5, { alpha:1 } );
				eaze(tCont).apply( { alpha:0 } ).delay(1).to(.5, { alpha:1 } );
				
				i++;
			}
			
		}
		
		/**
		 * 
		 * @param	e
		 * @param	dragElem das hier nur relevant fpr die Hilfe-Demo
		 */
		private function onSentenceElementMouseDown(e:CustomEvent= null, clickedElem:SentenceElement=null):void //, dragElem:SentenceElement = null):void 
		{
			if (e != null) {
				_helpMode =  false;
				clickedElem =  e.param.elem;
				//clickedElem.highlightCustom(GoetheColors.LIGHT_BLUE, .5);
				
				_mouseDownPoint = new Point(e.param.localX, e.param.localY);
			} else {
				_helpMode = true;
				clickedElem = clickedElem ;
				_mouseDownPoint = new Point(clickedElem.width/2, clickedElem.height/2);
			}
			
			if (clickedElem.type == "verb") {
			//	if (_dragElem != null && contains(_dragElem)) removeChild(_dragElem);
				eaze(clickedElem).to(.3, { alpha:.5 } );
				_dragElem = clickedElem.clone()
				_dragElem.x = clickedElem.x;
				_dragElem.y = clickedElem.y;
				addChild(_dragElem);
				// partner ermittelm
				//if (_dragElemPartner != null && contains(_dragElemPartner)) removeChild(_dragElemPartner);
				_dragElemPartner = null;
				for each(var se:SentenceElement in clickedElem.sentence.elems) {
					if (se != clickedElem && se.type == "verb") {
						_dragElemPartner = se.clone();
						_dragElemPartner.x = se.x;
						_dragElemPartner.y = se.y;
						addChild(_dragElemPartner);
						eaze(se).to(.3, { alpha:.5 } );
					}
				}
				
				
				_stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
				_stage.addEventListener(Event.ENTER_FRAME, onDragEnterFrame);
				
			} else {
				
				_popIcon.show(PopIcon.WRONG, this, MainBase.STAGE_WIDTH, MainBase.STAGE_HEIGHT - 200 );
				
			}
			//trace("onSentenceElementMouseDown", _dragElem)
			
			
			
			
		}
		
		private function onStageMouseUp(e:MouseEvent=null):void 
		{
			if (_helpMode && e != null) return;
			
			if (_dragElem.x < 300) { 
				var x1:Number = 190;
				var x2:Number ;
				if (_dragElemPartner) {
					if (_dragElem.id < _dragElemPartner.id) {
						x2 = x1 + _dragElem.width;
					} else {
						x2 = x1;
						x1 = x2 + _dragElemPartner.width;
					}
				}
				
				eaze(_dragElem).to(.5, { x: x1,  y:_dragElem.sentence.elems[0].y } );
				_imperativeConts[_dragElem.sentence.id].addChild(_dragElem);
				
				if (_dragElemPartner) {
					eaze(_dragElemPartner).to(.5, { x: x2,  y:_dragElem.sentence.elems[0].y } );
					_dragElemPartner.removeInteractivity();
					_imperativeConts[_dragElem.sentence.id].addChild(_dragElemPartner);
				}
				
				_dragElem.sentence.removeInteractivity();
				_dragElem.removeInteractivity();
				
				_dragElem.sentence.customData.done = true;
				
				_imperativesFound ++;
				_dragElem.unhighlight();
				
			
			} else { // zurück
				//_stage.addEventListener(Event.ENTER_FRAME, onDragRollOut);
			
				eaze(_dragElem).to(.3, { alpha:0 } ).onComplete(function():void {
						if (_dragElem != null && contains(_dragElem)) removeChild(_dragElem);
					});
				if (_dragElemPartner) {
					eaze(_dragElemPartner).to(.3, { alpha:0 } ).onComplete(function():void {
						if (_dragElemPartner != null && contains(_dragElemPartner)) removeChild(_dragElemPartner);
					});
				}
				// alpha wieder 1
				for each(var se:SentenceElement in _dragElem.sentence.elems) {
					if (se.alpha < 1) eaze(se).to(.3, { alpha:1 } );
					
				}
			}

			
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			_stage.removeEventListener(Event.ENTER_FRAME, onDragEnterFrame);
			
			//trace("_imperativesFound", _imperativesFound, _xml.set[0].sentence.length());
			if (_imperativesFound >= _xml.set[0].sentence.length()) {
				
				endStep3();
			}
		}
		
		
		
		private function onDragEnterFrame(e:Event=null):void 
		{
			if (_helpMode) {
				_dragElem.x = _handCursor.x - _mouseDownPoint.x;
				_dragElem.y = _handCursor.y - _mouseDownPoint.y;
			} else {
				_dragElem.x = mouseX - _mouseDownPoint.x;
				_dragElem.y = mouseY - _mouseDownPoint.y;
			}
			
			if (_dragElemPartner != null) {
				var tarX:Number = _dragElem.id < _dragElemPartner.id ? _dragElem.x + _dragElem.width : _dragElem.x - _dragElemPartner.width;
				_dragElemPartner.x += ( tarX - _dragElemPartner.x) / 3;
				_dragElemPartner.y += (_dragElem.y - _dragElemPartner.y ) / 3;
			}
			
			//_dragElem.pullSiblingElements(); // 
		}
		
		
		private function endStep3():void 
		{
			_currentTask = _xml.set[0].task[4];
			
			for each(var c:Sprite in _sentConts) {
				
				eaze(c).to(.5, { alpha: 0 } );
				
			}
			
			var i:int = 0;
			for each(var bx:XML in _xml.set[0].imperativeBox) {
				var box:ImperativeMenuBox = new ImperativeMenuBox(bx);
				box.x = 500;
				box.y = 100 + i * 160;
				addChild(box);
				eaze(box).apply( { alpha:0 } ).delay(1).to(.5, { alpha:1 } );
				i++;
				
			}
			
			i = 0;
			var yposes:Array = [40, 40, 70, 70, 70, -5];
			for each(var cont:Sprite in _imperativeConts) {
				eaze(cont).to(.5, { x: 130, y:yposes[i]});
				
				i++;
			}
			
			for (i = 0; i < 3; i++) {
				var klammer:Klammer = new Klammer();
				klammer.x = 460;
				klammer.y = 82 + i * 160;
				_cont.addChild(klammer);
			}
			
			eaze(this).delay(2).onComplete(showNextButton);
			
			_curHelpTask = 5;
			
		}
		
	
	
		private function ____________________________rest__________________________():void {}
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////// HELP BUTTON
		///////////////////////////////////////////////////////////////////////////////////////////////
		
		override protected function onHelpButtonClick(e:MouseEvent):void 
		{
			
			trace("_curHelpTask", _curHelpTask);
			
			switch(_curHelpTask) {
				
				case 0: // story anklicken
					var tarStory:Story
					for each (var s:Story in _stories) {
						if (!s.done) tarStory = s;
					}
					//tarStory.alpha  = .4
					
					trace("tarStory.x", tarStory.x, tarStory.y);
					
					deactivateHelpButton();
					_helpOverlay.show(this);
					addChild(_handCursor);
					_handCursor.x = _btnHelp.x- 40
					_handCursor.y = _btnHelp.y + 10;
					_handCursor.show();
					eaze(_handCursor).to(1, { x:tarStory.x, y:tarStory.y} ).easing(Cubic.easeInOut).onComplete(function():void {
						_handCursor.click();
						onStoryClick(null, tarStory);
					}).delay(.5).onComplete(function():void {   _handCursor.hide(); _helpOverlay.hide(); } );
					
					
					break;
					
				case 1:  // Tipp , Aufforderung oder Bitte - button anklicken
					
					var btnToClick:TextButton;
					if (_curStory.type == 0) btnToClick = _btn1;
					else if (_curStory.type == 1) btnToClick = _btn2;
					else if (_curStory.type == 2) btnToClick = _btn3;
					_helpOverlay.show(this);
					addChild(_handCursor);
					_handCursor.x = _btnHelp.x- 40
					_handCursor.y = _btnHelp.y + 10;
					_handCursor.show();
					
					eaze(_handCursor).to(1, { x:btnToClick.x+btnToClick.width/2, y:_btnCont.y+btnToClick.y+btnToClick.height/2} ).easing(Cubic.easeInOut).onComplete(function():void {
						_handCursor.click();
						onBtnClick(null, btnToClick);
					}).delay(.5).onComplete(function():void {   _handCursor.hide(); _helpOverlay.hide(); });
					
					
					break;
				
				case 2: // weiter button klicken
					_helpOverlay.show(this);
					addChild(_handCursor);
					_handCursor.x = _btnHelp.x- 40
					_handCursor.y = _btnHelp.y + 10;
					_handCursor.show();
					eaze(_handCursor).to(1, { x:_btnCustom.x+_btnCustom.width/2, y:_btnCustom.y+_btnCustom.height/2 } ).easing(Cubic.easeInOut).onComplete(function():void {
						_btnCustom.onOver()
					}).delay(.5).onComplete(function():void {
						_handCursor.click();
						_onCustomBtnClick()
					}).delay(.5).onComplete(function():void {   _handCursor.hide(); _helpOverlay.hide(); });
					
					break;
				
				case 3:// story auf passenden container ziehen
					_helpOverlay.show(this);
					addChild(_handCursor);
					_handCursor.x = _btnHelp.x- 40
					_handCursor.y = _btnHelp.y + 10;
					_handCursor.show();
					
					//var tarStory:Story
					for each ( s in _stories) {
						if (!s.done) tarStory = s;
					}
					var boxPos:Point = getStoryRightBoxPosition(tarStory);
					
					eaze(_handCursor).to(1, { x:tarStory.x, y:tarStory.y} ).easing(Cubic.easeInOut).onComplete(function():void {
						_handCursor.click();
						_curStory = tarStory;
						_curStory.parent.addChild(_curStory);
						
					}).delay(.5).onComplete(function():void {
						eaze(tarStory).to(1, {x:boxPos.x, y:boxPos.y}).easing(Cubic.easeInOut);
					}).to(1, { x:boxPos.x, y:boxPos.y} ).easing(Cubic.easeInOut).onComplete(function():void {
						onDragMouseUp(null);
						
					}).delay(.5).onComplete(function():void {   _handCursor.hide(); _helpOverlay.hide(); });
					
					break;
					
				case 4:// verben aus den sätzen ziehen
					_helpOverlay.show(this);
					addChild(_handCursor);
					_handCursor.x = _btnHelp.x- 40
					_handCursor.y = _btnHelp.y + 10;
					_handCursor.show();
					
					var elToDrag:SentenceElement;
					for (var i:int = 0 ; i < _sentConts.length; i ++) {
						var sent:Sentence = ((_sentConts[i] as SentenceContainer).sentences[0] as Sentence);
						if (!sent.customData.done) {
							elToDrag = sent.elems[0];
							break;
						}
						
					}
					
					
					eaze(_handCursor).to(1, { x:elToDrag.x+elToDrag.width/2, y:elToDrag.y+elToDrag.height/2} ).easing(Cubic.easeInOut).onComplete(function():void {
						_handCursor.click();
						elToDrag.onOver();
						onSentenceElementMouseDown(null, elToDrag);
						
					}).delay(.5).onComplete(elToDrag.onOut).to(1, { x:240} ).easing(Cubic.easeInOut).onComplete(function():void {
						onStageMouseUp(null);
						
					}).delay(.5).onComplete(function():void {   _handCursor.hide(); _helpOverlay.hide(); });
					
					break;
					
				case 5: // weiter button klicken
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
					}).delay(.5).onComplete(function():void {   _handCursor.hide(); _helpOverlay.hide(); });
					
					break;
				
				
				
				
				
				
			}
			/*

			switch(
			if (!_task1Done) {
				_btnHelp.removeEventListener(MouseEvent.CLICK, onHelpButtonClick);
				addChild(_handCursor);
				_handCursor.x = _btnHelp.x- 40
				_handCursor.y = _btnHelp.y + 10;
				_handCursor.show();
				
				var targetCont:Sprite = _ballContainers[_curTargetContId];
				_dragBall = _verbBall1;
				
				var pos:Point =  new Point(_dragBall.x , _dragBall.y ); 
				eaze(_handCursor).to(1, { x:pos.x, y:pos.y } ).easing(Cubic.easeInOut).onComplete(function():void {
					_dragBall.onOver();
				}).delay(.5).onComplete(function():void {
					_handCursor.click();
					eaze(_dragBall).to(1.5, { x:targetCont.x+targetCont.width/2, y:targetCont.y+targetCont.height/3} ).onUpdate(onHelpDrag);
					//onSentenceElementMouseDown(null, _dragElem);
				}).to(1.5,  { x:targetCont.x + targetCont.width / 2, y:targetCont.y + targetCont.height / 3 }  ).onComplete(function():void {
					_dragBall.onOut();
					onBallMouseUp();
				}).delay(1.5).onComplete(function():void { activateHelpButton(); _handCursor.hide() } );
			}
			*/
		}
		/*
		
		private function onHelpDrag():void 
		{
			var speedFactor:Number = 3;
			
		//	if (_dragBall == _verbBall1) {
				_verbBall2.x += (_verbBall1.x+BALL_RADIUS*2 -_verbBall2.x ) / speedFactor
				_verbBall2.y += (_verbBall1.y -_verbBall2.y ) / speedFactor
		//	} 
			
		}
		
		*/
	
		
	
		
	}

}