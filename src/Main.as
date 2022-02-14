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
	import gui.frame.Frame;
	import gui.frame.FrameMenu;
	import lt.uza.utils.Global;
	import modules.mod01.Mod01;
	import modules.mod02.Mod02;
	import modules.mod03.Mod03;
	import modules.mod0305.Mod0305;
	import modules.mod04.Mod04;





	import modules.Module;

	/**
	 * ...
	 * @author andreasmuench.de
	 */
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite 
	{
		private var global:Global = Global.getInstance();
		private var _configUrl:String = "data/config.xml";
		private var _xml:XML;
		private var _frame:Frame;
		private var _cont:Sprite;
		private var _curSet:int = 0
		private var _tooltip:Tooltip;
		
		private static const STARTSET:int = 0//  zum debuggen, eigentlich 0
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			_tooltip = new Tooltip();
			global.tooltip = _tooltip;
			global.stage = stage;
			//stage.addEventListener(Event.RESIZE, onResize);
			
			//var fm:FontManager = FontManager.getInstance();
			//var embeddedFontClass:Class = getDefinitionByName("Goethe FF Clan") as Class;
			//Font.registerFont(embeddedFontClass);
			//fm.registerFonts(["GoetheFFClanRegular", "GoetheFFClanBold"]);
			// fonts erstellen damit sie embedded sind
			var embedfont:Font = new GoetheFFClanBold();
			embedfont = new GoetheFFClanRegular();
			
			loadConfig();
		}
		
	
		
		private function loadConfig():void {
			
			var loader:XmlLoader = new XmlLoader(_configUrl, onConfigLoaded);
			
		}
		
		private function onConfigLoaded(loadedXml:XML):void 
		{
			_xml = loadedXml;

			_cont = new Sprite(); // modulecontainer
			_cont.addEventListener(Module.NEXT_MODULE, onNextModuleClick);
			_cont.y = Frame.MINI_HEIGHT;
			addChild(_cont);
			
			_frame = new Frame(_xml);
			_frame.addEventListener(Frame.NAVIMODE_SELECTED, onNaviModeSelected);
			_frame.addEventListener(FrameMenu.ELEM_CLICKED, onMenuElementClicked);
			_frame.addEventListener(Frame.HOME, onHome);
			addChild(_frame);
			
			addChild(_tooltip);
			
			//startSet_TESTING(STARTSET); 
	
		
		}
		
		
		private function onNextModuleClick(e:CustomEvent):void 
		{
			startSet (_curSet+1);
		}
		
		
		private function onHome(e:Event):void 
		{
			removeSets();
		}
		
		private function onMenuElementClicked(e:CustomEvent):void 
		{
			trace("MenuElem clicked ", e.param.id);
			//if (e.param
			startSet (e.param.id);
	
		}
		
		private function onNaviModeSelected(e:CustomEvent):void 
		{
			startSet(STARTSET);
			
			
			
		}
		

		private function startSet(id:int):void {
			_curSet = id;
			_frame.startSet(id);
			// nach auffahren erst neues Set starten
			eaze(this).delay(.7).onComplete(addSet);
				
		}
		
		
		private function startSet_TESTING(id:int):void {
			_curSet = id;
			addSet();
			_frame.minimize();
			_frame.mouseChildren = _frame.mouseEnabled = false;
			_frame.alpha = 1//.5;
		}
		
		private function addSet():void {
			
			removeSets();
	
			switch(_curSet) {
				case 0: 
					_cont.addChild(new Mod01(_xml) );
					break;
					
				case 1: 
					_cont.addChild(new Mod02(_xml) );
					break;
				
				case 2: 
					_cont.addChild(new Mod03(_xml) );
					break;
					
				case 3: 
					_cont.addChild(new Mod04(_xml) );
					break;
					
				case 4: 
					_cont.addChild(new Mod0305(_xml) );
					break;
					
				
			}
			
		}
		
		private function removeSets():void 
		{
			while (_cont.numChildren > 0) {
				var tmpMod:Module = _cont.getChildAt(0) as Module;
				tmpMod.destroy();
				_cont.removeChild(tmpMod);
				//  TODO removeEventListeners
			}
		}
		
		
		private function onResize(e:Event = null):void 
		{
			//_cont.graphics.clear();
			//_cont.graphics.beginFill(0xeeffff);
			//_cont.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		}
		
		
		
	}

}