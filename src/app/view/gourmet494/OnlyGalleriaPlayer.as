package app.view.gourmet494 
{
	import app.view.common.ImageBox;
	import app.view.common.ImageBox2;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.TweenNano;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author joe
	 */
	public class OnlyGalleriaPlayer extends Sprite 
	{
		public static const HIDE:String = "hide";
		
		private var _items:Array;
		private var _footer:Sprite;
		private var _footerBg:Sprite;
		private var _index:int;
		private var _container:Sprite;
		private var _curImage:ImageBox2;
		private var _nextImage:ImageBox2;
		
		public function OnlyGalleriaPlayer(items:Array) 
		{
			super();
			
			var m:Shape = new Shape();
			m.graphics.beginFill(0);
			m.graphics.drawRect(0, 0, 920, 1085);
			addChild(m);
			
			mask = m;
			
			_items = items;
			
			_container = new Sprite();
			addChild(_container);
			
			for (var i:int = 0; i < _items.length; i++) 
			{
				var item:ImageBox2 = _items[i];
				item.mouseEnabled = false;
				item.mouseChildren = false;
			}
			
			createFooter();
		}
		
		private function createFooter():void
		{
			_footer = new Sprite();
			_footer.y = 1085;
			addChild(_footer);
			
			_footerBg = new Sprite();
			_footerBg.graphics.beginFill(0);
			_footerBg.graphics.drawRect(0, 0, 920, 100);
			_footerBg.alpha = 0.6;
			_footer.addChild(_footerBg);
			
			_footerBg.addEventListener(MouseEvent.CLICK, onClickCloseBtn);
			_footerBg.addEventListener(MouseEvent.MOUSE_DOWN, onDownCloseBtn);
			
			var closeText:ImageBox = new ImageBox("gourmet/alert_close");
			closeText.mouseEnabled = false;
			closeText.x = 920 / 2 - int(closeText.width / 2);
			_footer.addChild(closeText);
			
			var prevBtn:ImageBox = new ImageBox("gourmet/btn_prev_white");
			_footer.addChild(prevBtn);
			
			var nextBtn:ImageBox = new ImageBox("gourmet/btn_next_white");
			nextBtn.x = 920 - 100;
			_footer.addChild(nextBtn);
			
			
			prevBtn.addEventListener(MouseEvent.CLICK, onClickPrevBtn);
			nextBtn.addEventListener(MouseEvent.CLICK, onClickNextBtn);
		}
		
		private function onClickPrevBtn(e:MouseEvent):void 
		{
			_index--;
			if (_index < 0)
			{
				_index = _items.length-1;
			}
			_nextImage = _items[_index];
			_nextImage.x = -920;
			_container.addChild(_nextImage);
			
			TweenNano.to(_container, 0.4, { x:920, delay:0.1, onComplete:onTween} );
		}
		
		private function onClickNextBtn(e:MouseEvent):void 
		{
			_index++;
			if (_index > _items.length-1)
			{
				_index = 0;
			}
			_nextImage = _items[_index];
			_nextImage.x = 920;
			_container.addChild(_nextImage);
			
			TweenNano.to(_container, 0.4, { x:-920, delay:0.1, onComplete:onTween} );
		}
		
		private function onTween():void 
		{
			_nextImage.x = 0;
			_container.addChild(_nextImage);
			_container.removeChild(_curImage);
			_container.x = 0;
			
			_curImage = _nextImage;
			
		}
		
		
		private function onDownCloseBtn(e:MouseEvent):void 
		{
			_footerBg.alpha = 0.9;
		}
		
		private function onClickCloseBtn(e:MouseEvent):void 
		{
			_footerBg.alpha = 0.6;
			hide();
		}
		
		public function show(id:int):void
		{
			_index = id;
			_curImage = _items[_index];
			_container.addChild(_curImage);
			
			_curImage.alpha = 0;
			TweenNano.to(_curImage, 0.3, { alpha:1, delay:0.05, ease:Linear.easeNone});
			TweenNano.to(_footer, 0.3, { y:985, delay:0.4});
		}
		
		public function hide():void
		{
			parent.removeChild(this);
			
			for (var i:int = 0; i < _container.numChildren; i++) 
			{
				_container.removeChildAt(0);
			}
			
			_footer.y = 1085;
			
			dispatchEvent(new Event(OnlyGalleriaPlayer.HIDE));
		}
		
		public function get index():int 
		{
			return _index;
		}
	}

}