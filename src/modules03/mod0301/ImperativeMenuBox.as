package modules03.mod0301 
{
	import aze.motion.eaze;
	import base.text.BasicText;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import goethe.GoetheColors;
	/**
	 * ...
	 * @author 
	 */
	public class ImperativeMenuBox extends Sprite
	{
		public var id:int = -1;
		private var _box:Sprite;
		private var _tf:BasicText;
		private var _tfSide:BasicText;
		private var _boxColor:uint 
		
		public function ImperativeMenuBox(xml:XML, boxColor:uint = GoetheColors.GREEN) 
		{
			_boxColor = boxColor;
			
			
			_box = new Sprite();
			addChild(_box);
			drawBox();
			
			_tf = new BasicText( { text:xml.label, fontColor:0xffffff } );
			_tf.mouseChildren = _tf.mouseEnabled = false;
			_tf.x = 20;
			_tf.y = 45
			addChild(_tf);
			
			_tfSide = new BasicText( { text:xml.sideLabel, fontColor:0xffffff, fontWeight:"bold" } );
		//	_tfSide.width = _tfSide.textWidth + 4;
			_tfSide.mouseChildren = _tfSide.mouseEnabled = false;
			_tfSide.rotation = -90;
			_tfSide.x =200;
			_tfSide.y =  9 + _tfSide.width;
			addChild(_tfSide);
			
			eaze(_tfSide).to(0, { alpha:0 } );
			
			
		}
		
		private function drawBox():void 
		{
			_box.graphics.beginFill(_boxColor);
			_box.graphics.drawRoundRect(0, 0, 240, 120, 20, 20);
		}
		
		
		public function showSideText():void {
			
			eaze(_tfSide).to(.5, { alpha:1 } );
			eaze(_tf).to(.5, { alpha:0 } );
			
		}
		
		public function hideSideText():void {
			
			eaze(_tfSide).to(.5, { alpha:0 } );
			eaze(_tf).to(.5, { alpha:1 } );
			
		}
		
		public function addInteractivity():void {
			
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
			_box.buttonMode = true;
			onOut(null)
			
		}
		
		public function highlight():void 
		{
			eaze(_box).to(.25, { tint:null } );
		}
		
		public function unhighlight():void 
		{
			eaze(_box).to(.25, { tint:GoetheColors.GREY_30 } );
		}
		
		private function onOver(e:MouseEvent):void 
		{
			eaze(_box).to(.25, { glowFilter: { color: GoetheColors.GREY, strength:1.8 } } );
		}
		
		private function onOut(e:MouseEvent= null, dur:Number = .25):void 
		{
			eaze(_box).to(dur, { glowFilter: { color: GoetheColors.GREY,  strength:1, blurX:10, blurY:10, quality:3, alpha:.8 } })
		}
		
		public function set boxColor(value:uint):void 
		{
			_boxColor = value;
			drawBox();
		}
		
		//public function set 
		
	}

}