package app.view.floorView 
{
	import app.model.Model;
	import app.view.common.ImageBox;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Map extends Sprite 
	{
		private var _map:ImageBox;
		private var _indicator:ImageBox;
		
		public function Map(key:String, hall:String, floor:String) 
		{
			super();
			
			_map = new ImageBox(key);
			addChild(_map);
			
			if (Model.instance.config.hall == hall && Model.instance.config.floor == floor)
			{
				_indicator = new ImageBox("map_icon_here", true);
				_indicator.x = Model.instance.config.position.x - _indicator.width / 2;
				_indicator.y = Model.instance.config.position.y - _indicator.height;
				addChild(_indicator);
			}
		}
		
		public function get indicator():ImageBox 
		{
			return _indicator;
		}
		
	}

}