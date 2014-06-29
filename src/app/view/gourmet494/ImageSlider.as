package app.view.gourmet494 
{
	import app.model.Model;
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
	public class ImageSlider extends Sprite 
	{
		private var _images:Array = [];
		private var _interval:Number;
		private var _timer:Timer;
		
		public function ImageSlider() 
		{
			super();
			
			var m:Shape = new Shape();
			m.graphics.beginFill(0);
			m.graphics.drawRect(0, 0, 1080, 711);
			addChild(m);
			
			mask = m;
			
			for (var i:int = 0; i < Model.instance.gourmetSlideImages.length; i++) 
			{
				var bd:BitmapData = Model.instance.gourmetSlideImages[i] as BitmapData;
				var image:Bitmap = new Bitmap(bd, "auto", true);
				image.width = 1080;
				image.height = 711;
				image.x = 1080 * i;
				addChild(image);
				
				_images.push(image);
			}
			
			if (Model.instance.gourmetSlideImages.length > 1)
			{
				_interval = Model.instance.config.rollingInterval.imageSlider;
				slide();
			}
		}
		
		private function slide():void
		{
			_timer = new Timer(_interval*1000, 0);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
			
			Model.instance.addEventListener(Model.UPDATE_GOURMET_MODE, onUpdateMode);
		}
		
		private function onUpdateMode(e:Event):void 
		{
			if (Model.instance.gourmetMode == 0)
			{
				_timer.start();
			}
			else
			{
				_timer.stop();
			}
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			if (Model.instance.gourmetMode !=0) return;
			
			for (var i:int = 0; i < 2; i++) 
			{
				var image:Bitmap = _images[i];
				if (i == 0)
				{
					TweenNano.to(image, 0.7, { x:(i-1)*1080, ease:Cubic.easeInOut, onComplete:onTween} );
				}
				else if(i==1)
				{
					TweenNano.to(image, 0.7, { x:(i-1)*1080, ease:Cubic.easeInOut} );
				}
			}
		}
		
		private function onTween():void 
		{
			_images.push(_images.shift());
			
			for (var i:int = 0; i < _images.length; i++) 
			{
				var image:Bitmap = _images[i];
				image.x = i * 1080;
			}
			
		}
		
	}

}