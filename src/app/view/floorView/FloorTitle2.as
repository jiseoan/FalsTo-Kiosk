package app.view.floorView 
{
	import app.model.FloorName;
	import app.text.TextFormatter;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author joe
	 */
	public class FloorTitle2 extends Sprite 
	{
		private var _hallTF:TextField;
		private var _floorTF:TextField;
		private var _categoryTF:TextField;
		
		public function FloorTitle2(hall:String, floor:String, categories:String) 
		{
			super();
			
			_hallTF = new TextField();
			_hallTF.x = 380;
			_hallTF.y = 13;
			_hallTF.width = 110;
			_hallTF.height = 50;
			//_hallTF.border = true;
			TextFormatter.setTextFormat(_hallTF, 0x222222, 40, MyriadPro, "left", false);
			
			_floorTF = new TextField();
			_floorTF.x = 485;
			_floorTF.y = 13;
			_floorTF.width = 100;
			_floorTF.height = 50;
			//_floorTF.border = true;
			TextFormatter.setTextFormat(_floorTF, 0x222222, 40, MyriadProBold, "left", false);
			
			
			_categoryTF = new TextField();
			_categoryTF.y = 62;
			_categoryTF.width = 1080 - 160;
			_categoryTF.height = 50;
			//_categoryTF.border = true;
			TextFormatter.setTextFormat(_categoryTF, 0x222222, 20, MyriadProBold, "center", false);
			
			_hallTF.text = hall;
			_floorTF.text = floor;
			_categoryTF.text = categories;
			
			addChild(_hallTF);
			addChild(_floorTF);
			addChild(_categoryTF);
		}

	}

}