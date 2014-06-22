package app.view.floorView 
{
	import app.model.FloorName;
	import app.model.Model;
	import com.greensock.easing.Back;
	import com.greensock.TweenMax;
	import com.greensock.TweenNano;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class WestMap extends Sprite 
	{
		private var _keys:Array = ["map_WEST1_B1F", "map_WEST2_1F", "map_WEST3_2F", "map_WEST4_3F", "map_WEST5_4F", "map_WEST6_5F"];
		private var _maps:Array = [];
		private var _offsetX:int = 45;
		private var _offsetY:int = 113;
		private var _containerH:int = 537;
		
		private var _sec:Number = 0;
		
		public function WestMap() 
		{
			super();
			
			
			for (var i:int = 0; i < _keys.length; i++) 
			{
				var map:Map = new Map(_keys[i], "WEST", FloorName.name[i]);
				map.x = _offsetX;
				map.y = -i * _containerH + _offsetY;
				_maps.push(map);
				
				addChild(map);
			}
			
			FloorView.instance.addEventListener(FloorView.UPDATE_STATUS, update);
			
		}
		
		private function update(e:Event):void 
		{
			if (FloorView.instance.curHall =="WEST")
			{
				if (_sec == 0)
				{
					y = FloorView.instance.curFloor * _containerH;
				}
				else
				{
					TweenNano.to(this, _sec, { y:FloorView.instance.curFloor * _containerH} );
				}
				
			}
			else
			{
				if (Model.instance.config.hall == "WEST")
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