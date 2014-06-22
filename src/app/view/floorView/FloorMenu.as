package app.view.floorView 
{
	import app.model.FloorName;
	import app.model.Model;
	import app.view.common.Button;
	import app.view.common.ImageBox;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FloorMenu extends Sprite 
	{
		private var _btns:Array = [];
		
		public function FloorMenu() 
		{
			super();
			
			for (var i:int = 0; i < 6; i++) 
			{
				var btn:FloorButton = new FloorButton(i);
				btn.id = i;
				btn.x = 63 * i;
				
				_btns.push(btn);
				
				addChild(btn);
				
				btn.addEventListener(MouseEvent.CLICK, btn_click);
			}
 
			
			FloorView.instance.addEventListener(FloorView.UPDATE_STATUS, update);
		}
		
		private function btn_click(e:MouseEvent):void 
		{
			var t:FloorButton = e.currentTarget as FloorButton;
			
			if (FloorView.instance.curFloor == t.id) return;
			
			FloorView.instance.setStatus(FloorView.instance.curHall, t.id);
		}
		
		private function update(e:Event):void 
		{
			if (FloorView.instance.curHall == "WEST")
			{
				addChild(_btns[5]);
			}
			else
			{
				if(contains(_btns[5])) removeChild(_btns[5]);
			}
			
			for (var i:int = 0; i < 6; i++) 
			{
				var btn:FloorButton = _btns[i];
				
				if (i == FloorView.instance.curFloor)
				{
					btn.focus();
				}
				else
				{
					btn.blur();
				}
				
			}
			
			i = FloorName.name.indexOf(Model.instance.config.floor);
			btn = _btns[i];
				
			if (Model.instance.config.hall == FloorView.instance.curHall)
			{
				btn.showIndicator();
			}
			else
			{
				btn.hideIndicator();
			}
		}
		
	}

}