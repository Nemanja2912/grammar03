package text2speech 
{
	/**
	 * ...
	 * @author andreasmuench.de
	 */
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.escapeMultiByte;
	 
	public class TextToSpeech 
	{
		
		private var _language:String = "de";
		private var _onComplete:Function;
		private var _snd:Sound;
		private var _channel:SoundChannel = new SoundChannel();
		
		public function TextToSpeech(defaultLanguage:String = "de") 
		{
			_language = defaultLanguage;
			
		}
		
		public  function say(text:String, onComplete:Function = null, lng:String = null) :void {
			trace(" TextToSpeech::say ", text);
			_onComplete = onComplete;
			if (lng == null) lng = _language;

			var url:String = "http://translate.google.com/translate_tts?ie=UTF-8&tl=" + lng + "&q=" +   escapeMultiByte(text);
			trace(" TextToSpeech::say ", url);
			var request:URLRequest = new URLRequest(url);

			
			_snd = new Sound();
			_snd.addEventListener(IOErrorEvent.IO_ERROR, onSoundLoadError);
			_snd.load(request);
			_channel = _snd.play();
			_channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			
		}
		
		private function onSoundLoadError(e:IOErrorEvent):void 
		{
			trace("onSoundLoadError", e.toString());
			if (_onComplete != null) _onComplete();
		}
		
		private function onSoundComplete(e:Event):void 
		{
			trace("TextToSpeech::onSoundComplete");
			_channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			if (_onComplete != null) _onComplete();
		}
		
	}

}