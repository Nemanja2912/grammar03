package {
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import goethe.GoetheColors;
	import lt.uza.utils.Global;
	
	import aze.motion.eaze;
	
	/**
	 * ...
	 * @author me
	 */
	public class Preloader extends MovieClip {
		
		private var global:Global = Global.getInstance();
		private var _ready:Boolean = false;
		private var _progress:Number = 0;
		private var _bg:Sprite = new Sprite();
		private var _loadbarCont:Sprite = new Sprite();
		private var _bar:Sprite = new Sprite();
		
		
		public function Preloader() {
			
			var _params:Object = LoaderInfo(this.loaderInfo).parameters;   
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);	
		}
		

		
		private function init(e:Event = null):void  {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT
			
			_bg.graphics.beginFill(GoetheColors.GREEN);
			_bg.graphics.drawRect(0, 0, 1920, 1080);
			addChild(_bg);
			
			_loadbarCont.graphics.beginFill(0xffffff);
			_loadbarCont.graphics.drawRect(-4, -4, 208, 18);
			_loadbarCont.x = (stage.stageWidth - _loadbarCont.width) / 2
			_loadbarCont.y = 360;
			addChild(_loadbarCont);
			_loadbarCont.addChild(_bar);
			
			_bar.graphics.beginFill(GoetheColors.GREEN_DARKER)//0xc40a00);
			_bar.graphics.drawRect(0, 0, 200, 10);
			_bar.scaleX = 0;
			
			addEventListener(Event.ENTER_FRAME, checkFrame);
			
		
		}
		
		private function checkFrame(e:Event):void {
			
			_loadbarCont.x = (stage.stageWidth - _loadbarCont.width) / 2; // hier nochmal, damits immer klappt
			
			_progress = loaderInfo.bytesTotal / loaderInfo.bytesLoaded;
			
			_bar.scaleX += (_progress- _bar.scaleX ) / 5;
			trace(_progress);
			if ( _bar.scaleX  > 1) _bar.scaleX = 1; 
			if ( _bar.scaleX  >= .99) {
				_ready = true;
			}

			
			if (currentFrame == totalFrames && _ready) 	{
				removeEventListener(Event.ENTER_FRAME, checkFrame);
				hideStuff();
			}
		}
		
		
		private function hideStuff():void {
			
			eaze(_loadbarCont).to (0.5, { alpha:0 } ).onComplete(startup);
			
		}
		
		private function startup():void {
			stop();
			//loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			var mainClass:Class = getDefinitionByName("Main03") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}