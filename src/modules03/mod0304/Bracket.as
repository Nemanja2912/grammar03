package modules03.mod0304 
{
	import base.events.CustomEvent;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import goethe.GoetheColors;
	import lt.uza.utils.Global;
	import shapes.ClosedArc;
	/**
	 * ...
	 * @author andreasmuench.de
	 */
	public class Bracket extends Sprite
	{
		
		private var global:Global = Global.getInstance()
		private var _stage:Stage;
		private var _bracketCont:Sprite = new Sprite();
		private var _bracket:ClosedArc
		private var _bracketPart:ClosedArc
		private var _bracketPartMask:Sprite = new Sprite();
		private var _bracketMask:Sprite = new Sprite();
		private var _centerY:Number;
		private var _centerX:Number;
		private var _clickedSide:int = 0;

		public static const MOUSE_DOWN:String = "bracketMouseDown";
		
		public function Bracket() 
		{
			
			this.buttonMode = true;
			//this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
		}
		/*
		private function onMouseDown(e:MouseEvent):void 
		{
			if (mouseX < _centerY) {
				_clickedSide = -1 
				
			} else {
				
				_clickedSide = 1 
			}
			
			
			dispatchEvent(new CustomEvent(MOUSE_DOWN, false, false, { clickedSide:_clickedSide } ));
			//this.addEventListener(Event.ENTER_FRAME, onDragEnterFrame);
		}
		
		/*private function onDragEnterFrame(e:Event):void 
		{
			i
		}
		*/
		
		public function draw(x1:Number, y1:Number, x2:Number):void {
			var dist:Number = Math.abs(x2 - x1);
			var thickness:Number = 15 + dist / 15; 
			
			_centerX= x1 + (x2-x1) / 2;
			_centerY = y1+ dist / 10;
			
			
			trace("x1", x1, "x2", x2, "centerX", _centerX);
			
			if (_bracket == null) {
				
				_bracket = new ClosedArc(GoetheColors.ORANGE,  _centerX, _centerY, dist / 2 - 20, dist / 2 + 20, 0, 1, 30)// 0-angleOffset-angleAdd, .5+angleAdd*2, 30);
				_bracketCont.addChild(_bracket);
				
				_bracketPart =  new ClosedArc(GoetheColors.GREY,  _centerX, _centerY, dist / 2 - 20, dist / 2 + 20, 0, 1, 30)// 0-angleOffset-angleAdd, .5+angleAdd*2, 30);
				_bracketCont.addChild(_bracketPart);
			}
			
			_bracket.draw(GoetheColors.ORANGE, _centerX, _centerY, dist / 2 - thickness, dist / 2 + thickness, 0, 1, 50)// 0 - angleOffset - angleAdd, .5 + angleAdd * 2, 30);
			_bracketPart.draw(GoetheColors.GREY, _centerX, _centerY, dist / 2 - thickness, dist / 2 + thickness, 0, 1, 50)// 0 - angleOffset - angleAdd, .5 + angleAdd * 2, 30);
			
			_bracketMask.graphics.clear();
			_bracketMask.graphics.beginFill(0xff00ff, .5);
			_bracketMask.graphics.drawRect(0, y1, 1200, 600);
			addChild(_bracketMask);
			
			_bracketCont.mask = _bracketMask;
			
			_bracketPartMask.graphics.clear();
			_bracketPartMask.graphics.beginFill(0x00ff00, .5);
			_bracketPartMask.graphics.drawCircle(_centerX, _centerY - dist * 5, dist * 5.15);
			addChild(_bracketPartMask);
			
			_bracketPart.mask = _bracketPartMask;
			
			addChild(_bracketCont);
			
			
			/*
			if (_verbBall1 != null && _verbBall2 != null) {
				var v1BowlAngle:Number  = Math.atan2 ( _bowlCenterX - _verbBall1.x  , _verbBall1.y - _bowlCenterY) + Math.PI/2; 
				var v2BowlAngle:Number  = Math.atan2 (_bowlCenterX - _verbBall2.x , _verbBall2.y - _bowlCenterY) + Math.PI/2; 

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
				
				/*_bracketPartMask.graphics.clear();
				_bracketPartMask.graphics.beginFill(0x00ff00, .5);
				_bracketPartMask.graphics.drawCircle(_bowlCenterX, _bowlCenterY, _bowlRadius + 70 +dist/7);
				*/
				/*var thickness:Number = 15 + dist / 15; 
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