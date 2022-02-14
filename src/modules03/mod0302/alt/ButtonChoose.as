package modules.mod02 
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
	public class ButtonChoose extends Sprite
	{
		
		private var _box:Sprite;
		private var _tf:BasicText;
		
		public function ButtonChoose(txt:String) 
		{
			
		
			_tf = new BasicText( { text:txt , fontColor:0xffffff } );
			_tf.mouseChildren = _tf.mouseEnabled = false;
			
			//_tf.y = 10;
			
			_box = new Sprite();
			_box.graphics.beginFill(GoetheColors.GREY);
			_box.graphics.drawRoundRect(0, -5, 140, 40, 20,20);
			addChild(_box);
			
			addChild(_tf);
			
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
			_box.buttonMode = true;
			onOut(null)
			
			_tf.x = (_box.width - _tf.textWidth)/2
		}
		
		
		private function onOver(e:MouseEvent):void 
		{
			eaze(_box).to(.25, { glowFilter: { color: GoetheColors.GREY, strength:1.8 } } );
		}
		
		private function onOut(e:MouseEvent= null, dur:Number = .25):void 
		{
			eaze(_box).to(dur, { glowFilter: { color: GoetheColors.GREY,  strength:1, blurX:10, blurY:10, quality:3, alpha:.8 } })
		}
	}

}