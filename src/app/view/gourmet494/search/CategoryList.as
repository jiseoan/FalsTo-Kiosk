package app.view.gourmet494.search 
{
	import app.model.Model;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author joe
	 */
	public class CategoryList extends Sprite 
	{
		private var _categories:Array;
		private var _items:Array = [];
		
		public function CategoryList() 
		{
			super();
			
			_categories = Model.instance.getAllFoodCategory();
			
			for (var i:int = 0; i < _categories.length; i++) 
			{
				var category:String = _categories[i];
				var item:CategoryItem = new CategoryItem(category);
				item.x = 222 * (i%4);
				item.y = 74 * int(i / 4);
				addChild(item);
				item.addEventListener(MouseEvent.CLICK, onClick);
				
				_items.push(item);
				
				
			}
			
		}
		
		private function onClick(e:MouseEvent):void 
		{
			var item:CategoryItem = e.currentTarget as CategoryItem;
			
			SearchWindow(parent).close();
			
			TweenMax.delayedCall(0.5, Model.instance.searchFoodsByCategory, [item.category]);
		}
		
	}

}