package app.view.floorView 
{
	import app.model.FloorName;
	import app.model.Model;
	import app.view.common.Button;
	import app.view.common.ImageBox;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author joe
	 */
	dynamic public class FloorButton extends Sprite 
	{
		private var _floor:int;
		private var _btn:Button;
		private var _curFloorIndicator:ImageBox;
		
		public function FloorButton(floor:int) 
		{
			super();
			
			_floor = floor;
			var n:String = FloorName.name[floor];
			_btn = new Button([new ImageBox("floor_num_" + n), new ImageBox("floor_num_" + n + "_click"), new ImageBox("floor_num_" + n + "_sel")]);
			addChild(_btn);
			
			if (n == Model.instance.config.floor)
			{
				_curFloorIndicator = new ImageBox("floor_num_" + n + "_cur");
				addChild(_curFloorIndicator);
			}
			
		}
		
		public function showIndicator():void
		{
			_curFloorIndicator.visible = true;
			_btn.alpha = 0;
		}
		
		public function hideIndicator():void
		{
			_curFloorIndicator.visible = false;
			_btn.alpha = 1;
		}
		
		public function focus():void
		{
			_btn.focus();
		}
		
		public function blur():void
		{
			_btn.up();
		}
	}

}