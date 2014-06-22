package app.view 
{
	import app.model.Model;
	import app.view.common.ImageBox;
	import app.view.IView;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author joe
	 */
	public class HomeView extends Sprite implements IView
	{
		private var _header:Header;
		private var _ticker:ShoppingInfoTicker;
		private var _menu:MainMenu;
		private var _imageSlider:ImageSlider;
		
		public function HomeView() 
		{
			super();
			
			_ticker = new ShoppingInfoTicker();
			_ticker.y = 689;
			addChild(_ticker);
			
			_menu = new MainMenu();
			_menu.y = 769;
			addChild(_menu);
			
			_imageSlider = new ImageSlider();
			_imageSlider.y = 108;
			addChild(_imageSlider);
		}
		
		public function updateTicker():void
		{
			removeChild(_ticker);
			
			_ticker = new ShoppingInfoTicker();
			_ticker.y = 689;
			addChild(_ticker);
		}
		
		/* INTERFACE app.view.IView */
		
		public function destroy():void 
		{
			
		}
		
	}

}