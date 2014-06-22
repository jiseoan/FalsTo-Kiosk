package app.view 
{
	import app.Application;
	import app.model.Model;
	import app.view.floorView.FloorView;
	import com.greensock.TweenMax;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Content extends Sprite 
	{
		private var _curView:IView;
		private var _menu:Menu;
		
		public function Content() 
		{
			super();
			
			y = 108;
			
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0xFFFFFF);
			bg.graphics.drawRect(0, 0, 1080, 1744);
			addChild(bg);
			
			_menu = new Menu();
			addChild(_menu);
		}
		
		public function changeView(mode:int):void
		{
			if (mode == 6)
			{
				Application.instance.langWindow.open();
				return;
			}
			
			
			var nextView:IView;
			
			if 		(mode == 1) nextView = new FloorView() as IView;
			else if (mode == 2) nextView = new ServiceView() as IView;
			else if (mode == 3) nextView = new BrandView() as IView;
			else if (mode == 4) nextView = new RankingView() as IView;
			else if (mode == 5) nextView = new ShoppingInfoView() as IView;
			
			
			
			if (_curView) 
			{
				_curView.destroy();
				if (contains(_curView as DisplayObject))  removeChild(_curView as Sprite);
			}
			_curView = nextView;
			addChild(_curView as Sprite);
			

			
			
		}
		
		public function get curView():IView 
		{
			return _curView;
		}
		
		public function get menu():Menu 
		{
			return _menu;
		}
	}

}