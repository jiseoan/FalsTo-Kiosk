package app.view.floorView 
{
	import app.model.FloorName;
	import app.model.Model;
	import app.view.common.Button;
	import app.view.common.ImageBox;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class HallTab extends Sprite 
	{
		public static const TAB_SELECT:String = "tabSelect";
		
		private var _tab1:Button;
		private var _tab2:Button;
		
		private var _selected:int = 0;
		
		public function HallTab() 
		{
			super();
			y = 535;
			
			_tab1 = new Button([new ImageBox("tab_west"), new ImageBox("tab_west_press"), new ImageBox("tab_west_focus")]);
			_tab2 = new Button([new ImageBox("tab_east"), new ImageBox("tab_east_press"), new ImageBox("tab_east_focus")]);
			
			_tab1.id = 0;
			_tab2.id = 1;
			
			_tab2.x = _tab1.width - 2;
			
			addChild(_tab2);
			
			_tab1.focus();
			addChild(_tab1);
			
			_tab1.addEventListener(Button.CLICK, tab_click);
			_tab2.addEventListener(Button.CLICK, tab_click);
			
			FloorView.instance.addEventListener(FloorView.UPDATE_STATUS, update);
		}
		
		private function tab_click(e:Event):void 
		{
			var t:Button = e.target as Button;
			
			if (t.id == _selected) return;
			
			var halls:Array = ["WEST", "EAST"];
			var hall:String = halls[t.id];
			
			if (hall == Model.instance.config.hall)
			{
				FloorView.instance.setStatus(hall, FloorName.name.indexOf(Model.instance.config.floor));
			}
			else
			{
				FloorView.instance.setStatus(hall, 1);
			}
			
		}
		
		private function update(e:Event):void
		{
			if (FloorView.instance.curHall == "WEST")
			{
				_tab1.focus();
				_tab2.up();
				_selected = 0;
				addChild(_tab1);
			}
			else
			{
				_tab1.up();
				_tab2.focus();
				_selected = 1;
				addChild(_tab2);
			}
		}
		
		public function get selected():int 
		{
			return _selected;
		}
		
	}

}