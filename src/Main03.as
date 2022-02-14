package 
{
	import aze.motion.eaze;
	import base.events.CustomEvent;
	import base.gui.tooltip.Tooltip;
	import base.text.FontManager;
	import base.xml.XmlLoader;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.Font;
	import flash.utils.getDefinitionByName; 
	import goethe.GoetheColors;
	import gui.frame.Frame;
	import gui.frame.FrameMenu;
	import lt.uza.utils.Global;

	import modules03.mod0301.Mod0301;
	import modules03.mod0302.Mod0302;
	import modules03.mod0303.Mod0303;
	import modules03.mod0304.Mod0304;
	import modules03.mod0305.Mod0305;




	import modules.Module;

	/**
	 * ...
	 * @author andreasmuench.de
	 */
	[Frame(factoryClass="Preloader")]
	public class Main03 extends MainBase {
		
		public function Main03():void 
		{
			MODULE_ID = 3; // 03
			
			STARTSET = 0// 
			
			super();
		}
		
		
		
		override protected function onConfigLoaded(loadedXml:XML):void 
		{
			super.onConfigLoaded(loadedXml);
			
			//startSet_TESTING(STARTSET);
			
		}
		
		
		private function importSymbols():void {
			
			Mod0301
			Mod0302
			Mod0303
			Mod0304
			Mod0305
			
			
		}

		
		

	}

}