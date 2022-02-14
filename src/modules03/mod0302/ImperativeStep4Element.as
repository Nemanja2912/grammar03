package modules03.mod0302 
{
	import aze.motion.eaze;
	import flash.display.Sprite;
	import goethe.GoetheColors;
	/**
	 * ...
	 * @author 
	 */
	public class ImperativeStep4Element extends Sprite
	{
		
		private var _feet4:Sprite = new Sprite();
		
		public function ImperativeStep4Element(xml:XML) 
		{
			
			
			var foot:Sprite = new McFoot();
			foot.scaleX = -1;
			_feet4.addChild(foot);
			_feet4.x = -10;
			_feet4.y = _foot1.y;
			foot = new McFoot();
			foot.x = 35;
			foot.y = -3
			_feet4.addChild(foot);
			eaze(_feet4).to(0, { tint:GoetheColors.GREY_30 } );
			addChild(_feet4);
			
		}
		
		public function highlight():void {
			
			
			
		}
		
	}

}