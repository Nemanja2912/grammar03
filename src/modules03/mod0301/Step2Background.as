package modules03.mod0301 
{
	import base.text.BasicText;
	import flash.display.Sprite;
	import goethe.GoetheColors;
	/**
	 * ...
	 * @author 
	 */
	public class Step2Background extends Sprite
	{
		
		private var _infoBoxFormal:InfoBoxFormalInformal ;
		private var _infoBoxInformal:InfoBoxFormalInformal
		
		public function Step2Background() 
		{
			
			
			graphics.beginFill(GoetheColors.GREY_30, 1);

			var bgCorner:int = 20;
			var bgy:int = Mod0301.S2BOX_Y;
			
			var fontColor:uint = 0xe2e2e2;
			
			graphics.drawRoundRect(Mod0301.S2BOX_X, bgy, Mod0301.S2BOX_WIDTH, Mod0301.S2BOX_HEIGHT, bgCorner, bgCorner);
			var tf1:BasicText = new BasicText( { text:"<b>Informell Singular</b>", fontColor:fontColor, fontSize:44 } );
			tf1.x = 50+(Mod0301.S2BOX_WIDTH-tf1.width)/2
			tf1.y = bgy + (Mod0301.S2BOX_HEIGHT - tf1.height) / 2;
			addChild(tf1);
			bgy += Mod0301.S2BOX_HEIGHT + Mod0301.S2BOX_PADDING1;
			
			graphics.drawRoundRect(Mod0301.S2BOX_X, bgy, Mod0301.S2BOX_WIDTH, Mod0301.S2BOX_HEIGHT, bgCorner, bgCorner);
			var tf2:BasicText = new BasicText( { text:"<b>Informell Plural</b>", fontColor:fontColor, fontSize:44 } );
			tf2.x = 50+(Mod0301.S2BOX_WIDTH-tf2.width)/2
			tf2.y = bgy + (Mod0301.S2BOX_HEIGHT - tf2.height) / 2;
			addChild(tf2);
			bgy += Mod0301.S2BOX_HEIGHT + Mod0301.S2BOX_PADDING2;
			
			graphics.drawRoundRect(Mod0301.S2BOX_X, bgy, Mod0301.S2BOX_WIDTH, Mod0301.S2BOX_HEIGHT, bgCorner, bgCorner);
			var tf3:BasicText = new BasicText( { text:"<b>Formell Singular</b>", fontColor:fontColor, fontSize:44 } );
			tf3.x = 50+(Mod0301.S2BOX_WIDTH-tf3.width)/2
			tf3.y = bgy + (Mod0301.S2BOX_HEIGHT - tf3.height) / 2;
			addChild(tf3);
			bgy += Mod0301.S2BOX_HEIGHT + Mod0301.S2BOX_PADDING1
			
			graphics.drawRoundRect(Mod0301.S2BOX_X, bgy, Mod0301.S2BOX_WIDTH, Mod0301.S2BOX_HEIGHT, bgCorner, bgCorner);
			var tf4:BasicText = new BasicText( { text:"<b>Formell Plural</b>", fontColor:fontColor, fontSize:44 } );
			tf4.x = 50+(Mod0301.S2BOX_WIDTH-tf4.width)/2
			tf4.y = bgy + (Mod0301.S2BOX_HEIGHT - tf4.height) / 2;
			addChild(tf4);
			
		
			
			_infoBoxFormal = new InfoBoxFormalInformal();
			_infoBoxFormal.x = 20
			_infoBoxFormal.y = 350 + _infoBoxFormal.width;
			_infoBoxFormal.rotation = -90;
			addChild(_infoBoxFormal);
			
			_infoBoxInformal = new InfoBoxFormalInformal(false);
			_infoBoxInformal.x = _infoBoxFormal.x;
			_infoBoxInformal.y = 60 + _infoBoxInformal.width;
			_infoBoxInformal.rotation = -90;
			addChild(_infoBoxInformal);
			
		}
		
	}

}