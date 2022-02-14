package  
{
	import aze.motion.eaze;
	import base.swf.SwfLoader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author 
	 */
	public class AniTest  extends Sprite
	{
		
		public function AniTest() 
		{
				var swfLoader:SwfLoader = new SwfLoader("data/animations/6a.swf", onSwfLoaded);
		}
		
		
		private function onSwfLoaded(swf:MovieClip):void 
		{
			addChild(swf);
			
			
			eaze(this).delay(1.5).onComplete(play);
		}
		
		public function play():void 
		{
			var swf:MovieClip = MovieClip(getChildAt(0))
			trace(swf.totalFrames);
		//	swf.gotoAndStop(1);
			swf.gotoAndPlay(1);
			eaze(this).delay(1.5).onComplete(play);
			trace("SSSS");
		}
		
	}

}