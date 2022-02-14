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
		private var _cont:Sprite = new Sprite();
		private var _offset:Point = new Point();
		private var _balls:Array;
		private var _ballRadius:int = 40;
		private var _isMaximized:Boolean = true;
		public var id:int;
		private var _width:Number;
		private var _scaleTarget:Number;
		private var _targetPos:Point = new Point();
		//private var _
		//public var elementInSentence:Boolean = false; // ob ein ball von hier schon im sentence ist
		
		public static const BALL_MOUSE_DOWN:String = "BALL_MOUSE_DOWN";
		public static const CONT_CLICK:String = "CONT_CLICK";
		
		public function BallCont(xml:XML, args:Object=null) 
		{
			
			//trace(xml);
			addChild(_cont);
			_cont.addChild(_bg);
			
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
							wordBall = new WordBall(exml, {color:GoetheColors.LIGHT_BLUE_DARKER, colorHighlight:GoetheColors.LIGHT_BLUE});
							wordBall.container = this;
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
							wordBall.x = _ballRadius + wordBall.coords.x *_ballRadius*2//_offset.x +_ballRadius + wordBall.coords.x *_ballRadius*2;
							wordBall.y = _ballRadius +wordBall.coords.y *_ballRadius*2//_offset.y +_ballRadius +wordBall.coords.y *_ballRadius*2;
							
							_cont.addChild(wordBall);
							
							wordBall.customData.verbgroupId = int(gxml.@id);
							//trace("wordBall.customData.verbgroupId", wordBall.customData.verbgroupId);
							//trace("gxml", gxml);
							
							wordBall.show();
							wordBall.setCurPosAsBase();
							_balls.push(wordBall);
						}
					}
					
				//	_cont.x = _offset.x;
				//	_cont.y = _offset.y;
					
					groupId++;
					
					_bg.x = 0
					_bg.graphics.beginFill(GoetheColors.GREY_50);
					_bg.graphics.drawRoundRect(0,0,_ballRadius*2*6, _ballRadius*2*3, 20,20);
					
				}
			
			} else {
				_width = _ballRadius * 2 * 2;
				for each( exml in xml.elem) {
					wordBall = new WordBall(exml,  {color:GoetheColors.GREY, colorHighlight:GoetheColors.GREY_75} );
					wordBall.container = this;
					wordBall.prio = int(xml.@prio);
					if (exml.@prio != undefined) { // sonderfall "mich" hat andere prio
						trace("=================================> MICH PRIO = ",exml.@prio);
						wordBall.prio = Number(exml.@prio);
					}
					wordBall.coords = new Point(xc, yc);
					xc++;
					if (xc >= 2 ) {
						xc = 0;
						yc++;
					}
					wordBall.x = _ballRadius + wordBall.coords.x *_ballRadius*2;
					wordBall.y = _ballRadius +wordBall.coords.y *_ballRadius*2;
					_cont.addChild(wordBall);
					wordBall.setCurPosAsBase();
					wordBall.show();
					_balls.push(wordBall);
				}
				
				
				
				_bg.graphics.beginFill(GoetheColors.GREY_50);
				_bg.graphics.drawRoundRect(0,0,_ballRadius*2*2, _ballRadius*2*2, 20,20);
				
			}
			
			
			
		}
		
		
		public function setAllowedVerbBalls(allowedArr:Array, alsoSetInteractivity:Boolean = true):void {
			//trace("setAllowedVerbBalls");
			//trace (allowedArr);
			for (var g:int = 0; g < 3; g++) {
				var allowed:Boolean = allowedArr[g] == 0;
				
				//trace(g, "allowed", allowed);
				
				for (var b:int = 0; b < 6; b++) {
					var ball:WordBall = _balls[g * 6 + b];
					if (allowed) {
						if (ball.inContainer) {
							if (alsoSetInteractivity) ball.setInteractivity(true);
							
						//	if(visible) eaze(ball).to(.3, { alpha : 1 } );
							ball.isAllowed = true;
						}
					} else {
						if (ball.inContainer) {
							ball.setInteractivity(false);
							//if(visible) eaze(ball).to(.3, { alpha : 0.5 } );
							ball.isAllowed = false;
						}
					}
					
				}
				
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
				//trace("BallCont::ballAllowed", ballAllowed);
				//_balls[i].alpha = ballAllowed ?  1 : .5;
				//_balls[i].setInteractivity(ballAllowed);
				_balls[i].isAllowed = ballAllowed;
				
			}
		}
		
		public function resetAllowedBalls(allowedStr:String = null):void {
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
		
		
	
		
		
		public function minimize(xPos:Number):void {
			//trace("BallCont::minimize()",  id);
			_isMaximized = false;
			var scale:Number = .5;
			for each(var ball:WordBall in _balls) {
				if (ball.inContainer) {
					//trace("x/y", ball.coords.x, ball.coords.y);
					var xp:Number = (ball.basePos.x-ball.radius*1/scale)// -ball.coords.x * ball.radius// -  ball.radius;
					var yp:Number = (ball.basePos.y -ball.radius*1/scale)//ball.basePos.y -ball.coords.y * ball.radius //-  ball.radius;
				//	trace("xc, xp", ball.coords.y, yp);
					ball.removeEventListener(MouseEvent.MOUSE_DOWN, onBallMouseDown);
					ball.setInteractivity( false);
					
				//	eaze(ball).to(.5, { x:xp, y:yp, scaleX:scale, scaleY:scale } ); // 
				}
			}
			xp = _offset.x*scale + _ballRadius*scale// * 2;;
			yp = _offset.y//*scale// -_ballRadius*2*scale// -_ballRadius*2*scale///scale
			eaze(_cont).to(.5, { scaleX:scale, scaleY:scale } );
			eaze(this).to(.5, { x:xPos } );
			
			_scaleTarget = scale;
			_targetPos = new Point(xPos, y);
			
		}
		
		public function maximize(xPos:Number):void {
			trace("BallCont::maximize()",  id);
			_isMaximized = true;
			this.parent.addChild(this);
			for each(var ball:WordBall in _balls) {
				if (ball.inContainer) {
					ball.addEventListener(MouseEvent.MOUSE_DOWN, onBallMouseDown);
					//trace(" ball.isAllowed",  ball.isAllowed);
					ball.setInteractivity(  ball.isAllowed);
					
					var xp:Number = ball.basePos.x
					var yp:Number = ball.basePos.y ;
					//eaze(ball).to(.5, { x:xp, y:yp, scaleX:1, scaleY:1 } );
				}
			}
			xp = 0//_offset.x// * 2;;
			yp = 0//_offset.y
			eaze(_cont).to(.5, { scaleX:1, scaleY:1 } );
			eaze(this).to(.5, { x:xPos } );
			
			_scaleTarget = 1;
			_targetPos = new Point(xPos, y);
			
		}
				
		private function onBallMouseDown(e:MouseEvent):void 
		{
			parent.addChild(this);
			dispatchEvent (new CustomEvent(BALL_MOUSE_DOWN, true, false, { ball:e.currentTarget, localX:e.localX, localY:e.localY  } ));
		}
	
		
		public function setInteractivity(val:Boolean):void {
			//trace("setInteractivity");
			if (val) {
				//trace("addInteractivity");
				_bg.addEventListener(MouseEvent.CLICK, onClick);
				//_bg.x = 0;
				//_bg.addEventListener(MouseEvent.MOUSE_OVER, onOver);
				//_bg.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			}else {
				_bg.removeEventListener(MouseEvent.CLICK, onClick);
				//_bg.x = -10;
				//_bg.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
				//_bg.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			}
		}
		
		
		public function hasAllowedElements():Boolean {
			trace("hasAllowedElements");

			for each(var ball:WordBall in _balls) {
				trace("ball.isAllowed", ball.isAllowed);
				if (ball.isAllowed && ball.visible) {
					return true;
				}
			}
			return false;
			
		}
		
		public function get isMaximized():Boolean 
		{
			return _isMaximized;
		}
		
		override public function get width():Number 
		{
			return _width;
		}
		
		public function get scale():Number {
			return _cont.scaleX;
		}
		
		public function get scaleTarget():Number 
		{
			return _scaleTarget;
		}
		
		public function get targetPos():Point 
		{
			return _targetPos;
		}
		
		public function get balls():Array 
		{
			return _balls;
		}
		
	}

}