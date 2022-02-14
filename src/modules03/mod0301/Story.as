package modules03.mod0301 
{
	import aze.motion.eaze;
	import base.events.CustomEvent;
	import base.images.SimpleImage;
	import base.text.BasicText;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import goethe.GoetheColors;
	import lt.uza.utils.Global;
	import text2speech.TextToSpeech;
	/**
	 * ...
	 * @author 
	 */
	public class Story extends Sprite
	{
		
		
		[Embed(source = "../../../bin/data/01/1a.mp3")]
		private var Snd1a:Class;
		[Embed(source = "../../../bin/data/01/1b.mp3")]
		private var Snd1b:Class;
		[Embed(source = "../../../bin/data/01/2a.mp3")]
		private var Snd2a:Class;
		[Embed(source = "../../../bin/data/01/2b.mp3")]
		private var Snd2b:Class;
		[Embed(source = "../../../bin/data/01/3a.mp3")]
		private var Snd3a:Class;
		[Embed(source = "../../../bin/data/01/3b.mp3")]
		private var Snd3b:Class;
		[Embed(source = "../../../bin/data/01/4a.mp3")]
		private var Snd4a:Class;
		[Embed(source = "../../../bin/data/01/4b.mp3")]
		private var Snd4b:Class;
		[Embed(source = "../../../bin/data/01/5a.mp3")]
		private var Snd5a:Class;
		[Embed(source = "../../../bin/data/01/5b.mp3")]
		private var Snd5b:Class;
		[Embed(source = "../../../bin/data/01/6a.mp3")]
		private var Snd6a:Class;
		[Embed(source = "../../../bin/data/01/6b.mp3")]
		private var Snd6b:Class;
		
		private var _soundsA:Array = [Snd1a, Snd2a, Snd3a, Snd4a, Snd5a, Snd6a]
		private var _soundsB:Array = [Snd1b, Snd2b, Snd3b, Snd4b, Snd5b, Snd6b]
		
		private var global:Global  = Global.getInstance();
		private var _xml:XML;
		private var _id:int;
		private var _cont:Sprite = new Sprite();
		private var _imgCont:Sprite  = new Sprite();
		private var _img1:SimpleImage;
		private var _img2:SimpleImage;
		private var _txtBox:Sprite;
		private var _txtBoxData:Object = { x:0, y:0, width:100, height:50 };
		private var _tf:BasicText;
		private var _txtToSpeech:TextToSpeech
		private var _cbStoryPlayComplete:Function;
		public var done:Boolean = false;
		private var _nextScale:Number = 1;
		public var customData:Object = { };
		private var  _tfScale:Number = 1;
		
		private var _sound:Sound = new Sound();
		private var _channel:SoundChannel;
		
		private var _imperativeIndexes:Array = [] // die character indizes auf denen der Imperativ ist, also die nummern der Buchstaben, die nachher klickbar sein sollen
		private var _imperativeWords:Array = [];
		
		private static const TXT_PADDING:int = 10;
		
		public static const IMG_WIDTH:int = 640;
		public static const IMG_HEIGHT:int = 480;
		
		public static const STORY_PLAY_COMPLETE:String = "STORY_PLAY_COMPLETE";
		
		public static const SCALE_FULL:String = "SCALE_FULL";
		public static const SCALE_MEDIUM:String = "SCALE_MEDIUM";
		public static const SCALE_SMALL:String = "SCALE_SMALL";
		public static const SCALE_TINY:String = "SCALE_TINY";
		public static const SCALE_WIDE:String = "SCALE_WIDE";
		public static const SCALE_TEXT_ONLY:String = "SCALE_TEXT_ONLY";
		
		public static const TEXT_CLICK:String = "TEXT_CLICK";
		
		public function Story(xml:XML, id:int) 
		{
			
			_xml = xml;
			_id = id;
			
			addChild(_cont);
			_cont.addChild(_imgCont);
			
			

			if (global.isMobile) {
				var imgId:int = _xml.elem[0].image[0].@mobileId.toString() != "" ? int(_xml.elem[0].image[0].@mobileId) : id
				_img1 = new SimpleImage( { bitmap:new global.assets03.images01a[imgId](), smoothing:true }, true);
			} else {
				_img1 = new SimpleImage( { url:_xml.elem[0].image[0], smoothing:true }, true); // , width:80, height:60 
			}
			_img1.x = -IMG_WIDTH/2;
			_img1.y = -IMG_HEIGHT/2
			_imgCont.addChild(_img1);
			
			if (_xml.elem[1] != undefined) {
				if (global.isMobile) {
					_img2 = new SimpleImage( { bitmap:new global.assets03.images01b[id](), smoothing:true }, true);
				} else {
					_img2 = new SimpleImage( { url:_xml.elem[1].image[0], smoothing:true}, true); // , width:80, height:60 
				}
				
				_img2.x = -IMG_WIDTH/2;
				_img2.y = -IMG_HEIGHT/2
				_imgCont.addChild(_img2);
				eaze(_img2).to(0, { alpha:0 } );
			}
			
			var imgMask:Sprite = new Sprite();
			imgMask.graphics.beginFill(0xff0000, .5);
			//imgMask.graphics.drawRoundRect(-IMG_WIDTH/2, -IMG_HEIGHT/2, IMG_WIDTH, IMG_HEIGHT, 40, 40);
			imgMask.graphics.drawRect(-IMG_WIDTH/2, -IMG_HEIGHT/2, IMG_WIDTH, IMG_HEIGHT);
			
			_imgCont.addChild(imgMask);
			_imgCont.mask = imgMask;
			
			_txtBox = new Sprite();
			_cont.addChild(_txtBox);
			
			_tf = new BasicText({multiline:true, width:IMG_WIDTH, antiAliasType:AntiAliasType.NORMAL, textAlign:"center"});
			_tf.y = 5//5//IMG_HEIGHT/2;
			_txtBox.addChild(_tf);
			// _imperativeIndexes ermitteln
			var tmpTxt:String = _xml.elem[0].text[0];
			var charIndex:int = 0;
			var isImperative:Boolean = false;
			for (var i:int = 0; i < tmpTxt.length; i++) {
				var char:String = tmpTxt.charAt(i);
				if (char == "|") {
					isImperative = !isImperative; 
				} else {
					if (isImperative) _imperativeIndexes.push(charIndex);
					charIndex++;
				}
			}
			_tf.text = tmpTxt.split("|").join("");
			_tf.x = 10//-_tf.width / 2;
			_tf.addEventListener(MouseEvent.CLICK, onTfClick);
			
			// imperativ-Wörter ermitteln
			var parts:Array =  tmpTxt.split("|");
			for (i = 1; i < parts.length; i+=2) {
				_imperativeWords.push(parts[i]);
				trace("parts[i]", parts[i]);
			}
			
		//	_txtToSpeech = new TextToSpeech();
			
		}
		
	
			
		
		
		public function playStory(cbStoryPlayComplete:Function = null, soundB:Boolean = false):void {
			//_img1.addEventListener(MouseEvent.CLICK, onClickImg);
			_cbStoryPlayComplete = cbStoryPlayComplete;
			
			if (_img2 != null) eaze(_img2).to(.5, { alpha:0 } );

			var txt:String = String(_xml.elem[0].text[0]).split("|").join("")
			_tf.text = txt
			//_txtToSpeech.say(txt.split("<b>").join("").split("</b>").join(""), playStoryImage2);
			//_txtToSpeech.say("eins", playStoryImage2);
			
			trace("_id", _id);
			trace("soundB", soundB);
			if (soundB) {
				_sound = new _soundsB[_id]();
			} else {
				_sound = new _soundsA[_id]();
			}
			_channel = _sound.play(0,1);
			_channel.addEventListener(Event.SOUND_COMPLETE, playStoryImage2, false, 0, true);
			
			
		}
		
		private function onClickImg(e:MouseEvent):void 
		{
			
		}
		
		public function showFirstImage():void 
		{
			eaze(_img2).to(.5, { alpha:0 } );
			
			//var txt:String = String(_xml.elem[0].text[0]).split("|").join("");
			//_tf.text = txt
			showImperativeTextOnly();

			//_txtToSpeech.say(txt);
		}
		
		private function playStoryImage2(e:Event = null):void 
		{
			if (_img2 != null) {
				eaze(_img2).to(.5, { alpha:1 } );
				var txt:String =  _xml.elem[1].text[0];
				_tf.text = txt
				_sound = new _soundsB[_id]();
				_channel = _sound.play(0,1);
				_channel.addEventListener(Event.SOUND_COMPLETE, onStoryPlayComplete, false, 0, true);
			//	_txtToSpeech.say(txt, onStoryPlayComplete);
				//_txtToSpeech.say("zwei", onStoryPlayComplete);
			}
		}
		
		private function onStoryPlayComplete(e:Event = null):void 
		{
			dispatchEvent(new Event(STORY_PLAY_COMPLETE));
			if (_cbStoryPlayComplete != null) _cbStoryPlayComplete();
		}
		
		public function showImperativeTextOnly():void {
			
			var txt:String = String(_xml.elem[0].text[0]);
			if (txt.indexOf("|") != -1) {
				txt = txt.split("|")[0];
			}
			_tf.text = txt;
			
			
			
		}
		
		public function scale(type:String, dur:Number = .5, showText:Boolean = true):void {
			
			
			var imgObj:Object ;
			
			switch(type) {
				
				case SCALE_FULL:
					_nextScale  = 1;
					//tfObj = { y:nextHeight/2+10, x: -tfBaseW*_nextScale / 2, scaleX:1, scaleY:1 , alpha:showText? 1 : 0} ;
					break;
				
				case SCALE_MEDIUM:
					_nextScale = .5;
					//tfScale = .75
					//tfObj = { y:nextHeight/2+10, x: -tfBaseW*tfScale / 2, scaleX:tfScale, scaleY:tfScale , alpha:showText? 1 : 0} ;
					break;
					
				case SCALE_SMALL:
					_nextScale = .3;
					//tfScale = .75
					//var tw:Number = IMG_WIDTH * _nextScale / tfScale;
					//tfObj = { width:tw, y:nextHeight/2+10, x: -tw*tfScale / 2, scaleX:tfScale, scaleY:tfScale , alpha:showText? 1 : 0} ;
					break;
					
				case SCALE_TINY:
					_nextScale = .2;
					//tfScale = .2
					//tfObj = {  y:nextHeight/2+10, x: -tfBaseW*tfScale / 2, scaleX:tfScale, scaleY:tfScale , alpha:showText? 1 : 0} ;
	
					break;
					
				case SCALE_WIDE:
					_nextScale = .1;
					//tfObj = { width:tfBaseW, x:nextWidth / 2 + 20, y: -nextHeight / 2 + (nextHeight - _tf.height) / 2, alpha:1 , scaleX:1, scaleY:1 } ;
					break;
					
				case SCALE_TEXT_ONLY:
					_nextScale = .1;
					//tfObj = { width:tfBaseW, x:nextWidth / 2 + 20, y: -nextHeight / 2 + (nextHeight - _tf.height) / 2, alpha:1 , scaleX:1, scaleY:1 } ;
					break;
					
				
			}
			
			imgObj = { scaleX:_nextScale, scaleY:_nextScale } 
			imgObj.alpha = (type == SCALE_TEXT_ONLY) ? 0 : 1; 
			
			
			eaze(_imgCont).to(dur,imgObj ).onComplete(showTf, type, showText);

			eaze(_txtBox).to(dur / 3, { alpha:0 } );

			
		}
		
		
		public function hideTf():void {
			
			//eaze(_tf).to(.5, { alpha: 0 } );
			eaze(_txtBox).to(.5, { alpha: 0 } );
			
		}
		
		public function showTf(type:String, showText:Boolean = true):void 
		{
			
		//	 showText = true;
			
			if (showText) {
				_tf.scaleX = 1;
				var tmpW:Number = _tf.width;
				_tf.width = 1000;
				_tf.width = _tf.textWidth + 2;
				var tfBaseW:Number = _tf.width;
				_tf.width = tmpW;
				_tf.scaleX = _tf.scaleY;
				
				var tfObj:Object = { };
				
				_tf.y = 5;
				
				var txtBoxNew:Object = { };
				
				switch(type) {
					
					case SCALE_FULL:
						_nextScale  = 1;
						_tf.scaleX = _tf.scaleY = _tfScale = 1;
						//tfObj = { y:nextHeight / 2 + 10, x: -tfBaseW * _nextScale / 2, scaleX:1, scaleY:1 } ;
						_tf.width = _imgCont.width - 2 * TXT_PADDING;
						_txtBox.x = - _imgCont.width / 2;
						_txtBox.y = _imgCont.height / 2;
						
						break;
					
					case SCALE_MEDIUM:
						_nextScale = .5;
						_tf.scaleX = _tf.scaleY = _tfScale = .8;
						_tf.width = (_imgCont.width - 2 * TXT_PADDING)/_tfScale
						_txtBox.x = - _imgCont.width / 2;
						_txtBox.y = _imgCont.height / 2;

						//tfObj = { y:nextHeight/2+10, x: -tfBaseW*tfScale / 2, scaleX:tfScale, scaleY:tfScale } ;

						break;
						
					case SCALE_SMALL:
						_nextScale = .3;
						_tf.scaleX = _tf.scaleY = _tfScale = .6;
						_tf.width = (_imgCont.width - 2 * TXT_PADDING)/_tfScale
					//	var tw:Number = IMG_WIDTH * _nextScale / tfScale;
						//tfObj = { width:tw, y:nextHeight/2+10, x: -tw*tfScale / 2, scaleX:tfScale, scaleY:tfScale } ;
						_txtBox.x = - _imgCont.width / 2;
						_txtBox.y = _imgCont.height / 2;
						break;
						
					case SCALE_TINY:
						_nextScale = .2;
						_tf.scaleX = _tf.scaleY = _tfScale = .6;
						_tf.width = (_imgCont.width - 2 * TXT_PADDING)/_tfScale
						
						//tfObj = {  y:nextHeight / 2 + 10, x: -tfBaseW * tfScale / 2, scaleX:tfScale, scaleY:tfScale } ;
						_txtBox.x = - _imgCont.width / 2;
						_txtBox.y = _imgCont.height / 2;
		
						break;
						
					case SCALE_WIDE:
					case SCALE_TEXT_ONLY:
						_nextScale = .1;
						_tf.scaleX = _tf.scaleY = _tfScale = 1;
						_tf.width = 520
						_tf.y = ( _imgCont.height - _tf.height) / 2;
						//tfObj = { width:tfBaseW, x:nextWidth / 2 + 20, y: -nextHeight / 2 + (nextHeight - _tf.height) / 2, alpha:1 , scaleX:1, scaleY:1 } ;
						_txtBox.x =  _imgCont.width / 2;
						_txtBox.y = -_imgCont.height / 2;
						
						//_txtBoxData = { x:nextWidth / 2 + 20, y: -nextHeight / 2 + (nextHeight - _tf.height) / 2 };
						break;
						
					
				}
				
				
				_txtBoxData.width = (_tf.width)*_tfScale +TXT_PADDING*2
				_txtBoxData.height = type == SCALE_WIDE ?  _imgCont.height-10 :(_tf.height)*_tfScale;
			//	eaze(_tf).to (0, tfObj );
				if (showText) eaze(_txtBox).to (0.5, {alpha:1} );
				//eaze(_txtBoxData).to (.5, txtBoxNew ).onUpdate(updateTxtBox);;
				
				updateTxtBox();
			}
		}
		
		
		private function updateTxtBox():void {
			var cornerRad:Number = Math.min(20, _txtBoxData.height / 2);
			_txtBox.graphics.clear();
			_txtBox.graphics.beginFill(GoetheColors.LIGHT_BLUE);
			_txtBox.graphics.drawRoundRect(_txtBoxData.x, _txtBoxData.y, _txtBoxData.width,  _txtBoxData.height+10, cornerRad, cornerRad);
			_txtBox.graphics.endFill();	
		}
		
		
		
		private function onTfClick(e:MouseEvent):void 
		{
			var tf:TextField = _tf.tf;
			var charIndex:int = tf.getCharIndexAtPoint(e.localX, e.localY);
			if (_imperativeIndexes.indexOf(charIndex) != -1) { // click auf imperativ
				trace("IMPERATIV");
				dispatchEvent(new CustomEvent(TEXT_CLICK, false, false, {isImperative:true, story:this, pos:new Point(e.localX, e.localY) } ));
			} else {
				trace("NICHT IMPERATIV!");
				dispatchEvent(new CustomEvent(TEXT_CLICK, false, false, {isImperative:false, story:this } ));
			}
			
		}
		
		
		
		public function get id():int 
		{
			return _id;
		}
		
		public function get text():String {
			
			return _tf.text;
		}
		
		public function get type():int {
			return int(_xml.@type)
		}
		
		public function get isFormal():Boolean {
			return (_xml.@formal == "true")
		}
		
		public function get isSingular():Boolean {
			return (_xml.@singular == "true")
		}
		
		public function get nextHeight():Number {
			return IMG_HEIGHT * _nextScale;
		}
		public function get nextWidth():Number {
			return IMG_WIDTH * _nextScale;
		}
		
		public function get imperativeWords():Array 
		{
			return _imperativeWords;
		}
		
		public function get xml():XML 
		{
			return _xml;
		}
	}

}