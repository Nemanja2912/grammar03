package modules03.mod0303 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	/**
	 * ...
	 * @author 
	 */
	public class Rubber extends Sprite
	{
		
		private var _rubber:McRubber;
		private var _rubArea:Sprite = new Sprite()
		private var _doubleArrow:MovieClip;
		
		public function Rubber() 
		{
			_rubber = new McRubber();
			_doubleArrow = _rubber.mcDoubleArrow;
		
			buttonMode = true;
			
			
			
			addChild(_rubber);
			_rubber.filters = [new DropShadowFilter(4, 45, 0, .5, 8, 8, 1, 3)]
			
			_rubArea.graphics.beginFill(0xff0000, .0);
			_rubArea.graphics.drawRect(-5, -15, 20, 20);
			addChild(_rubArea);
			
		}
		
		public function get rubArea():Sprite 
		{
			return _rubArea;
		}
		
		public function get doubleArrow():MovieClip 
		{
			return _doubleArrow;
		}
		
	}

}