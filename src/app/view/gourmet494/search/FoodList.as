package app.view.gourmet494.search 
{
	import app.model.Model;
	import app.view.common.ImageBox;
	import com.greensock.easing.Linear;
	import com.greensock.TweenNano;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author joe
	 */
	public class FoodList extends Sprite 
	{
		private var _tableBg:ImageBox;
		private var _pagination:Pagination;
		private var _items:Array;
		private var _alert:SearchAlert;
		
		public function FoodList(pagination:Pagination) 
		{
			x = 80;
			y = 383;
			
			_tableBg = new ImageBox("gourmet/search_food_table");
			addChild(_tableBg);
			
			_pagination = pagination;
			_pagination.addEventListener(Pagination.UPDATE, onUpdatePagination);
			
			onUpdatePagination(null);
			
			Model.instance.addEventListener(Model.COMPLETE_SEARCH_FOOD, onSearch);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onSearch(e:Event):void 
		{
			var totalPages:int = Math.floor((Model.instance.searchedFoods.length - 1) / 6) + 1;
			_pagination.update(1, totalPages);
			
			
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			_pagination.removeEventListener(Pagination.UPDATE, onUpdatePagination);
		}
		
		private function onUpdatePagination(e:Event):void 
		{
			var item:FoodItem;
			if (_items != null)
			{
				
				for (var i:int = 0; i < _items.length; i++) 
				{
					item = _items[i];
					removeChild(item);
				}
			}
			
			var startIndex:int = (_pagination.curPage-1) * 6;
			var endIndex:int = startIndex + 6;
			if (endIndex+1 > Model.instance.searchedFoods.length)
			{
				endIndex -= _pagination.curPage * 6 - Model.instance.searchedFoods.length;
			}
			
			_items = [];
			
			for (var j:int = startIndex; j < endIndex; j++) 
			{
				var index:int = j - startIndex;
				item = new FoodItem(Model.instance.searchedFoods[j]);
				
				item.y = 143 * index;
				addChild(item);
				
				item.alpha = 0;
				TweenNano.to(item, 0.3, { alpha:1, ease:Linear.easeNone, delay:index*0.1 } );
				
				_items.push(item);
			}
			
			if (Model.instance.searchedFoods.length == 0)
			{
				if (!_alert)
				{
					_alert = new SearchAlert();
					_alert.x = -80;
					_alert.y = 240 - 108;
					addChild(_alert);
				}
				_alert.open(Model.instance.searchWord);
				_pagination.visible = false;
				_tableBg.visible = false;
			}
			else
			{
				if (_alert)
				{
					_alert.close();
				}
				_pagination.visible = true;
				_tableBg.visible = true;
			}
		}
		
		
		
	}

}