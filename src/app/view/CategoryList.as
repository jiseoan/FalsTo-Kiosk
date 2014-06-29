package app.view 
{
	import app.model.Model;
	import app.view.floorView.Scroller;
	import com.greensock.TweenMax;
	import flash.display.BlendMode;
	import flash.display.Shape;
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
		
		private var _container:Sprite;
		private var _scroller:Scroller;
		
		public function CategoryList() 
		{
			super();
			
			_container = new Sprite();
			addChild(_container);
			
			var m:Shape = new Shape();
			m.graphics.beginFill(0);
			m.graphics.drawRect(0, 0, 222*4-8, 74*6-8);
			addChild(m);
			
			_container.mask = m;
			
			_scroller = new Scroller(_container, m.height);
			_scroller.x = 888;
			_scroller.blendMode = BlendMode.MULTIPLY;
			addChild(_scroller);
			
			_categories = Model.instance.getAllCategory();
			
			for (var i:int = 0; i < _categories.length; i++) 
			{
				var category:String = _categories[i];
				var item:CategoryItem = new CategoryItem(category);
				item.x = 222 * (i%4);
				item.y = 74 * int(i / 4);
				_container.addChild(item);
				item.addEventListener(MouseEvent.CLICK, onClick);
				
				_items.push(item);
			}
			
			if (_container.height <= _container.mask.height)
			{
				_scroller.visible = false;
			}
			else
			{
				_scroller.visible = true;
			}
		}
		
		private function onClick(e:MouseEvent):void 
		{
			var item:CategoryItem = e.currentTarget as CategoryItem;
			
			SearchWindow(parent).close();
			
			TweenMax.delayedCall(0.5, Model.instance.searchByCategory, [item.category]);
		}
		
	}

}