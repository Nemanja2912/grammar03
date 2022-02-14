package modules03.mod0305 
{
	import aze.motion.easing.Cubic;
	import aze.motion.eaze;
	import base.events.CustomEvent;
	import base.gui.Padding;
	import base.images.BasicImage;
	import base.text.BasicText;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import goethe.GoetheColors;
	import gui.buttons.TextButton;
	import gui.frame.BtnOpenFrame;
	import gui.frame.Frame;
	import gui.input.specialKeyboard.MobileKeyboard;
	import gui.popIcon.PopIcon;
	import modules.Module;
	import utils.ArrayUtils;
	/**
	 * ...
	 * @author andreasmuench.de
	 */
	public class Mod0305 extends Module
	{
		
		private var _conts:Array = [];
		private var _anims:Array = [];
		private var _texts:Array = [];
		private var _curAnim:Animation;
		private var _curAnimId:int = -1;
		
		
		public function Mod0305(xml:XML) 
		{
			
			super(xml);
			
			var i:int = 0;
			for each(var ax:XML in xml.set[4].animation) {
				
				var cont:Sprite = new Sprite();
				_conts.push(cont);
				
				var ani:Animation = new Animation(ax);
				ani.addEventListener(Animation.ANIMATION_COMPLETE, onAnimComplete);
				ani.name = "Animation " +i;
				ani.x = (MainBase.STAGE_WIDTH - Animation.WIDTH) / 2;
				ani.y = 60;
				ani.id = i;
				_anims.push(ani);
				cont.addChild(ani);
				
				
				var gft:GapFillText = new GapFillText(ax.gapFillText[0]);
				gft.addEventListener(GapFillText.ALL_INPUTS_COMPLETE, onFillTextComplete);
				gft.addEventListener(GapFillText.WRONG_SOLUTION, onFillTextWrong);
				gft.y = ani.y + Animation.HEIGHT + 20;
				gft.x = (MainBase.STAGE_WIDTH - gft.width) / 2;
				_texts.push(gft);
				cont.addChild(gft);
				
				i++;
				
				var boxes:Array = [];
				var boxesWidth:Number = 0;
				for each(var bx:XML in ax.box) {
					var tb:TextButton = new TextButton( { text:bx.toString(), padding:new Padding([2, 2, 2, 2]), boxColor:GoetheColors.GREY_30, fontColor:GoetheColors.GREY } );
					if (bx.@x != undefined) tb.x = int(bx.@x);
					else boxesWidth += tb.width;
					tb.y = gft.y + gft.height + 10;
					tb.interactive = false;
					tb.removeGlow();
					boxes.push(tb);
					cont.addChild(tb);
					
				}
				// anordnen
				boxesWidth += 20* (ax.box.length()-1)
				var xp:Number = (MainBase.STAGE_WIDTH - boxesWidth) / 2;
				for each(var box:TextButton in boxes) {
					if (box.x == 0) {  // nur wenn box noch nicht platziert ist
						box.x = xp;
						xp += box.width + 20;
					}
				}
			}
			
			init();
		}
		

		
	
		private function init():void 
		{

			addHelpButton()
			addInfoButton();
			
			start();
			
		}
		
		
		
		private function start():void {
			showTaskBox(_xml.set[4].task[0],"AUFGABE", activateGapText );

			initAnim(0);
		}
		
	
		
		
		private function initAnim(animId:int):void {
			_curAnimId = animId
			_curAnim = _anims[_curAnimId]
			
			_curAnim.addEventListener(Animation.ANIMATIONS_LOADED, onAnimLoaded)
			_curAnim.loadSwfs();
			
		}
		
		private function onAnimLoaded(e:Event):void 
		{
			startAnim();
			if (_curAnimId > 0) activateGapText(); // nur beim ersten Text erst warten bis task weggedrückt wurde
		}
		
		private function startAnim():void 
		{
			trace(">>>>>>>>>>>>>>>>>>>>> startAnim");
			
			var i:int = 0;
			for each(var ani:Animation in _anims) {
				if (ani.id == _curAnimId) {
					_cont.addChild(_conts[i]);
					//(_texts[i] as GapFillText).setFocus()
					ani.play(0);
				} else {
					if (_cont.contains(_conts[i])) _cont.removeChild(_conts[i]);
					ani.stop();
				}
				i++;
			}

		}
		
		private function activateGapText():void {
			(_texts[_curAnimId] as GapFillText).setFocus()
			
		}
		
		private function onAnimComplete(e:CustomEvent):void 
		{
			var anim:Animation = e.param.anim  as Animation;
			
			//trace("onAnimComplete", anim.id, anim.curAnimId);
			if (anim.curAnimId == 1) { // FALSCH-Ani
				trace("PLAY");
				anim.play(0); // wiedr idle playen
			}
		}
		
		private function onFillTextWrong(e:Event):void 
		{
			(_anims[_curAnimId] as Animation).play(1);
			(_texts[_curAnimId] as GapFillText).markWrongFields();
			_popIcon.show(PopIcon.WRONG, this, MainBase.STAGE_WIDTH, MainBase.STAGE_HEIGHT - 200 );

		}
		
		private function onFillTextComplete(e:Event):void 
		{
			(_texts[_curAnimId] as GapFillText).deactivate();
			var anim:Animation = (_anims[_curAnimId] as Animation);
			anim.play(2)
			anim.removeEventListener(Animation.ANIMATION_COMPLETE, onAnimComplete);
			_popIcon.show(PopIcon.RIGHT, this, MainBase.STAGE_WIDTH, MainBase.STAGE_HEIGHT - 200 );
			if (_curAnimId < _anims.length-1) {
				eaze(this).delay(3).onComplete(function():void { showCustomButton( { hl:"WEITER", onClick:nextAnim , x:800} ) } );;
			} else {
				eaze(this).delay(3).onComplete(function():void { showCustomButton( { hl:"ENDE ", onClick:onClickEndButton , x:800} ) } );;
			}
			dispatchEvent(new CustomEvent(MobileKeyboard.HIDE_KEYS, true));
		}
		
		
		
		private function nextAnim(e:Event = null):void {
			_btnCustom.hide();
			
			initAnim(_curAnimId + 1);
			
		}
		
		
	
		
		
		private function onClickEndButton(e:*):void 
		{
			_popup.show( { hl:_xml.end.headline[0], copy:_xml.end.copy[0] } );
		}



		
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private function ____________________PART2____________________________(e:MouseEvent):void { }
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		

	
		
		
				
		override protected function onHelpButtonClick(e:MouseEvent):void 
		{
			trace("onHelpButtonClick");
			_texts[_curAnimId].help()
			
			
	
		}
		

		
		
		
	}

}