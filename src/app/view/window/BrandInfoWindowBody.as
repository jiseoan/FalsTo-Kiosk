package app.view.window 
{
	import app.Application;
	import app.model.Brand;
	import app.model.Model;
	import app.text.TextFormatter;
	import app.view.common.Button;
	import app.view.common.ImageBox;
	import app.view.common.TextMaskSlider;
	import app.view.floorView.FloorView;
	import app.view.floorView.LocationWindow;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author joe
	 */
	public class BrandInfoWindowBody extends BrandInfoWindowAsset 
	{
		
		private var _brand:Brand;
		private var _btn:Button;
		private var _scroller:Scroller;
		
		public function BrandInfoWindowBody() 
		{
			super();

			var title:ImageBox = new ImageBox("brand_info", true);
			addChildAt(title, 0);
			
			_btn = new Button([new ImageBox("btn_location_big"), new ImageBox("btn_location_big_press")]);
			_btn.x = pos.x;
			_btn.y = pos.y;
			addChild(_btn);
			
			
			
			thumbContainer.visible = false;
			
			_scroller = new Scroller(descTF, textMask.height);
			_scroller.x = 720;
			_scroller.y = 661;
			addChild(_scroller);
			
			_btn.addEventListener(MouseEvent.CLICK, onClick);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			TextMaskSlider.setMaskSlider(nameTF1);
			TextMaskSlider.setMaskSlider(nameTF2);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			var locationWindow:LocationWindow = new LocationWindow(_brand);
			locationWindow.open();
		}
		
		public function update(brand:Brand):void
		{
			_brand = brand;
			
			TextFormatter.setTextFormat(nameTF1, 0x222222, 45, MyriadProBold, "left", false);
			TextFormatter.setTextFormat(nameTF2, 0x888888, 26, null, "left", false);
			TextFormatter.setTextFormat(floorTF, 0x888888, 26, null);
			TextFormatter.setTextFormat(categoryTF, 0x888888, 26, null);
			TextFormatter.setTextFormat(phoneTF, 0x888888, 26, null);
			TextFormatter.setTextFormat(descTF, 0x777777, 20, null);
			descTF.autoSize = TextFieldAutoSize.LEFT;
			
			nameTF1.text = brand.data.name["eng"];
			nameTF2.text = brand.data.name[Model.instance.lang];
			floorTF.text = brand.data.hall + " " + brand.data.floor;
			categoryTF.text = brand.data.category;
			phoneTF.text = brand.data.phone;
			descTF.text= brand.data.description[Model.instance.lang];
			
			if (brand.image.bitmapData == null)
			{
				thumbContainer.visible = false;
			}
			else
			{
				if (thumbContainer.numChildren > 1) thumbContainer.removeChildAt(0);
				thumbContainer.addChildAt(brand.image, 0);
				thumbContainer.visible = true;
			}
			
			if (descTF.textHeight < textMask.height)
			{
				_scroller.visible = false;
			}
			else
			{
				_scroller.y = 661;
				_scroller.visible = true;
				_scroller.reset();
			}
			
			descTF.y = 661;
		}
		
		
	}

}