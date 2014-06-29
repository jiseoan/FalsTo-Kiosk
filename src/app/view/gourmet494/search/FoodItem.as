package app.view.gourmet494.search 
{
	import adobe.utils.CustomActions;
	import app.Application;
	import app.model.Brand;
	import app.model.Food;
	import app.model.Language;
	import app.model.Model;
	import app.text.TextFormatter;
	import app.view.common.Button;
	import app.view.common.ImageBox;
	import app.view.common.TextMaskSlider;
	import app.view.floorView.LocationWindow;
	import app.view.window.BrandInfoWindow;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author joe
	 */
	public class FoodItem extends FoodItemAsset 
	{
		private var _food:Food;
		private var _brand:Brand;
		
		public function FoodItem(food:Food) 
		{
			_food = food;
			_brand = Model.instance.getBrandById(food.data.idbrand);
			
			TextFormatter.setTextFormat(titleTF, 0xffffff, 26, null, "left", false);
			TextFormatter.setTextFormat(descTF, 0xB7B7B8, 20, null, "left", true);
			TextFormatter.setTextFormat(priceTF, 0xffffff, 20, YoonGothic135, "right", false);
			TextFormatter.setTextFormat(brandTF, 0xB7B7B8, 18, null, "center");
			titleTF.text = _food.data.name[Model.instance.lang];
			descTF.text = _food.data.description[Model.instance.lang];
			priceTF.text = _food.data.price;
			brandTF.text = _brand.data.name[Model.instance.lang];
			
			TextMaskSlider.setMaskSlider(titleTF);
			TextMaskSlider.setMaskSlider(priceTF);
			TextMaskSlider.setMaskSlider(brandTF);
			
			brandBtn.addEventListener(MouseEvent.CLICK, onClickBrandBtn);
			
			Model.instance.addEventListener(Model.CHANGE_LANGUAGE, onChangeLanguage);
			
		}
		
		private function onClickBrandBtn(e:MouseEvent):void 
		{
			BrandInfoWindow.instance.update(_brand);
			BrandInfoWindow.instance.open();
		}
		
		private function onChangeLanguage(e:Event):void 
		{
			TextFormatter.setTextFormat(titleTF, 0xffffff, 26, null, "left", false);
			TextFormatter.setTextFormat(descTF, 0xB7B7B8, 20, null, "left", true);
			TextFormatter.setTextFormat(priceTF, 0xffffff, 20, YoonGothic135, "right", false);
			TextFormatter.setTextFormat(brandTF, 0xB7B7B8, 18, null, "center");
			
			titleTF.text = _food.data.name[Model.instance.lang];
			descTF.text = _food.data.description[Model.instance.lang];
			priceTF.text = _food.data.price;
			brandTF.text = _brand.data.name[Model.instance.lang];
			
			TextMaskSlider.setMaskSlider(titleTF);
			TextMaskSlider.setMaskSlider(priceTF);
			TextMaskSlider.setMaskSlider(brandTF);
		}

		
	}

}