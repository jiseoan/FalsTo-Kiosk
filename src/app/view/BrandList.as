package app.view 
{
	import app.model.Model;
	import app.view.common.ImageBox;
	import app.view.common.Pagination;
	import com.greensock.TweenNano;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author joe
	 */
	public class BrandList extends Sprite 
	{
		private var _pagination:Pagination;
		private var _items:Array;
		private var _alert:SearchAlert;
		
		public function BrandList(pagination:Pagination) 
		{
			x = 80;
			y = 300;
			_pagination = pagination;
			_pagination.addEventListener(Pagination.UPDATE, onUpdatePagination);
			
			onUpdatePagination(null);
			
			Model.instance.addEventListener(Model.COMPLETE_SEARCH, onSearch);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onSearch(e:Event):void 
		{
			var totalPages:int = Math.floor((Model.instance.searchedBrands.length - 1) / 9) + 1;
			_pagination.update(1, totalPages);
			
			
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			_pagination.removeEventListener(Pagination.UPDATE, onUpdatePagination);
		}
		
		private function onUpdatePagination(e:Event):void 
		{
			var item:BrandItem;
			if (_items != null)
			{
				
				for (var i:int = 0; i < _items.length; i++) 
				{
					item = _items[i];
					removeChild(item);
				}
			}
			
			var startIndex:int = (_pagination.curPage-1) * 9;
			var endIndex:int = startIndex + 9;
			if (endIndex+1 > Model.instance.searchedBrands.length)
			{
				endIndex -= _pagination.curPage * 9 - Model.instance.searchedBrands.length;
			}
			
			_items = [];
			
			for (var j:int = startIndex; j < endIndex; j++) 
			{
				var index:int = j - startIndex;
				item = new BrandItem(Model.instance.searchedBrands[j]);
				item.alpha = 0;
				
				item.x = 322 * (index % 3);
				item.y = 305 * int(index / 3);
				addChild(item);
				
				var oy:int = item.y;
				item.y += 50;
				TweenNano.to(item, 0.3, { y:oy, alpha:1, delay:Math.floor(index/2)*0.1 } );
				
				_items.push(item);
			}
			
			if (Model.instance.searchedBrands.length == 0)
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
			}
			else
			{
				if (_alert)
				{
					_alert.close();
				}
				_pagination.visible = true;
			}
		}
		
		
		
	}

}