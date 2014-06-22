package app.view 
{
	import app.Application;
	import app.model.Brand;
	import app.model.FloorName;
	import app.model.Model;
	import app.view.common.ImageBox;
	import app.view.common.Navigator;
	import app.view.floorView.LocationWindow;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ServiceView extends Sprite  implements IView
	{
		private var _btnContainer:ServiceViewButtonsAsset;
		private var _btns:Array = [];
		private var _navigator:Navigator;
		
		public function ServiceView() 
		{
			super();
			
			var title:ImageBox = new ImageBox("galleria_service", true);
			addChild(title);
			
			_btnContainer = new ServiceViewButtonsAsset();
			addChild(_btnContainer);
			
			_navigator = new Navigator();
			addChild(_navigator);
			
			for (var i:int = 0; i < _btnContainer.numChildren; i++) 
			{
				var btn:SimpleButton = _btnContainer.getChildByName("b" + (i + 1)) as SimpleButton;
				btn.addEventListener(MouseEvent.CLICK, onClick);
				_btns.push(btn);
			}
		}
		
		private function onClick(e:MouseEvent):void 
		{
			var btn:SimpleButton = e.target as SimpleButton;
			var id:int = _btns.indexOf(btn);
			
			openLocationWindow(id);
		}
		
		private function openLocationWindow(id:int):void
		{
			var floors:Array = ["1F", "4F", "4F", "5F", "1F", "B1F", "5F", "2F", "2F", "2F", "B1F", "B1F"];
			
			var obj:Object = { };
			obj.hall = "WEST";
			obj.floor = floors[id];
			obj.id = id;
			
			var floor:int = FloorName.name.indexOf(Model.instance.config.floor);
			if (id == 7) //서비스데스크일때 현재층으로
			{
				if (floor == 3 || floor == 4 || floor == 5)
				{
					obj.floor = FloorName.name[floor];
				}
			}
			
			if (id == 10 || id == 11)
			{
				if (floor == 1)
				{
					obj.floor = FloorName.name[2];
				}
				else
				{
					obj.floor = FloorName.name[floor];
				}
				
				
			}
			
			var brand:Brand = new Brand(obj);
			var window:LocationWindow = new LocationWindow(brand);
			window.open();
		}
		
		/* INTERFACE app.view.IView */
		
		public function destroy():void 
		{
			
		}
		
	}

}