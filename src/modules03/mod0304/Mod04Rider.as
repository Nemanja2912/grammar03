package modules03.mod0304 
{
	import aze.motion.eaze;
	import base.text.BasicText;
	import flash.display.Sprite;
	import goethe.GoetheColors;
	/**
	 * ...
	 * @author 
	 */
	public class Mod04Rider extends Sprite
	{
		private var _id:int;
		private var _box:Sprite;
		private var _tf:BasicText;
		private var _done:Boolean = false;
		
		public static const WIDTH:int = 130;
		public static const HEIGHT:int = 60;
		
		public function Mod04Rider(txt:String, id_:int) 
		{
			_id = id_;
			_tf = new BasicText( { 	text:txt	} );
			_tf.y = 14;
			_tf.x = (WIDTH - _tf.width) / 2;
			_tf.mouseChildren = _tf.mouseEnabled = false;
			addChild(_tf);
			
			_box = new Sprite();
			_box.graphics.beginFill(GoetheColors.GREY_30);
			_box.graphics.drawRect(0, 0, WIDTH - 1- (_id == 4 ? 2 : 0), HEIGHT - 1 );
			addChildAt(_box, 0);
			
			buttonMode = true;
			
		}
		
		
		public function highlight():void {
			trace("Rider highlight");
			if (!_done) eaze(_box).to(0, { tint:GoetheColors.LIGHT_BLUE } );	
		}
		
		public function unhighlight():void {
			if (!_done)eaze(_box).to(0, { tint:null } );	
		}
		
		public function setDone():void {
			
			_done = true;
			eaze(_box).to(0, { tint:GoetheColors.GREEN } );	
		}
		
		public function get id():int 
		{
			return _id;
		}
		
	}

}