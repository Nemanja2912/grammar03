package modules03.wordballs 
{
	import aze.motion.easing.Back;
	import aze.motion.easing.Elastic;
	import aze.motion.eaze;
	import base.text.BasicText;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import goethe.GoetheColors;
	
	/**
	 * ...
	 * @author andreasmuench.de
	 */
	public class WordBall extends Sprite
	{
		private var _args:Object ; // für clones
		private var _xml:XML;
		private var _bg:Sprite = new Sprite();
		private var _tf:BasicText;
		public var physBody:b2Body;
		public var type:String;
		public var basePos:Point = new Point();
		private var _coords:Point = new Point();
		private var _radius:int = 40;
		public var partner:WordBall;
		public var pairXml:XML; 
		private var _inContainer:Boolean = true;
		public var prio:Number = 0;
		private var _isAllowed:Boolean = true;
		public var container:BallCont;
		public var original:WordBall; // bei clones
		//public var id:int;
		//private var _atBase
		public var bowlAngle:Number = 0; // für MOd0202
		private var _color:uint = GoetheColors.GREEN;
		private var _colorHighlight:uint = 0xc4fa09
		private var _roll:Number = 0;
		private var _mask:Sprite = new Sprite();
		public var customData:Object = { };
		
		
		
		public function WordBall(xml:XML, args:Object = null) 
		{
			_args = args;
			_xml = xml;
			_radius = 40;
			
			trace(args);
			if (args != null) {
				if (args.radius != undefined) _radius = args.radius;
				if (args.color != undefined) _color = args.color;
				if (args.colorHighlight != undefined) _colorHighlight = args.colorHighlight;
				
				
			}
		
			type = xml.@type.toString();
			//trace(type);
			drawBg();
			
			
			
			addChild(_bg);
			
		
			
			//trace(xml.text);
			_tf = new BasicText( { txt:xml.text, fontSize:20, multiline:true, antiAliasType:AntiAliasType.NORMAL, textAlign:"center" } );
			_tf.width = radius * 2;
			//_tf.width = Math.min(_tf.textWidth+5, radius*2);
			_tf.x = -radius
			_tf.y = -_tf.height / 2;
			addChild(_tf);
			_tf.mouseChildren = _tf.mouseEnabled = false;
			
				
			_mask.graphics.beginFill(0xff0000, .4);
			_mask.graphics.drawCircle(0, 0, _radius);
			addChild(_mask);
			
			_tf.mask = _mask;
			//var a:* = _tf.getLineMetrics();
			
		
			
			scaleX = scaleY = 0;
		}
		
		private function drawBg():void 
		{
			
			//var spr:Sprite= new Sprite();
			var matr:Matrix = new Matrix();
			matr.createGradientBox( _radius*2, _radius*2,0 , -_radius*0.6, -_radius*1.4 );
			_bg.graphics.beginGradientFill( GradientType.RADIAL, [_colorHighlight, _color], [1,1], [ 0, 255 ], matr, SpreadMethod.PAD );
			//_bg.graphics.beginFill(_color);
			_bg.graphics.drawCircle(0, 0, _radius);
		}
		
		
		public function clone():WordBall {
			
			var clone:WordBall = new WordBall(_xml, _args);
			clone.x = parent.parent.parent.x + parent.parent.x + x; // bcCont, cont ... args
			clone.y = parent.parent.y + y;
			clone.original = this;
			clone.container = parent.parent as BallCont;
			clone.basePos = basePos;
			clone.prio = prio;
			clone.partner = partner;
			clone.pairXml = pairXml;
			clone.customData = customData;
			
			//eaze(clone).to(.3, { tint:0xff0000 } );
			return clone;
			
		}
		
		
		public function onOver(e:MouseEvent = null):void 
		{
			eaze(_bg).to(.2).filter(ColorMatrixFilter, {  brightness:0.1 });
		}
		
		public function onOut(e:MouseEvent= null):void 
		{
			//eaze(_bg).to(.2, { tint:null } );
			eaze(_bg).to(.2).filter(ColorMatrixFilter, {  brightness:0 });
		}
		
		public function moveToBase(onComplete:Function = null, arg:* = null):void {
			var xp:Number 
			var yp:Number 
			var scale:Number
			trace("original" ,original);
			if (original != null) { // ein clon
				scale = original.container.scaleTarget; //woraufhin 
				xp =  BallContainerContainer(original.container.parent).targetPos.x + original.container.targetPos.x + basePos.x *scale;
				yp = original.container.targetPos.y + basePos.y*scale;;
				
			} else {
				xp = basePos.x;
				yp = basePos.y;
				if (container != null) scale = container.scale;
				else scale = 1;
			}
			parent.addChild(this);
			eaze(this).to(.5, { x:xp, y:yp, scaleX:scale, scaleY:scale } ).easing(Elastic.easeOut).onComplete(onComplete, arg);
		
		}
		
		public function setCurPosAsBase():void {
			basePos = new Point(x, y);
		}
		
		
		public function show(dur:Number = .3):void {
			eaze(this).to(dur, { scaleX:1, scaleY:1 } ).easing(Back.easeOut);
		}
		
		public function hide():void {
			eaze(this).to(.3, { scaleX:0, scaleY:0 } ).easing(Back.easeIn);
		}
		
		public function get text():String {
			
			return _tf.text;
		}
	
		override public function get width():Number {
			return _radius * 2;
		}
		
		public function get radius():int 
		{
			return _radius;
		}
		
		public function get coords():Point 
		{
			return _coords;
		}
		
		public function set coords(value:Point):void 
		{
			_coords = value;
		//	_tf.text = _coords.x + "/" + _coords.y;
		}
		
		public function get inContainer():Boolean 
		{
			return _inContainer;
		}
		
		public function set inContainer(value:Boolean):void 
		{
			_inContainer = value;
		}
		
		public function get isAllowed():Boolean 
		{
			return _isAllowed;
		}
		
		public function set isAllowed(value:Boolean):void 
		{
			_isAllowed = value;
			if (inContainer) {
				var tmpAlpha:Number = value ? 1 : .4;
				if (tmpAlpha != alpha && visible) eaze(this).to(.3, { alpha:tmpAlpha } );
				if (!value) setInteractivity(false);
			}
			//trace("isAllowed", value, _tf.text);
		}
		
		public function setInteractivity(val:Boolean):void {
			//trace("WordBall::setInteractivity()", val,  _tf.text);
			mouseChildren = mouseEnabled  = val;
			buttonMode = val;
			if (val) {
				addEventListener(MouseEvent.MOUSE_OVER, onOver);
				addEventListener(MouseEvent.MOUSE_OUT, onOut);
				
			} else {
				removeEventListener(MouseEvent.MOUSE_OVER, onOver);
				removeEventListener(MouseEvent.MOUSE_OUT, onOut);
				onOut(null)
			}
		}
		
		
		public function get posPoint():Point {
			return new Point(x, y);
			
			
		}
		
		public function get color():uint 
		{
			return _color;
		}
		
		public function set color(value:uint):void 
		{
			_color = value;
		}
		
		public function get colorHighlight():uint 
		{
			return _colorHighlight;
		}
		
		public function set colorHighlight(value:uint):void 
		{
			_colorHighlight = value;
		}
		
		public function set roll(value:Number):void 
		{
			_roll = value;
			
			trace("_roll", _roll);
			var tmpRoll:Number = _roll > .5 ? _roll - 1 : _roll;
			_tf.y = -_tf.height / 2 + (tmpRoll) * _radius*4;
			
		}
		
		public function get roll():Number 
		{
			return _roll;
		}
		
		
		public function get globalPos():Point {
			
			return new Point( 
				BallContainerContainer(container.parent).targetPos.x + container.targetPos.x + basePos.x , 
				 container.targetPos.y + basePos.y 
				 );
			
		}
		
	}

}