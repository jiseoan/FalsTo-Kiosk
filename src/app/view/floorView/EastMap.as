package app.view.floorView 
{
	import app.model.FloorName;
	import app.model.Model;
	import com.greensock.easing.Back;
	import com.greensock.TweenNano;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class EastMap extends Sprite 
	{
		private var _keys:Array = ["map_EAST1_B1F", "map_EAST2_1F", "map_EAST3_2F", "map_EAST4_3F", "map_EAST5_4F"];
		private var _maps:Array = [];
		private var _offsetX:int = 45;
		private var _offsetY:int = 113;
		private var _containerH:int = 537;
		
		private var _sec:Number = 0;
		
		public function EastMap() 
		{
			super();
			
			
			for (var i:int = 0; i < _keys.length; i++) 
			{
				var map:Map = new Map(_keys[i], "EAST", FloorName.name[i]);
				map.x = _offsetX;
				map.y = -i * _containerH + _offsetY;
				_maps.push(map);
				
				addChild(map);
			}
			
			FloorView.instance.addEventListener(FloorView.UPDATE_STATUS, update);
		}
		
		private function update(e:Event):void 
		{
			if (FloorView.instance.curHall =="EAST")
			{
				TweenNano.to(this, _sec, { y:FloorView.instance.curFloor * _containerH} );
			}
			else
			{
				if (Model.instance.config.hall == "EAST")
				{
					y = FloorName.name.indexOf(Model.instance.config.floor) * _containerH;
				}
				else
				{
					y = 1 * _containerH;
				}
			}
			
			_sec = 0.4;
		}
		
	}

}