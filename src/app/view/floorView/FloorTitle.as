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
	public class FloorTitle extends Sprite 
	{
		private var _floorTF:TextField;
		private var _categoryTF:TextField;
		
		public function FloorTitle() 
		{
			super();
			
			_floorTF = new TextField();
			_floorTF.y = 13;
			_floorTF.width = 1080 - 160;
			_floorTF.height = 50;
			//_floorTF.border = true;
			TextFormatter.setTextFormat(_floorTF, 0x222222, 40, MyriadProBold, "center", false);
			
			
			_categoryTF = new TextField();
			_categoryTF.y = 62;
			_categoryTF.width = 1080 - 160;
			_categoryTF.height = 50;
			//_categoryTF.border = true;
			TextFormatter.setTextFormat(_categoryTF, 0x222222, 20, MyriadProBold, "center", false);
			
			
			addChild(_floorTF);
			addChild(_categoryTF);
			
			
			FloorView.instance.addEventListener(FloorView.UPDATE_STATUS, update);
			FloorView.instance.addEventListener(FloorView.UPDATE_LIST, updateCategory);
		}
		
		private function updateCategory(e:Event):void 
		{
			_categoryTF.text = FloorView.instance.shopList.categoryNames.join("  /  ");
		}
		
		private function update(e:Event):void 
		{
			_floorTF.text = FloorName.name[FloorView.instance.curFloor];
			
		}
		
	}

}