package modules03.mod0305 
{
	import base.events.CustomEvent;
	import base.swf.SwfLoader;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import lt.uza.utils.Global;
	/**
	 * ...
	 * @author 
	 */
	public class Animation extends Sprite
	{
		private var global:Global = Global.getInstance()
		private var _xml:XML;
		public var id:int = -1;
		private var _curAnimId:int = 0;
		private var _anims:Array = [];
		
		private var _loader:Loader;
		
		public static const WIDTH:int = 850;
		public static const HEIGHT:int = 430;
		static public const ANIMATION_COMPLETE:String = "animationComplete";
		static public const ANIMATIONS_LOADED:String = "animationsLoaded";
		
		public function Animation(xml:XML ) 
		{
			_xml = xml;
			
			//for each(var ax:XML in xml.file) {
			
			/*if (!global.isMobile) { // im web vorladen, mobile nicht
				var swfLoader:SwfLoader = new SwfLoader(xml.file[0], onSwfLoaded);
			}
			*/
			
			//loadSwfs();

		}
		
		
		public function loadSwfs():void {
			
			if (global.isMobile) { // im web vorladen, mobile nicht
				loadNextSwfMobile()
			} else {
				loadNextSwf()
			}
			
		}
		
		
		private function loadNextSwf():void {
			var loadId:int = _anims.length
			var swfLoader:SwfLoader = new SwfLoader(_xml.file[loadId], onSwfLoaded);
			
		}
		private function onSwfLoaded(swf:MovieClip):void 
		{
			_anims.push(swf);
			if (_anims.length < 3) {
				loadNextSwf()
			} else {
				dispatchEvent(new Event(ANIMATIONS_LOADED));
			}
		}
		
		private function loadNextSwfMobile():void {
			
			var loadId:int = _anims.length
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.INIT, onSwfLoadedMobile, false, 0, true);
			var loaderContext:LoaderContext = new LoaderContext(); 
			loaderContext.allowCodeImport = true;
			_loader.loadBytes( new global.assets03.swfClasses05[this.id][loadId]() as ByteArray, loaderContext );
		}
		
		private function onSwfLoadedMobile(e:Event):void 
		{
			_anims.push( _loader.content as MovieClip );
			if (_anims.length < 3) { 
				loadNextSwfMobile() 
			} else {
				dispatchEvent(new Event(ANIMATIONS_LOADED));
			}
            //mc.stop();
		}
		
		
		
		
		public function play(aId:int) :void {
			/*if (global.isMobile) {
				if (_anims.length < 3) { // wenn swfs noch nicht erstellt ... jetzt machen
					_anims.push(new global.assets03.swfClasses05[this.id][0]())
					_anims.push(new global.assets03.swfClasses05[this.id][1]())
					_anims.push(new global.assets03.swfClasses05[this.id][2]())
				}
			}
			*/
			
			_curAnimId = aId;
			var i:int = 0;
			for each(var anim:MovieClip in _anims) {
				if (i == aId) {
					trace("Animation play", aId, _curAnimId);
					
					addChild(anim);
					anim.gotoAndPlay(0);
					anim.addEventListener(Event.ENTER_FRAME, onEF);
				} else {
					anim.stop();
					anim.removeEventListener(Event.ENTER_FRAME, onEF);
					if (contains(anim)) removeChild(anim);
				}
				i++
			}
		}
		
		private function onEF(e:Event):void 
		{
			
			var curAnim:MovieClip = _anims[_curAnimId];
			
		//	trace("curAnim.currentFrame", curAnim.currentFrame + "/" + curAnim.totalFrames);
			//trace("_anims.length", _anims.length);
			//trace("this.numChildren", this.numChildren);
			if (curAnim.currentFrame >= curAnim.totalFrames) {
				dispatchEvent(new CustomEvent(ANIMATION_COMPLETE, true, false, { anim:this } ));
			}
		}
		
		
		public function stop():void {
			for each(var anim:MovieClip in _anims) {
				anim.stop();
				anim.removeEventListener(Event.ENTER_FRAME, onEF);
			}
		}
		
		
		public function get allLoaded():Boolean {
			
			return (_anims.length >= 3) 
			
		}
		
		public function get curAnimId():int 
		{
			return _curAnimId;
		}
		
	}

}