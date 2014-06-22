package app.view 
{
	import app.model.Model;
	import app.view.common.ImageBox;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenNano;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author joe
	 */
	public class HeaderSlider extends Sprite 
	{
		private var _images:Array = [];
		private var _interval:Number;
		private var _timer:Timer;
		
		public function HeaderSlider() 
		{
			super();
			
			var m:Shape = new Shape();
			m.graphics.beginFill(0);
			m.graphics.drawRect(0, 0, 1080, 108);
			addChild(m);
			
			mask = m;
			
			for (var i:int = 0; i < 3; i++) 
			{
				var bd:BitmapData = Model.instance.mainSlideImages[i] as BitmapData;
				var image:ImageBox = new ImageBox("header_time" + (i+1));
				image.y = 108 * i;
				addChild(image);
				
				_images.push(image);
			}
			
			_interval = Model.instance.config.rollingInterval.header;
			slide();
		}
		
		private function slide():void
		{
			_timer = new Timer(_interval*1000, 0);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			for (var i:int = 0; i < 2; i++) 
			{
				var image:ImageBox = _images[i];
				if (i == 0)
				{
					TweenNano.to(image, 0.5, { y:(i-1)*108, ease:Cubic.easeInOut, onComplete:onTween} );
				}
				else if(i==1)
				{
					TweenNano.to(image, 0.5, { y:(i-1)*108, ease:Cubic.easeInOut} );
				}
			}
		}
		
		private function onTween():void 
		{
			_images.push(_images.shift());
			
			for (var i:int = 0; i < 3; i++) 
			{
				var image:ImageBox = _images[i];
				image.y = i * 108;
			}
			
		}
		
		
	}

}