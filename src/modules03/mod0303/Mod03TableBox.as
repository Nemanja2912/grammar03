package modules03.mod0303 
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
	public class Mod03TableBox extends Sprite
	{
		public var id:int = -1
		private var _tf:BasicText;
		public var customData:Object = { };
		protected var _glowColor:uint = GoetheColors.GREY
		private var _box:Sprite = new Sprite();
		
		public function Mod03TableBox(text:String) 
		{
			addChild(_box);
			drawBox();
			
			_tf = new BasicText( { text:text } );
			_tf.mouseChildren = _tf.mouseEnabled = false;
			_tf.y = 9;
			_tf.x = (width-_tf.width)/2
			addChild(_tf);
			
			addEventListener(MouseEvent.MOUSE_OVER, onOver);  
			addEventListener(MouseEvent.MOUSE_OUT, onOut);	
			
			onOut(null, 0);
			
			
		}
		
		public function drawBox(col:uint = GoetheColors.LIGHT_BLUE):void 
		{
			_box.graphics.beginFill(col);
			_box.graphics.drawRect(0, 0, Mod03Table.COL_WIDTH, 50);
		}
		
	
	
	
		
		protected function onOver(e:MouseEvent):void {
			eaze(_box).to(.25, { glowFilter: { color:_glowColor, strength:1.8 } } );
			//eaze(_circle).to( .25, { scaleX:1.1, scaleY:1.1, alpha:.9 } );
			//eaze(_icon).to( .25, { tint:_colorOver } );
			
			//eaze(_icon).to( .25, {alpha:.9});
		}
		
		protected function onOut(e:MouseEvent, dur:Number = .25):void {
			eaze(_box).to(dur, { glowFilter: { color:_glowColor,  strength:1, blurX:10, blurY:10, quality:3, alpha:.8 } })//.onComplete(pulsate);
			//new GlowFilter(
			//new DropShadowFilter(
			//eaze(_circle).to( dur, { scaleX:1, scaleY:1, alpha:.75 } );
			//eaze(_icon).to( dur, {tint:null});

		}
		

		
		public function removeInteractivity():void 
		{
			removeEventListener(MouseEvent.MOUSE_OVER, onOver);  
			removeEventListener(MouseEvent.MOUSE_OUT, onOut);	
			
			//_box.filters = [];
			eaze(_box).to(.1, { glowFilter: { color:_glowColor,  strength:0, blurX:0, blurY:0} })
		}
		
	}

}