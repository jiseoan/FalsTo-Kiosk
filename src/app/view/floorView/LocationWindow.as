package app.view.floorView 
{
	import app.model.Brand;
	import app.model.FloorName;
	import app.model.Model;
	import app.view.common.ImageBox;
	import app.view.common.Window;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author joe
	 */
	public class LocationWindow extends Window 
	{
		private var _keys1:Array = ["map_WEST1_B1F", "map_WEST2_1F", "map_WEST3_2F", "map_WEST4_3F", "map_WEST5_4F", "map_WEST6_5F"];
		private var _keys2:Array = ["map_EAST1_B1F", "map_EAST2_1F", "map_EAST3_2F", "map_EAST4_3F", "map_EAST5_4F"];
		private var _brand:Brand;
		private var _map1:LocationMap;
		private var _map2:LocationMap;
		
		public function LocationWindow(brand:Brand) 
		{
			var h:int;
			if (brand.data.hall == Model.instance.config.hall && brand.data.floor == Model.instance.config.floor)
			{
				h = 930;
			}
			else
			{
				h = 1359;
			}
			
			super(1020, h, false);
			
			_brand = brand;
			
			var keys:Object = { "WEST":_keys1, "EAST":_keys2};
			
			var bg:ImageBox;
			var hall:String = Model.instance.config.hall;
			var floor:String = Model.instance.config.floor;
			
			var destination:MovieClip;
			
			if ( _brand.data.position)	//매장일때
			{
				destination = new DestinationIndicatorAsset() as MovieClip;
				destination.x = _brand.data.position.x;
				destination.y = _brand.data.position.y;
				
				var here:ImageBox = new ImageBox("destination", true);
				here.x = -Math.round(here.width / 2);
				here.y = -here.height;
				destination.icon.addChild(here);
			}
			else	//편의시설일때
			{
				destination = new MapIconsAsset() as MovieClip;
				destination.gotoAndStop(FloorName.name.indexOf(_brand.data.floor)+1);
				
				for (var i:int = 0; i < destination.numChildren; i++) 
				{
					var icon:MovieClip = destination.getChildAt(i) as MovieClip;
					if (int(icon.name.substr(4, 2)) != _brand.data.id)
					{
						icon.visible = false;
						MovieClip(icon.getChildAt(0)).stop();
					}

				}
				
			}
			
			
			if (brand.data.hall == Model.instance.config.hall && brand.data.floor == Model.instance.config.floor)
			{
				bg = new ImageBox("map_back_location_info1");
				addChild(bg);
				
				_map1 = new LocationMap(keys[hall][FloorName.name.indexOf(floor)], hall, floor);
				_map1.y = 251;
				addChild(_map1);
				
				_map1.map.addChild(destination);
			}
			else
			{
				bg = new ImageBox("map_back_location_info2");
				addChild(bg);
				
				_map1 = new LocationMap(keys[hall][FloorName.name.indexOf(floor)], hall, floor);
				addChild(_map1);
				_map1.showLine(_brand);
				
				_map2 = new LocationMap(keys[brand.data.hall][FloorName.name.indexOf(brand.data.floor)], brand.data.hall, brand.data.floor);
				addChild(_map2);
				
				if (FloorName.name.indexOf(floor) > FloorName.name.indexOf(brand.data.floor))
				{
					_map1.y = 251;
					_map2.y = 797-62;
				}
				else
				{
					_map2.y = 251;
					_map1.y = 797-62;
				}
				
				
				//Balloon.instance.update2(_brand, _map2.map);
				
				_map2.map.addChild(destination);
				
			}
			
			bg.x = 50;
			bg.y = 251;
			
			
			var title:ImageBox = new ImageBox("location_info", true);
			addChild(title);
		}
		
	}

}