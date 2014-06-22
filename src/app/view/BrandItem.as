package app.view 
{
	import adobe.utils.CustomActions;
	import app.Application;
	import app.model.Brand;
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
	public class BrandItem extends BrandItemAsset 
	{
		private var _brand:Brand;
		
		private var _detailBtn:Button;
		private var _locationBtn:Button;
		
		public function BrandItem(brand:Brand) 
		{
			_brand = brand;
			
			TextFormatter.setTextFormat(nameTF, 0x333333, 30, MyriadProBold, "center", false);
			TextFormatter.setTextFormat(subNameTF, 0x888888, 20, null, "center", false);
			TextFormatter.setTextFormat(floorTF, 0x6A6162, 20, YoonGothic135, "left");
			TextFormatter.setTextFormat(phoneTF, 0x6A6162, 20, YoonGothic135, "left");
			nameTF.text = _brand.data.name[Language.ENGLISH];
			subNameTF.text = _brand.data.name[Model.instance.lang];
			floorTF.text = _brand.data.hall + "  " +_brand.data.floor;
			phoneTF.text = _brand.data.phone;
			
			subNameTF.x = 137 - subNameTF.width / 2;
			
			_detailBtn = new Button([new ImageBox("btn_detail"), new ImageBox("btn_detail_press")]);
			_locationBtn = new Button([new ImageBox("btn_location"), new ImageBox("btn_location_press") ]);
			
			_detailBtn.x = 0;
			_detailBtn.y = 193;
			
			_locationBtn.x = 142;
			_locationBtn.y = 193;
			
			addChild(_detailBtn);
			addChild(_locationBtn);
			
			_detailBtn.addEventListener(MouseEvent.CLICK, detailBtn_click);
			_locationBtn.addEventListener(MouseEvent.CLICK, locationBtn_click);
			
			Model.instance.addEventListener(Model.CHANGE_LANGUAGE, onChangeLanguage);
			
			TextMaskSlider.setMaskSlider(nameTF);
			TextMaskSlider.setMaskSlider(subNameTF);
			
		}
		
		private function locationBtn_click(e:MouseEvent):void 
		{
			var locationWindow:LocationWindow = new LocationWindow(_brand);
			locationWindow.open();
		}
		
		private function detailBtn_click(e:MouseEvent):void 
		{
			BrandInfoWindow.instance.update(_brand);
			BrandInfoWindow.instance.open();
		}
		
		private function onChangeLanguage(e:Event):void 
		{
			subNameTF.text = _brand.data.name[Model.instance.lang];
			
			TextFormatter.setTextFormat(subNameTF, 0x888888, 20, null, "center", false);
			
			TextMaskSlider.setMaskSlider(subNameTF);
			
		}

		
	}

}