package app.view.gourmet494 
{
	import app.model.Brand;
	import app.model.Food;
	import app.model.Model;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author joe
	 */
	public class MenuList extends Sprite 
	{
		private var _brand:Brand;
		private var _items:Array = [];
		
		private var _container:Sprite;
		private var _scroller:Scroller;
		
		public function MenuList(brand:Brand) 
		{
			super();
			
			_brand = brand;
			
			_container = new Sprite();
			addChild(_container);
			
			var m:Shape = new Shape();
			m.graphics.beginFill(0);
			m.graphics.drawRect(0, 0, 870, 223*5);
			addChild(m);
			
			_container.mask = m;
			
			
			
			var foods:Array = Model.instance.foods;
			var index:int = 0;
			for (var i:int = 0; i < foods.length; i++) 
			{
				var food:Food = foods[i];
				
				if (food.data.idbrand == brand.data.iditem)
				{
					var item:MenuItem = new MenuItem(food);
					_items.push(item);
					item.y = 223 * index;
					_container.addChild(item);
					
					index++;
				}
			}
			
			var topLine:Shape = new Shape();
			topLine.graphics.beginFill(0x4D4E50);
			topLine.graphics.drawRect(0, 0, 870, 2);
			addChild(topLine);
			
			if (_items.length > 5)
			{
				_scroller = new Scroller(_container, m.height);
				_scroller.x = 880;
				addChild(_scroller);
			}
			
		}
		
	}

}