package modules03.mod0302 
{
	import aze.motion.eaze;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import goethe.GoetheColors;
	/**
	 * ...
	 * @author 
	 */
	public class BackBtn extends Sprite
	{
		
		private var _box:Sprite;
		
		public function BackBtn() 
		{
			buttonMode = true;
			
			_box = new Sprite(),
			_box.graphics.beginFill(GoetheColors.GREY_30);
			_box.graphics.drawRoundRect(0, 0, 240, 46, 20,20);
			addChild(_box);
			
			var icon:IconBack = new IconBack();
			icon.scaleX = icon.scaleY = .4;
			addChild(icon);
			icon.x = 202;
			icon.y = 7;
			
		//	eaze(icon).apply( { tint:0xff0000 } );
		
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
			
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