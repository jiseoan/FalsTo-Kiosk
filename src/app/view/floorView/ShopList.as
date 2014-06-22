package app.view.floorView 
{
	import air.desktop.URLFilePromise;
	import app.model.Brand;
	import app.model.FloorName;
	import app.model.Model;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ShopList extends Sprite 
	{
		private var _categoryItems:Array = [];
		private var _shopItems:Array = [];
		
		private var _categoryNames:Array;
		
		private var _container:Sprite;
		private var _scroller:Scroller;
		
		public function ShopList() 
		{
			super();
			
			x = 80;
			y = 948;
			
			_container = new Sprite();
			addChild(_container);
			
			var m:Shape = new Shape();
			m.graphics.beginFill(0);
			m.graphics.drawRect(0, 0, 163+174*4-2, 62*8-2);
			addChild(m);
			
			_container.mask = m;
			
			_scroller = new Scroller(_container, m.height);
			_scroller.x = 870;
			addChild(_scroller);
			
			createItems();
			
			FloorView.instance.addEventListener(FloorView.UPDATE_STATUS, onUpdateStatus);
			
		}
		
		private function onUpdateStatus(e:Event):void 
		{
			update();
		}
		
		private function update():void
		{
			removeItems();
			createItems();
			
			FloorView.instance.dispatchEvent(new Event(FloorView.UPDATE_LIST));
		}
		
		private function createItems():void
		{
			trace( "FloorName.name[FloorView.instance.curFloor] : " + FloorName.name[FloorView.instance.curFloor] );
			_categoryNames = Model.instance.getCategoryNamesByHallFloor(FloorView.instance.curHall, FloorName.name[FloorView.instance.curFloor]);
			var brands:Array = Model.instance.getCategoryBrandsByHallFloor(FloorView.instance.curHall, FloorName.name[FloorView.instance.curFloor]);
			
			var ty:int = 0;	//categoty posY
			
			for (var i:int = 0; i < _categoryNames.length; i++) 
			{
				var cItem:CategoryItem = new CategoryItem(_categoryNames[i]);
				cItem.y = ty;
				_container.addChild(cItem);
				
				var index:int = 0;
				for (var j:int = 0; j < brands.length; j++) 
				{
					var brand:Brand = brands[j];
					if (brand.data.category == _categoryNames[i])
					{
						var sItem:ShopItem = new ShopItem(brand);
						sItem.x = 163 + 174 * (index % 4);
						sItem.y = ty + int(index/4) * 62;
						_container.addChild(sItem);
						
						_shopItems.push(sItem);
						sItem.addEventListener(MouseEvent.CLICK, onClickItem);
						
						index++;
					}
					
				}
				
				ty = sItem.y + 62;
			}
			
			if (_container.height <= 494)
			{
				_scroller.visible = false;
			}
			else
			{
				_scroller.visible = true;
			}
		}
		
		private function onClickItem(e:MouseEvent):void 
		{
			var t:ShopItem = e.currentTarget as ShopItem;
			
			for (var i:int = 0; i < _shopItems.length; i++) 
			{
				var item:ShopItem = _shopItems[i];
				if (t == item)
				{
					item.focus();
					Balloon.instance.update(item.brand);
				}
				else
				{
					item.blur();
				}
			}
		}
		
		private function removeItems():void
		{
			for (var i:int = 0; i < _shopItems.length; i++) 
			{
				var item:ShopItem = _shopItems[i];
				item.removeEventListener(MouseEvent.CLICK, onClickItem);
			}
			
			_shopItems = [];
			
			while (_container.numChildren > 0)
			{
				_container.removeChildAt(0);
			}
			
			_container.y = 0;
			_scroller.handle.y = 0;
		}
		
		public function get categoryNames():Array 
		{
			return _categoryNames;
		}
	}

}