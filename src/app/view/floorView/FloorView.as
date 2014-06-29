package app.view.floorView 
{
	import app.model.FloorName;
	import app.model.Model;
	import app.view.common.ImageBox;
	import app.view.IView;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FloorView extends Sprite implements IView
	{
		public static const UPDATE_STATUS:String = "updateStatus";
		public static const UPDATE_LIST:String = "updateList";
		public static var instance:FloorView;
		
		private var _curHall:String = "";
		private var _curFloor:int = -1;
		
		private var _mapView:MapViewer;
		
		private var _shopList:ShopList;
		
		public function FloorView() 
		{
			super();
			
			FloorView.instance = this;
			
			var title:ImageBox = new ImageBox("title_floor_guide", true);
			addChild(title);
			
			_mapView = new MapViewer();
			addChild(_mapView);
			
			_shopList = new ShopList();
			addChild(_shopList);
			
			if (Model.instance.floorViewInitObj == null)
			{
				setStatus(Model.instance.config.hall, FloorName.name.indexOf(Model.instance.config.floor));
			}
			else
			{
				setStatus(Model.instance.floorViewInitObj.hall, Model.instance.floorViewInitObj.floor);
				Model.instance.floorViewInitObj = null;
			}
			
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			
		}
		
		public function setStatus(hall:String, floor:int):void
		{
			var isUpdated:Boolean = false;
			
			if (_curHall != hall)
			{
				_curHall = hall;
				isUpdated = true;
			}
			
			if (_curFloor != floor)
			{
				_curFloor = floor;
				isUpdated = true;
			}
			
			if (isUpdated)
			{
				if (contains(Balloon.instance)) removeChild(Balloon.instance);
				dispatchEvent(new Event(FloorView.UPDATE_STATUS));
			}
		}
		
		/* INTERFACE app.view.IView */
		
		public function destroy():void 
		{
			
		}
		
		public function get curHall():String 
		{
			return _curHall;
		}
		
		public function get curFloor():int 
		{
			return _curFloor;
		}
		
		public function get mapView():MapViewer 
		{
			return _mapView;
		}
		
		public function get shopList():ShopList 
		{
			return _shopList;
		}
		
	}

}