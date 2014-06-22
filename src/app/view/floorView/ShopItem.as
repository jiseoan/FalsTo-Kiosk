package app.view.floorView 
{
	import app.model.Brand;
	import app.model.Language;
	import app.model.Model;
	import app.text.TextFormatter;
	import app.view.common.Button;
	import app.view.common.ImageBox;
	import app.view.common.TextMaskSlider;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ShopItem extends Sprite 
	{
		private var _brand:Brand;
		private var _btn:Button;
		private var _titleTF:TextField;
		private var _phoneTF:TextField;
		
		public function ShopItem(brand:Brand) 
		{
			super();
			
			_brand = brand;
			_btn = new Button([new ImageBox("shop_list_item_bg"), new ImageBox("shop_list_item_bg_press"), new ImageBox("shop_list_item_bg_focus")]);
			addChild(_btn);
			
			_titleTF = new TextField();
			_titleTF.width = 156;
			_titleTF.height = 25;
			_titleTF.x = 13;
			_titleTF.y = 8;
			_titleTF.mouseEnabled = false;
			_titleTF.text = _brand.data.name[Model.instance.lang];
			if(_titleTF.text=="") _titleTF.text = _brand.data.name[Language.ENGLISH];
			//_titleTF.border = true;
			TextFormatter.setTextFormat(_titleTF, 0x777777, 20, null, "left", false);
			addChild(_titleTF);
			
			
			TextMaskSlider.setMaskSlider(_titleTF);
			
			_phoneTF = new TextField();
			_phoneTF.width = 157;
			_phoneTF.height = 20;
			_phoneTF.x = 15;
			_phoneTF.y = 32;
			_phoneTF.mouseEnabled = false;
			_phoneTF.text = _brand.data.phone;
			//_phoneTF.border = true;
			TextFormatter.setTextFormat(_phoneTF, 0xadadab, 15, MyriadProBold);
			addChild(_phoneTF);
			
			Model.instance.addEventListener(Model.CHANGE_LANGUAGE, onChnageLanguage);
		}
		
		private function onChnageLanguage(e:Event):void 
		{
			//removeChild(_titleTF);
			//addChild(_titleTF);
			
			_titleTF.text = _brand.data.name[Model.instance.lang];
			if (_titleTF.text == "") _titleTF.text = _brand.data.name[Language.ENGLISH];
			
			TextFormatter.setTextFormat(_titleTF, 0x777777, 20, null, "left", false);
			
			TextMaskSlider.setMaskSlider(_titleTF);
		}
		
		public function focus():void
		{
			TextFormatter.setTextFormat(_titleTF, 0xffffff, 20, null, "left", false);
			TextFormatter.setTextFormat(_phoneTF, 0xa7a7a7, 15, MyriadProBold);
			_btn.focus();
		}
		
		public function blur():void
		{
			TextFormatter.setTextFormat(_titleTF, 0x777777, 20, null, "left", false);
			TextFormatter.setTextFormat(_phoneTF, 0xadadab, 15, MyriadProBold);
			_btn.up();
		}
		
		public function get brand():Brand 
		{
			return _brand;
		}
		
		public function get btn():Button 
		{
			return _btn;
		}
		
	}

}