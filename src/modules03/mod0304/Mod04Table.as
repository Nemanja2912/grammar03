package modules03.mod0304 
{
	import aze.motion.eaze;
	import base.events.CustomEvent;
	import base.text.BasicText;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import goethe.GoetheColors;
	import gui.buttons.TextButton;
	import gui.input.specialKeyboard.MobileKeyboard;
	import modules.Module;
	import utils.GoetheUtils;
	/**
	 * ...
	 * @author 
	 */
	public class Mod04Table extends Sprite
	{
		
		private var _bg:Sprite = new Sprite();
		private var _riders:Vector.<Mod04Rider> = new Vector.<Mod04Rider>()
		private var _tableTasks:Vector.<Mod04TableTask>
		private var _tasksComplete:int = 0;
		private var _mod:Module;
		private var _curId:int = -1;
		
		public static const FIRST_COL_WIDTH:int = 160;
		static public const ALL_COMPLETE:String = "allCompleteTable04";
	//	public static const COL_WIDTH:int = 160;
		
		public function Mod04Table(xml:XML, mod:Module) 
		{
			_mod = mod;
			
			_bg.graphics.beginFill(GoetheColors.LIGHT_BLUE);
			_bg.graphics.drawRect(0, 0, 159, Mod04Rider.HEIGHT - 1);
			addChild(_bg);
			
			var tf:BasicText = new BasicText( { text: "Infinitiv <br/>auswählen", multiline:true, width:130, fontSize:16, textAlign:"center", fontColor:0xffffff } );
			tf.x = 10;
			tf.y = 7;
			addChild(tf);
			
			var i:int = 0;
			for each (var vx:XML in xml.verb) {
				
				var rider:Mod04Rider = new Mod04Rider(vx.infinitive[0], i);
				rider.addEventListener(MouseEvent.CLICK, onRiderClick);
				rider.x = FIRST_COL_WIDTH + i * Mod04Rider.WIDTH;
				addChild(rider);
				_riders.push(rider);
				
				i++;
			}
			
			//
			var xp:int = 80;
			i = 0;
			_tableTasks = new Vector.<Mod04TableTask>();
			for each ( vx in xml.verb) {
				var tt:Mod04TableTask = new Mod04TableTask(vx, i);
				tt.y = Mod04Rider.HEIGHT
				
				tt.addEventListener(Mod04TableRowImperative.IMPERATIVE_ROW_COMPLETE, onTaskComplete);
				addChild(tt); 
				_tableTasks.push(tt);
				tt.visible = false;
				i++;
			}
			
		}
		
		private function onTaskComplete(e:CustomEvent):void 
		{
			_riders[e.param.id].setDone();
			 _tableTasks[_curId].setDone();
			_tasksComplete ++;
			
			trace("onTaskComplete", _tasksComplete, _tableTasks.length);
			if (_tasksComplete >= _tableTasks.length) {
				dispatchEvent(new Event(ALL_COMPLETE));
			}
		}
		
		private function onRiderClick(e:MouseEvent=null, rider:Mod04Rider = null):void 
		{
			dispatchEvent(new CustomEvent(MobileKeyboard.HIDE_KEYS, true));
			
			
			
			eaze(_bg).apply( { tint:GoetheColors.GREY_75 } );
			
			var clickedRider:Mod04Rider
			if (rider != null) {
				clickedRider = rider;
			} else {
				clickedRider = e.currentTarget as Mod04Rider;
			}
			
			_curId = clickedRider.id;
			
			for each(var r:Mod04Rider in _riders) {
				if (r == clickedRider) r.highlight();
				else r.unhighlight();
			}
			
			for each(var tt:Mod04TableTask in _tableTasks) {
			//	trace("tt.id == clickedRider.id", tt.id , clickedRider.id);
				if (tt.id == clickedRider.id) {
					tt.setImgContVisible(true);
					tt.visible = true;
					tt.activateFocus();
					
				} else {
					tt.setImgContVisible(false);
					tt.visible = false;
					tt.deactivateFocus();
				}
				
			}
		}
		
		public function help():void {
			
			trace("help");
			var curTask:Mod04TableTask 
			var pos1:Point
			
			if (_curId != -1) curTask = _tableTasks[_curId];
			
			if (curTask) {
				trace("curTask", curTask, _curId);
				trace("curTask.allDone", curTask.allDone);
			}
			
			if (!curTask || curTask.allDone) {  // anderen Reiter wählen
				trace("1");
				var riderToClick:Mod04Rider
				for each(var tt:Mod04TableTask in _tableTasks) {
					if (!tt.allDone) riderToClick = _riders[tt.id];
				}
				if (riderToClick != null) {
					pos1 = new Point(this.x + riderToClick.x+riderToClick.width/2, this.y + riderToClick.y+riderToClick.height/2);
					_mod.onHelpStart();
					eaze(_mod.handCursor).to(.5, { x:pos1.x, y:pos1.y } ).onComplete(function():void {
						onRiderClick(null, riderToClick);
					}).delay(1).onComplete(_mod.onHelpComplete );
				}
					
			} else if (!curTask.presentDone) {
				trace("2");
				curTask.presentRow.help();

			} else if (!curTask.imperativeDone) {
				trace("3");
				curTask.imperativeRow.help();
				
			} else if (!curTask.imperativeComplete) {
				var btnToDrag:TextButton = curTask.imperativeRow.getBtnToDrag();
				var tpos:Point = GoetheUtils.getGlobalPos(btnToDrag)
				var tparent:Sprite = btnToDrag.parent.parent.parent.parent.parent as Sprite;
				btnToDrag.parent.removeChild(btnToDrag);
				btnToDrag.x = btnToDrag.basePos.x = tpos.x;
				btnToDrag.y = btnToDrag.basePos.y = tpos.y;
				tparent.addChild(btnToDrag);
				var gap:Sprite =  curTask.imperativeRow.boxToDragOn;
				// pos1 = new Point(this.x + curTask.x + curTask.imperativeRow.x + btnToDrag.x + btnToDrag.width / 2, this.y + curTask.y + curTask.imperativeRow.y + btnToDrag.y+ btnToDrag.height / 2);
				//var pos2:Point = new Point(this.x + curTask.x + curTask.imperativeRow.x + curTask.imperativeRow.boxToDragOnPos.x + gap.width / 2, this.y + curTask.y+curTask.imperativeRow.y + curTask.imperativeRow.boxToDragOnPos.y + gap.height / 2);
				pos1 = GoetheUtils.getGlobalPos(btnToDrag, true);
				var pos2:Point = GoetheUtils.getGlobalPos(gap, true);
				_mod.onHelpStart();
				eaze(_mod.handCursor).to(.5, { x:pos1.x, y:pos1.y } ).onComplete(function():void {
					_mod.handCursor.click();
					//btnToDrag.parent.addChild(btnToDrag);
					eaze(btnToDrag).to(1, {x:pos2.x-btnToDrag.width/2, y:pos2.y-btnToDrag.height/2 } );
				}).to(1, { x:pos2.x, y:pos2.y } ).onComplete(function():void {
					curTask.imperativeRow.onStageMU(null, btnToDrag);
					
				}).delay(.4).onComplete(_mod.onHelpComplete );
				
			}
			
			
		}
		
		
	}

}