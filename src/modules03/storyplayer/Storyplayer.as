package modules03.storyplayer 
{
	import aze.motion.eaze;
	import base.gui.Dim;
	import base.images.BasicImage;
	import base.images.SimpleImage;
	import base.images.SimpleMultiImage;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import goethe.GoetheColors;
	import gui.iconButtons.IconBtnClose;

	import lt.uza.utils.Global;
	import text2speech.TextToSpeech;
	/**
	 * ...
	 * @author andreasmuench.de
	 */
	public class Storyplayer extends Sprite
	{
		private var global:Global = Global.getInstance();
		private var _xml:XML;
		private var _textToSpeech:TextToSpeech;
		private var _curSentId:int = 0;
		private var _dim:Dim 
		private var _bg:Sprite
		private var _img:SimpleMultiImage;
		private var _btnClose:IconBtnClose;
		
		private var _playing:Boolean = false;
		
		public static const CLOSE_STORYPLAYER:String = "CLOSE_STORYPLAYER";
		
		public function Storyplayer(xml:XML ) 
		{
			_xml = xml;
			_textToSpeech = new TextToSpeech();
			
			_dim = new Dim()//GoetheColors.GREEN);
			addChild(_dim);
			_dim.show();
			
			_bg = new Sprite();
			_bg.graphics.beginFill(GoetheColors.GREEN, 1);
			_bg.graphics.drawRoundRect(0, 0, 650, 500, 20);
		//	addChild(_bg);
			
			_img = new SimpleMultiImage( { width:600, height:450 } );
			_img.x = (MainBase.STAGE_WIDTH - 600) / 2
			_img.y = 100//(global.stage.stageHeight-450)/2
			addChild(_img);
			
			_btnClose = new IconBtnClose(40);
			_btnClose.addEventListener(MouseEvent.CLICK, onClickClose);
			_btnClose.x = _img.x + _img.width +30;
			_btnClose.y = _img.y + _btnClose.width / 2;
			addChild(_btnClose);
		}
		
		public function start():void {
			
			_curSentId = 0;
			_playing = true;
			initSentence(_curSentId)
		}
		
		public function stop():void {
			
			_playing = false;
			
		}
		
		
		private function onClickClose(e:MouseEvent):void 
		{
			dispatchEvent(new Event(CLOSE_STORYPLAYER));
		}
		
		private function initSentence(id:int):void {
			
			if (_playing) {
			
				_img.load(_xml.sentence[id].image[0]);
				
				var txt:String = "";
				for each(var x:XML in _xml.sentence[id].elem) {
					txt += x.text +" ";
				}
				
				_textToSpeech.say(txt, onTextComplete);
			}
		}
		
		private function onTextComplete():void 
		{
			trace("onTextComplete");
			eaze(this).delay(1).onComplete(nextSentence);
			//nextSentence();
		}
		
		private function nextSentence():void 
		{
			_curSentId ++;
			if (_curSentId < _xml.sentence.length()) {
				initSentence(_curSentId);
			} else {
				
				trace("FINISHED");
			}
		}
		
	}

}