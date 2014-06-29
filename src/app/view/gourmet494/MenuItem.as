package app.view.gourmet494 
{
	import app.model.Food;
	import app.model.Model;
	import app.text.TextFormatter;
	import flash.events.Event;
	/**
	 * ...
	 * @author joe
	 */
	public class MenuItem extends MenuItemAsset 
	{
		private var _food:Food;
		
		public function MenuItem(food:Food) 
		{
			super();
			
			_food = food;
			
			TextFormatter.setTextFormat(nameTF, 0xffffff, 26, null, "left", false);
			TextFormatter.setTextFormat(descTF, 0xb7b7b8, 20, null, "left", true);
			TextFormatter.setTextFormat(priceTF, 0xffffff, 20, YoonGothic135, "left");
			
			nameTF.text = food.data.name[Model.instance.lang];
			descTF.text = food.data.description[Model.instance.lang];
			priceTF.text = food.data.price;
			
			if (_food.image != null)
			{
				addChild(_food.image);
				nameTF.x = 257;
				descTF.x = 257;
				priceTF.x = 257;
				nameTF.width = 580;
				descTF.width = 580;
				priceTF.width = 580;
			}
			
			Model.instance.addEventListener(Model.CHANGE_LANGUAGE, onChangeLanguage);
		}
		
		private function onChangeLanguage(e:Event):void 
		{
			TextFormatter.setTextFormat(nameTF, 0xffffff, 26, null, "left", false);
			TextFormatter.setTextFormat(descTF, 0xb7b7b8, 20, null, "left", true);
			TextFormatter.setTextFormat(priceTF, 0xffffff, 20, YoonGothic135, "left");
			
			nameTF.text = _food.data.name[Model.instance.lang];
			descTF.text = _food.data.description[Model.instance.lang];
			priceTF.text = _food.data.price;
		}
		
	}

}