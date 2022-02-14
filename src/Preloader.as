package 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;

	
	/**
	 * ...
	 * @author asds
	 */
	public class Preloader extends MovieClip 
	{
		private var _bg:Sprite = new Sprite();
		private var _loadbarCont:Sprite = new Sprite();
		private var _bar:Sprite = new Sprite();
		
		public function Preloader() 
		{
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO show loader
			//_bg.graphics.beginFill(0x00ff00);
			//_bg.graphics.drawRect(0, 0, 1920, 1080);
			//addChild(_bg);
			
			_loadbarCont.graphics.beginFill(0xa0c814);
			_loadbarCont.graphics.drawRect(-4, -4, 208, 18);
			_loadbarCont.x = (stage.stageWidth - _loadbarCont.width) / 2
			_loadbarCont.y = 360;
			addChild(_loadbarCont);
			_loadbarCont.addChild(_bar);
			
			_bar.graphics.beginFill(0xffffff);
			_bar.graphics.drawRect(0, 0, 200, 10);
			_bar.scaleX = 0;
			
			
		}
		
		private function ioError(e:IOErrorEvent):void 
		{
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void 
		{
			// TODO update loader
			var perc:Number = e.bytesLoaded / e.bytesTotal;
			_bar.scaleX = perc;
			
		}
		
		private function checkFrame(e:Event):void 
		{
			
			trace("currentFrame, totalFrames", currentFrame, totalFrames)
			if (currentFrame == totalFrames) 
			{
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void 
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO hide loader
			//removeChild(_bg);
			removeChild(_loadbarCont)
			
			
			startup();
		}
		
		private function startup():void 
		{
			var mainClass:Class = getDefinitionByName("Main03") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}