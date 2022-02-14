package modules03.mod0304 
{
	import aze.motion.easing.Cubic;
	import aze.motion.eaze;
	import base.events.CustomEvent;
	import base.text.BasicText;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import goethe.GoetheColors;
	import gui.buttons.TextButton;
	import gui.frame.Frame;
	import gui.iconButtons.IconBtnHelp;
	import gui.popIcon.PopIcon;
	import lt.uza.utils.Global;

	import modules.Module;

	/**
	 * ...
	 * @author andreasmuench.de
	 */
	public class Mod0304 extends Module
	{
	
		private var _table:Mod04Table;
		private var _task1Shown:Boolean = false;
	
		
		public function Mod0304(xml:XML) 
		{
			super(xml);
			
			init();
			
		}
		
		private function init():void 
		{
			addHelpButton()
			addInfoButton();
			
			showTaskBox(_xml.set[3].task[0]);
			
			startTask();
		}
		

		override protected function startTask():void {
			
			_table = new Mod04Table(_xml.set[3], this);
			_table.addEventListener(PopIcon.EVENT_RIGHT, onPopiconEvent, false, 0, true)
			_table.addEventListener(PopIcon.EVENT_WRONG, onPopiconEvent, false, 0, true)
			_table.addEventListener(Mod04Table.ALL_COMPLETE, onAllComplete, false, 0, true)
			_table.addEventListener(Mod04TableRowImperative.IMPERATIVE_DONE, onImperativeDone, false, 0, true)
			_table.y = 40;
			_table.x = 108//(MainBase.STAGE_WIDTH - _table.width) / 2;
			
			//trace("_table.x", _table.x);
			_cont.addChild(_table);
		}
		
		private function onImperativeDone(e:Event):void 
		{
			if(!_task1Shown) showTaskBox(_xml.set[3].task[1]);
			_task1Shown = true;
			_table.removeEventListener(Mod04TableRowImperative.IMPERATIVE_DONE, onImperativeDone)
		}
		
		private function onAllComplete(e:Event):void 
		{
			trace("onAllComplete");
			showNextButton();
		}
		
		private function onPopiconEvent(e:Event):void 
		{
			var right_wrong:String = e.type == PopIcon.EVENT_RIGHT ? PopIcon.RIGHT : PopIcon.WRONG;
			_popIcon.show(right_wrong, this, MainBase.STAGE_WIDTH, MainBase.STAGE_HEIGHT - 200 );
		}
		
		
		override protected function onHelpButtonClick(e:MouseEvent):void 
		{
			
			_table.help();
			
			
			
		/*	var box:StoryDragOnBox = _dragOnBoxes[_stories.indexOf(story)];
				
			_btnHelp.removeEventListener(MouseEvent.CLICK, onHelpButtonClick);
			_helpOverlay.show(this);
			addChild(_handCursor);
			_handCursor.x = _btnHelp.x- 40
			_handCursor.y = _btnHelp.y + 10;
			_handCursor.show();
			
			//var pos:Point = new Point(story.x + story.width / 2, story.y + story.height / 2);
			var pos:Point = new Point(story.x , story.y );
			var pos2:Point = new Point(box.x + box.width / 2, box.y + box.height / 2);
			
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
			}).delay(1).onComplete(function():void { activateHelpButton(); _handCursor.hide(); _helpOverlay.hide(); _helpMode = false } );
					
		*/
		}
		
	}

}