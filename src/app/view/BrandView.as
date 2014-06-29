
package app.view 
{
	import app.model.Language;
	import app.model.Model;
	import app.view.common.ImageBox;
	import app.view.common.Pagination;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author joe
	 */
	public class BrandView extends Sprite implements IView 
	{
		//private var _brandList:BrandList;
		//private var _textFilter:TextFilter;
		
		private var _pagination:Pagination;
		private var _searchWindow:SearchWindow;
		private var _brandList:BrandList;
		private var _alert:ImageBox;
		
		public function BrandView() 
		{
			var m:Shape = new Shape();
			m.graphics.beginFill(0);
			m.graphics.drawRect(0, 0, 1080, 1600);
			addChild(m);
			
			mask = m;
			
			var title:ImageBox = new ImageBox("title_brand_search", true);
			addChild(title);
			
			_searchWindow = new SearchWindow();
			_searchWindow.y = 420;
			addChild(_searchWindow);
			
			
			Model.instance.addEventListener(Model.COMPLETE_SEARCH, onSearch);
		}
		
		private function onSearch(e:Event):void 
		{
			if (_brandList == null)
			{
				var totalPages:int = Math.floor((Model.instance.searchedBrands.length - 1) / 9) + 1;
				_pagination = new Pagination(totalPages);
				_pagination.y = 1230;
				addChild(_pagination);
				
				_brandList = new BrandList(_pagination);
				addChild(_brandList);
				
				addChild(_searchWindow);
				//Model.instance.removeEventListener(Model.COMPLETE_SEARCH, onSearch);
			}
		}

		
		/* INTERFACE app.view.IView */
		
		public function destroy():void 
		{
			
		}
		
	}

}