package modules03.mod0304 
{
	import aze.motion.eaze;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author 
	 */
	public class Mod04TableTask extends Sprite
	{
		
		
		private var _row1:Mod04TableRowPresent;
		private var _row2:Mod04TableRowImperative;
		private var _id:int;
		private var _xml:XML;
		private var _presentDone:Boolean = false;
		private var _imperativeDone:Boolean = false;
		private var _imperativeComplete:Boolean = false;
		private var _allDone:Boolean = false;
		//private var _rowsDone:int = 0;
		
		public function Mod04TableTask(xml:XML, id_:int) 
		{
			
			//graphics.beginFill(0xff0000)
			//graphics.drawCircle(0, 0, 20);
			_xml = xml;
			_id = id_;
			
			_row1 = new Mod04TableRowPresent(xml.present[0]);
			_row1.addEventListener(Mod04TableRowPresent.PRESENT_DONE, onPresentDone, false, 0, true);
			addChild(_row1);
			
			//onPresentDone(null)
			
		}
		
		private function onPresentDone(e:Event):void 
		{
			//_rowsDone++;
			_row2 = new  Mod04TableRowImperative(_xml.imperative[0], _id);
			_row2.addEventListener(Mod04TableRowImperative.IMPERATIVE_DONE, onImperativeDone, false, 0, true);
			_row2.addEventListener(Mod04TableRowImperative.IMPERATIVE_ROW_COMPLETE, onImperativeComplete, false, 0, true);
			//_row2.id = _id;
			eaze(this).delay(.01).onComplete(_row2.activateFocus);
			//_row2.activateFocus()
			_row2.y = Mod04TableRowPresentElement.HEIGHT;
			addChild(_row2);
			
			_presentDone = true;
		}
		
		private function onImperativeComplete(e:Event):void 
		{
			_imperativeComplete = true;
		}
		
		private function onImperativeDone(e:Event):void 
		{
			_imperativeDone = true;
		}

		public function activateFocus():void {
			
			if (_row2 != null && contains(_row2)) _row2.activateFocus();
			else _row1.activateFocus();
		}
		
		public function deactivateFocus():void 
		{
			if (_row2 != null) _row2.deactivateFocus();
			_row1.deactivateFocus();
		}
		
		public function setDone():void 
		{
			_allDone = true;
		}
		
		public function setImgContVisible(boolean:Boolean):void 
		{
			if (_row2)_row2.setImgContVisible(boolean);
		}
		
		
		
		
		
		
		public function get id():int 
		{
			return _id;
		}
		
		public function get presentDone():Boolean 
		{
			return _presentDone;
		}
		
		public function get imperativeDone():Boolean 
		{
			return _imperativeDone;
		}
		
		public function get allDone():Boolean 
		{
			return _allDone;
		}
		
		public function get presentRow():Mod04TableRowPresent 
		{
			return _row1;
		}
		
		public function get imperativeRow():Mod04TableRowImperative 
		{
			return _row2;
		}
		
		public function get imperativeComplete():Boolean 
		{
			return _imperativeComplete;
		}
		

		
		
		
		
	}

}