package modules03.sentenceBowl 
{
	import aze.motion.eaze;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import goethe.GoetheColors;
	import lt.uza.utils.Global;
	import modules.wordballs.WordBall;
	import shapes.ClosedArc;
	/**
	 * ...
	 * @author andreasmuench.de
	 */
	public class SentenceBowl extends Sprite
	{
		
		private var global:Global = Global.getInstance()
		private var _stage:Stage;
		private var _bracketCont:Sprite = new Sprite();
		private var _bracket:ClosedArc
		private var _bracketPart:ClosedArc
		private var _bracketPartMask:Sprite = new Sprite();
		
		private var _verbBall1:WordBall;
		private var _verbBall2:WordBall;
		
		private var _bowlY:int = 0;
		private var _bowlRadius:Number = 400//400
		private var _bowlCenterY:Number = 60;
		private var _bowlCenterX:Number 
		private var _bowlThickness:Number = 25;
		
		
		private var _sentBalls:Array = [];
		private var _curSentCont:Sprite;
		
		public static const BALL_RADIUS:int = 40;
		
		private var _sentenceConts:Array = []// = new Sprite();
		
		public function SentenceBowl() 
		{
			
			
			_stage = global.stage;
			
			
			_bowlCenterX = MainBase.STAGE_WIDTH / 2;
			
			
			
			
			_curSentCont = new Sprite();
			addChild(_curSentCont);	
			
			_bracketCont = new Sprite();
			_curSentCont.addChild(_bracketCont);
			
			var bowl:ClosedArc = new ClosedArc(GoetheColors.GREY_50, _bowlCenterX, _bowlCenterY,_bowlRadius+ BALL_RADIUS, _bowlRadius+_bowlThickness+ BALL_RADIUS, .15, .2, 20);
		 	bowl.y = _bowlY;
			bowl.alpha = 0;
			eaze(bowl).to(.3, { alpha:1 } );
		//	bowl.x = 50;
			_curSentCont.addChild(bowl);
		
			_sentenceConts.push(_curSentCont);


			_sentBalls = [];

			
		}
		
		
		
		public function addSentXml(xml:XML):void {
			
			for each (var x:XML in xml.elem) {
				var ballArgs:Object = { };
				if (x.@type == "verb") {
					ballArgs = { color:GoetheColors.LIGHT_BLUE_DARKER, colorHighlight:GoetheColors.LIGHT_BLUE };
				}
				var ball:WordBall = new WordBall(x, ballArgs);
				if (x.@type == "verb") {
					if ( _verbBall1 == null) _verbBall1 = ball;
					else _verbBall2 = ball;
				}
				
				
				ball.show(0);
				_curSentCont.addChild(ball);
				_sentBalls.push(ball);
			}
			placeSentence(0);
			//drawBracket();
			
		}
		
		
			
		private function placeSentence(dur:Number = .5):void 
		{
			//var xp:int = (MainBase.STAGE_WIDTH - _sentBalls.length * BALL_RADIUS*2) / 2 +BALL_RADIUS;
			var tmpRad:Number =  _bowlRadius ;
			var umf:Number = tmpRad * 2 * Math.PI;
			var angleStep:Number = Math.PI / (umf / BALL_RADIUS ) * 4;
			//trace("angleStep", angleStep);
			var curAngle:Number =  Math.PI / 2 + (_sentBalls.length / 2 * angleStep) - angleStep/2;
			
			for each(var ball:WordBall in _sentBalls) {
				
				var xp:Number = _bowlCenterX+ Math.cos(curAngle) * _bowlRadius;
				//var yp:Number = _bowlCenterY  + BALL_RADIUS*1.5 + Math.sin(curAngle) * _bowlRadius;
				var yp:Number = _bowlY + _bowlCenterY  + Math.sin(curAngle) * _bowlRadius; // BALL_RADIUS*1.5 +
				ball.bowlAngle = curAngle;
				if (ball == _verbBall1) {
					eaze(ball).to(dur, { x:xp, y:yp } ).onUpdate(drawBracket);
				} else {
					eaze(ball).to(dur, { x:xp, y:yp } );
				}
				xp += 80;
				curAngle -= angleStep;
				
				
				
			}
			
			eaze(this).delay(.6).onComplete(drawBracket);
		}
		
		
			private function drawBracket():void {
		//	_bracket.graphics.clear();
			
		
			if (_verbBall1 != null && _verbBall2 != null) {
				//var v1BowlAngle:Number  = Math.atan2 (_bowlCenterX- _verbBall1.x , _bowlCenterY - _verbBall1.y  ) + Math.PI/2; 
				var v1BowlAngle:Number  = Math.atan2 ( _bowlCenterX - _verbBall1.x  , _verbBall1.y - _bowlCenterY) + Math.PI/2; 
				//var v2BowlAngle:Number  = Math.atan2 (_bowlCenterX-_verbBall2.x , _bowlCenterY - _verbBall2.y  ) + Math.PI/2; 
				var v2BowlAngle:Number  = Math.atan2 (_bowlCenterX - _verbBall2.x , _verbBall2.y - _bowlCenterY) + Math.PI/2; 
			//	_cannon.rotation = angle * 180 / Math.PI - 90; 
				// center point unten an der schale
				var centerAngle:Number = v1BowlAngle + (v2BowlAngle- v1BowlAngle)/2;
				//trace("centerAngle", centerAngle, _verbBall2.bowlAngle , _verbBall1.bowlAngle);
				var centerX:Number = _bowlCenterX + Math.cos(centerAngle) * (_bowlRadius + BALL_RADIUS + _bowlThickness);
				var centerY:Number = _bowlY + _bowlCenterY  + Math.sin(centerAngle) *  (_bowlRadius + BALL_RADIUS + _bowlThickness);
				// verb1 verlängerter punkt an bowlende
				var v1X:Number = _bowlCenterX + Math.cos(v1BowlAngle) * (_bowlRadius + BALL_RADIUS + _bowlThickness);
				var v1Y:Number = _bowlY + _bowlCenterY  + Math.sin(v1BowlAngle) *  (_bowlRadius + BALL_RADIUS + _bowlThickness);
				
				var v2X:Number = _bowlCenterX + Math.cos(v2BowlAngle) * (_bowlRadius + BALL_RADIUS + _bowlThickness);
				var v2Y:Number = _bowlY + _bowlCenterY  + Math.sin(v2BowlAngle) *  (_bowlRadius + BALL_RADIUS + _bowlThickness);
				
				var dist:Number = Point.distance(new Point(v1X, v1Y), new Point(v2X, v2Y));
				//var center:Point = newPoinrPoint.interpolate(_verbBall1.posPoint, _verbBall2.posPoint, .5);
				
				
				//_bracket.graphics.lineStyle(60, 0xff0000, 1);
				//_bracket.graphics.drawCircle(centerX, centerY, 10);
				
				//var startAngle:Number = (_verbBall2.bowlAngle  - Math.PI/2) / Math.PI;
				//var endAngle:Number =  (_verbBall1.bowlAngle  - Math.PI/2) / Math.PI;
				var angleOffsets:Array = [0, 0, 0, .01, .012, .013, .0135];
				var angleOffset:Number =  angleOffsets[_sentBalls.length]; // abhängig von länge des satzes andere drhung des bracket
				
				var angleAdds:Array = [0, 0, 0, .02, .025, .035, .04]; // längere Arme bei mehr kugeln
				var angleAdd:Number =  angleAdds[_sentBalls.length]; 
				
				if (_bracket == null) {
					_bracket = new ClosedArc(GoetheColors.ORANGE, centerX, centerY, dist / 2 - 20, dist / 2 + 20, 0-angleOffset-angleAdd, .5+angleAdd*2, 30);
					_bracketCont.addChild(_bracket);
					
					_bracketPart = new ClosedArc(GoetheColors.GREY, centerX, centerY, dist / 2 - 20, dist / 2 + 20, 0 - angleOffset - angleAdd, .5 + angleAdd * 2, 30);
					_bracketCont.addChild(_bracketPart);
					
					_bracketPartMask = new Sprite();
					_bracketCont.addChild(_bracketPartMask);
					_bracketPart.mask = _bracketPartMask
					
					eaze(_bracketCont).to(0, { alpha:0 } );
					
				}
				if(_bracketCont.alpha < 1) eaze(_bracketCont).to(.3, { alpha:1 } );
				
				_bracketPartMask.graphics.clear();
				_bracketPartMask.graphics.beginFill(0x00ff00, .5);
				_bracketPartMask.graphics.drawCircle(_bowlCenterX, _bowlCenterY, _bowlRadius + 70 +dist/7);
				var thickness:Number = 15 + dist / 15; 
				_bracket.draw(GoetheColors.ORANGE, centerX, centerY, dist / 2 - thickness, dist / 2 + thickness, 0 - angleOffset - angleAdd, .5 + angleAdd * 2, 30);
				
				_bracketPart.draw(GoetheColors.GREY, centerX, centerY, dist / 2 - thickness, dist / 2 + thickness, 0-angleOffset-angleAdd, .5+angleAdd*2, 30);
				
				
				/*
				
				_bracket.graphics.lineStyle(60, GoetheColors.GREY, 1);
				//_bracket.graphics.drawCircle(centerX, centerY, 10);
				_bracket.graphics.drawCircle(centerX, centerY, dist / 2);
				/*var h:Number = dist / 2;
				var w:Number = dist;
				_bracket.graphics.drawEllipse(centerX - w / 2, centerY - h / 2, w, h);
				*/
			} 
			
			
		}
		
		
	}

}