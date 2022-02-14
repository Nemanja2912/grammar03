package modules03.mod0301 
{
	import base.text.BasicText;
	import flash.display.Sprite;
	import goethe.GoetheColors;
	/**
	 * ...
	 * @author 
	 */
	public class InfoBoxFormalInformal extends Sprite
	{
		
		private static const WIDTH:int = 250;
		private static const HEIGHT:int = 80;
		
		public function InfoBoxFormalInformal(formal:Boolean = true) 
		{
			
			graphics.beginFill(GoetheColors.GREEN);
			graphics.drawRoundRectComplex(0, 0, WIDTH, HEIGHT, 20, 20,0,0);
			
			var txt:String = formal ? "Formell<br /><b>Man sagt zur Person „Sie“</b>" : "Informell<br /><b>Man sagt zur Person „du“</b>";
			
			var hl:BasicText = new BasicText( { text:txt , textAlign:"center", fontSize:14, multiline:true, width:WIDTH - 20 } );
			hl.x = 10;
			hl.y = 5
			addChild(hl);
			
		
			var singular:BasicText = new BasicText( { text:"Singular", textAlign:"center", multiline:true,fontSize:14, width:WIDTH / 2 - 20 } );
			singular.x = WIDTH/2 + 10;
			singular.y = 55;
			addChild(singular);
			
			var plural:BasicText = new BasicText( { text:"Plural", textAlign:"center",  multiline:true,fontSize:14, width:WIDTH / 2 - 20  } );
			plural.x = 10;
			plural.y = singular.y;
			addChild(plural);
			
			
		}
		
	}

}