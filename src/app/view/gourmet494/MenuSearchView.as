package app.view.gourmet494 
{
	import app.model.Model;
	import app.view.common.ImageBox;
	import app.view.gourmet494.search.FoodList;
	import app.view.gourmet494.search.Pagination;
	import app.view.gourmet494.search.SearchWindow;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author joe
	 */
	public class MenuSearchView extends Sprite 
	{
		private var _pagination:Pagination;
		private var _searchWindow:SearchWindow;
		private var _foodList:FoodList;
		//private var _alert:ImageBox;
		
		public function MenuSearchView() 
		{
			super();
			
			var title:ImageBox = new ImageBox("gourmet/title_menu_search", true);
			title.y = 110;
			addChild(title);
			
			_searchWindow = new SearchWindow();
			_searchWindow.y = 530;
			addChild(_searchWindow);
			
			
			Model.instance.addEventListener(Model.COMPLETE_SEARCH_FOOD, onSearch);
		}
		
		private function onSearch(e:Event):void 
		{
			if (_foodList == null)
			{
				var totalPages:int = Math.floor((Model.instance.searchedFoods.length - 1) / 6) + 1;
				_pagination = new Pagination(totalPages);
				_pagination.y = 1276;
				addChild(_pagination);
				
				_foodList = new FoodList(_pagination);
				addChild(_foodList);
				
				addChild(_searchWindow);
			}
		}

	}

}