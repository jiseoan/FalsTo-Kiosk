package app.view.floorView 
{
	import app.model.Brand;
	import app.model.Language;
	import app.model.Model;
	import app.text.TextFormatter;
	import app.view.common.Button;
	import app.view.common.ImageBox;
	import app.view.common.TextMaskSlider;
	import app.view.window.BrandInfoWindow;
	import com.greensock.easing.Back;
	import com.greensock.TweenMax;
	import com.greensock.TweenNano;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author joe
	 */
	public class Balloon extends Sprite 
	{
		private static var _instance:Balloon;
		
		private var _brand:Brand;
		private var _titleTF:TextField;
		private var _phoneTF:TextField;
		private var _btn:Button;
		private var _timer:Timer;
		
		public function Balloon() 
		{
			super();
			
			_btn = new Button([new ImageBox("map_icon_activation"), new ImageBox("map_icon_activation_click")]);
			_btn.x = -136;
			_btn.y = -121;
			addChild(_btn);
			
			_titleTF = new TextField();
			_titleTF.width = 215;
			_titleTF.height = 30;
			_titleTF.x = 23 + _btn.x;
			_titleTF.y = 27 + _btn.y;
			_titleTF.mouseEnabled = false;
			
			//_titleTF.border = true;
			TextFormatter.setTextFormat(_titleTF, 0xffffff, 24, null);
			addChild(_titleTF);
			
			_phoneTF = new TextField();
			_phoneTF.width = 200;
			_phoneTF.height = 20;
			_phoneTF.x = 25 + _btn.x;
			_phoneTF.y = 60 + _btn.y;
			_phoneTF.alpha = 0.5;
			_phoneTF.mouseEnabled = false;
			
			//_phoneTF.border = true;
			TextFormatter.setTextFormat(_phoneTF, 0xffffff, 17, MyriadProBold);
			addChild(_phoneTF);
			
			addEventListener(MouseEvent.CLICK, click);
			
			Model.instance.addEventListener(Model.CHANGE_LANGUAGE, onChnageLanguage);
		}
		
		private function onChnageLanguage(e:Event):void 
		{
			if (_brand)
			{
				_titleTF.text = _brand.data.name[Model.instance.lang];
				if (_titleTF.text == "") _titleTF.text = _brand.data.name[Language.ENGLISH];
			}
			TextFormatter.setTextFormat(_titleTF, 0xffffff, 24, null, "left", false);

			TextMaskSlider.setMaskSlider(_titleTF);
		}

		
		private function click(e:MouseEvent):void 
		{
			BrandInfoWindow.instance.update(_brand);
			BrandInfoWindow.instance.open();
		}
		
		public function update(brand:Brand):void
		{
			if(FloorView.instance.contains(this))FloorView.instance.removeChild(this);
			
			_brand = brand;
			_titleTF.text = _brand.data.name[Model.instance.lang];
			if (_titleTF.text == "") _titleTF.text = _brand.data.name[Language.ENGLISH];
			TextFormatter.setTextFormat(_titleTF, 0xffffff, 24, null, "left", false);
			
			_titleTF.x = 23 + _btn.x;
			_titleTF.mask = null;
			
			TextMaskSlider.setMaskSlider(_titleTF);
			
			_phoneTF.text = _brand.data.phone;
			
			var _offsetX:int = 45;
			var _offsetY:int = 113;
			var tx:Number = FloorView.instance.mapView.x + _offsetX + _brand.data.position.x;
			var ty:Number = FloorView.instance.mapView.y + _offsetY + _brand.data.position.y;
			x = tx;
			y =  ty+ 100;
			alpha = 0;
			
			TweenMax.to(this, 0.3, { autoAlpha:1, y:ty, ease:Back.easeOut } );
			
			FloorView.instance.addChild(this);
			
			startTimer();
		}
		
		private function startTimer():void
		{
			stopTimer();
			
			_timer = new Timer(3000, 1);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
			
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			TweenMax.to(this, 0.3, { autoAlpha:0 } );
		}
		
		private function stopTimer():void
		{
			if (_timer)
			{
				_timer.reset();
				_timer.removeEventListener(TimerEvent.TIMER, onTimer);
				_timer = null;
			}
		}
		
		public function update2(brand:Brand, map:Map):void
		{
			_brand = brand;
			_titleTF.text = _brand.data.name[Model.instance.lang];
			if (_titleTF.text == "") _titleTF.text = _brand.data.name[Language.ENGLISH];
			TextFormatter.setTextFormat(_titleTF, 0xffffff, 24, null);
			
			_phoneTF.text = _brand.data.phone;
			
			var tx:Number = _brand.data.position.x;
			var ty:Number = _brand.data.position.y;
			x = tx;
			y =  ty+ 100;
			alpha = 0;
			
			TweenNano.to(this, 0.3, { alpha:1, y:ty, ease:Back.easeOut } );
			
			map.addChild(this);
		}
		
		public function destory():void
		{
			_instance = null;
		}
		
		static public function get instance():Balloon 
		{
			if (_instance == null)
			{
				_instance = new Balloon();
			}
			
			return _instance;
		}
	}

}