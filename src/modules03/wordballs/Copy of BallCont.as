package modules03.wordballs 
{
	import aze.motion.eaze;
	import base.events.CustomEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import goethe.GoetheColors;
	/**
	 * ...
	 * @author andreasmuench.de
	 */
	public class BallCont extends Sprite
	{
		private var _bg:Sprite = new Sprite()
		private var _offset:Point = new Point();
		private var _balls:Array;
		private var _ballRadius:int = 40;
		private var _isMaximized:Boolean = true;
		public var id:int;
		private var _width:Number;
		
		public static const BALL_MOUSE_DOWN:String = "BALL_MOUSE_DOWN";
		public static const CONT_CLICK:String = "CONT_CLICK";
		
		public function BallCont(xml:XML, args:Object=null) 
		{
			
			//trace(xml);
			
			addChild(_bg);
			
			if (args != null) {
				if (args.offset != undefined) _offset = args.offset;
				
			}
				
			_balls = [];
			
			var wordBall:WordBall;
			var xp:int = 0;
			var yp:int = 0;
			var xc:int = 0;
			var yc:int = 0;
			
			if (xml.verbgroup != undefined) {
				_width = _ballRadius * 2 * 6;
				//var boxId:int = 0;
				var groupId:int = 0;
				//trace("VERBGROUP");
				for each(var gxml:XML in xml.verbgroup) {
					yc = 0;
					for each(var pxml:XML in gxml.pair) {
						xc = groupId * 2;
						for each(var exml:XML in pxml.elem) {
							wordBall = new WordBall(exml);
							wordBall.coords = new Point(xc, yc);
							wordBall.prio = (xc - groupId * 2) == 1 ?  6 : 2; // an satzstelle 2 oder 5
							wordBall.pairXml = pxml;
							xc++;
							if ((xc-groupId * 2) >= 2 ) {
								xc = groupId * 2;
								yc++;
								
								wordBall.partner = _balls[_balls.length - 1];
								_balls[_balls.length - 1].partner = wordBall;
							}
							wordBall.x = _offset.x +_ballRadius + wordBall.coords.x *_ballRadius*2;
							wordBall.y = _offset.y +_ballRadius +wordBall.coords.y *_ballRadius*2;
							
							addChild(wordBall);
							
							
							wordBall.show();
							wordBall.setCurPosAsBase();
							_balls.push(wordBall);
						}
					}
					
					groupId++;
					
					_bg.x = _offset.x;
					_bg.graphics.beginFill(GoetheColors.GREY);
					_bg.graphics.drawRoundRect(_offset.x,_offset.y,_ballRadius*2*6, _ballRadius*2*3, 20,20);
					
				}
			
			} else {
				_width = _ballRadius * 2 * 2;
				for each( exml in xml.elem) {
					wordBall = new WordBall(exml);
					wordBall.prio = int(xml.@prio);
					wordBall.coords = new Point(xc, yc);
					xc++;
					if (xc >= 2 ) {
						xc = 0;
						yc++;
					}
					wordBall.x = _offset.x  +_ballRadius + wordBall.coords.x *_ballRadius*2;
					wordBall.y = _offset.y  +_ballRadius +wordBall.coords.y *_ballRadius*2;
					addChild(wordBall);
					wordBall.setCurPosAsBase();
					wordBall.show();
					_balls.push(wordBall);
				}
				
				_bg.graphics.beginFill(GoetheColors.GREY);
				_bg.graphics.drawRoundRect(_offset.x,_offset.y,_ballRadius*2*2, _ballRadius*2*2, 20,20);
				
			}
			
			
			
		}
		
		
		public function setAllowedBalls(allowedStr:String):void {
			var allowed:Array;
			if (allowedStr == "") { // ""
				allowed = [];
			} else if (allowedStr.indexOf(",") != -1) { //"0,2,3"
				allowed = allowedStr.split(",");
			} else {
				allowed = [allowedStr]; // "1"
			}
			
			//for each (var ball:WordBall in _balls) {
			for  (var i:int = 0; i < _balls.length; i++) {
				var ballAllowed:Boolean = allowed.indexOf(String(i)) != -1;
				trace("BallCont::ballAllowed", ballAllowed);
				//_balls[i].alpha = ballAllowed ?  1 : .5;
				//_balls[i].setInteractivity(ballAllowed);
				_balls[i].isAllowed = ballAllowed;
				
			}
		}
		
		public function resetAllowedBalls(allowedStr:String):void {
			for  (var i:int = 0; i < _balls.length; i++) {
				_balls[i].isAllowed = true;;
				
			}
			
		}
		
		
		
		/*
		private function onOver(e:MouseEvent):void 
		{
			maximize();
		}
		
		private function onOut(e:MouseEvent):void 
		{
			minimize()
		}
		*/
			
		private function onClick(e:MouseEvent):void 
		{
			dispatchEvent(new CustomEvent(CONT_CLICK, false, false, { cont:this } ))
		/*if (_isMaximized) {
				minimize();
			}else {
				maximize();
			}
			*/
		}
		
		
	
		
		
		public function minimize():void {
			trace("BallCont::minimize()",  id);
			_isMaximized = false;
			var scale:Number = .5;
			for each(var ball:WordBall in _balls) {
				if (ball.inContainer) {
					//trace("x/y", ball.coords.x, ball.coords.y);
					var xp:Number = (ball.basePos.x-ball.radius*1/scale)// -ball.coords.x * ball.radius// -  ball.radius;
					var yp:Number = (ball.basePos.y -ball.radius*1/scale)//ball.basePos.y -ball.coords.y * ball.radius //-  ball.radius;
					trace("xc, xp", ball.coords.y, yp);
					ball.removeEventListener(MouseEvent.MOUSE_DOWN, onBallMouseDown);
					ball.setInteractivity( false);
					
					eaze(ball).to(.5, { x:xp, y:yp, scaleX:scale, scaleY:scale } ); // 
				}
			}
			xp = _offset.x*scale + _ballRadius*scale// * 2;;
			yp = _offset.y//*scale// -_ballRadius*2*scale// -_ballRadius*2*scale///scale
			eaze(_bg).to(.5, { scaleX:scale, scaleY:scale , x:xp, y:yp} );
			
			
		}
		
		public function maximize():void {
			trace("BallCont::maximize()",  id);
			_isMaximized = true;
			this.parent.addChild(this);
			for each(var ball:WordBall in _balls) {
				if (ball.inContainer) {
					ball.addEventListener(MouseEvent.MOUSE_DOWN, onBallMouseDown);
					trace(" ball.isAllowed",  ball.isAllowed);
					ball.setInteractivity(  ball.isAllowed);
					
					var xp:Number = ball.basePos.x
					var yp:Number = ball.basePos.y ;
					eaze(ball).to(.5, { x:xp, y:yp, scaleX:1, scaleY:1 } );
				}
			}
			xp = 0//_offset.x// * 2;;
			yp = 0//_offset.y
			eaze(_bg).to(.5, { scaleX:1, scaleY:1, x:xp, y:yp} );
			
		}
				
		private function onBallMouseDown(e:MouseEvent):void 
		{
			parent.addChild(this);
			dispatchEvent (new CustomEvent(BALL_MOUSE_DOWN, true, false, { ball:e.currentTarget, localX:e.localX, localY:e.localY  } ));
		}
	
		
		public function setInteractivity(val:Boolean):void {
			trace("setInteractivity");
			if (val) {
				trace("addInteractivity");
				_bg.addEventListener(MouseEvent.CLICK, onClick);
				//_bg.addEventListener(MouseEvent.MOUSE_OVER, onOver);
				//_bg.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			}else {
				_bg.removeEventListener(MouseEvent.CLICK, onClick);
				//_bg.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
				//_bg.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			}
		}
		
		public function get isMaximized():Boolean 
		{
			return _isMaximized;
		}
		
		override public function get width():Number 
		{
			return _width;
		}
		
	}

}