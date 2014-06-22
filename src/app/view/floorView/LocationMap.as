package app.view.floorView 
{
	import app.model.Brand;
	import app.model.FloorName;
	import app.model.Model;
	import app.view.common.ImageBox;
	import com.greensock.TweenNano;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author joe
	 */
	public class LocationMap extends Sprite 
	{
		private var _title:FloorTitle2;
		private var _map:Map;
		private var _line:ImageBox;
		private var _floor:String;
		
		public function LocationMap(key:String, hall:String, floor:String) 
		{
			super();
			
			_floor = floor;
			
			_title = new FloorTitle2(hall, floor, Model.instance.getCategoryNamesByHallFloor(hall, floor).join(" / "));
			_title.x = 50;
			addChild(_title);
			
			_map = new Map(key, hall, floor);
			_map.x = 95;
			_map.y = 113;
			addChild(_map);
			
			
		}
		
		public function showLine(brand:Brand):void
		{
			var targetFloor:int = FloorName.name.indexOf(brand.data.floor);
			var curFloor:int = FloorName.name.indexOf(_floor);
			var appid:String = Model.instance.config.appid;
			var dir:String;
			
			if (brand.data.hall == "WEST")
			{
				if (targetFloor > curFloor)
				{
					dir = "up";
				}
				else
				{
					dir = "down";
				}	
			}
			else
			{
				if (curFloor > 1)
				{
					dir = "down";
				}
				else
				{
					return;
				}
			}
			
			
			var key:String = appid + "_" + dir + "arrow";
			trace( "key : " + key );
			
			_line = new ImageBox(key);
			_map.addChild(_line);
			_map.addChild(_map.indicator);
			
			//_line.alpha = 0;
			//TweenNano.to(_line, 0.5, { alpha:1} );
		}
		
		public function get map():Map 
		{
			return _map;
		}
	}

}