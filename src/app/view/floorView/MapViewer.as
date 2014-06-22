package app.view.floorView 
{
	import app.Application;
	import app.controller.Controller;
	import app.view.common.ImageBox;
	import com.greensock.easing.Back;
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import com.greensock.TweenNano;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MapViewer extends Sprite 
	{
		private var _tab:HallTab;
		private var _mapContainer:Sprite;
		private var _westMap:WestMap;
		private var _eastMap:EastMap;
		private var _floorMenu:FloorMenu;
		private var _floorTitle:FloorTitle;
		private var _serviceBtn:ImageBox;
		private var _serviceBtnBg:ImageBox;
		
		private var _sec:Number = 0;
		
		public function MapViewer() 
		{
			super();
			
			x = 80;
			y = 273;
			
			var bg:ImageBox = new ImageBox("map_back_floor_plan");
			addChild(bg);
			
			_mapContainer = new Sprite();
			addChild(_mapContainer);
			
			var m:Shape = new Shape();
			m.graphics.beginFill(0);
			m.graphics.drawRect(0, 2, bg.width, bg.height - 4);
			addChild(m);
			_mapContainer.mask = m;
			
			_westMap = new WestMap();
			_mapContainer.addChild(_westMap);
			
			_eastMap = new EastMap();
			_eastMap.x = 920;
			_mapContainer.addChild(_eastMap);
			
			_floorMenu = new FloorMenu();
			_floorMenu.x = (bg.x + bg.width / 2) - _floorMenu.width / 2;	//리스너에서 처리
			_floorMenu.y = 463;
			addChild(_floorMenu);
			
			_floorTitle = new FloorTitle();
			addChild(_floorTitle);
			
			_tab = new HallTab();
			addChild(_tab);
			
			
			_serviceBtn = new ImageBox("map_GA", true);
			_serviceBtn.x = 920 - _serviceBtn.width -10;
			_serviceBtn.y = 520 - _serviceBtn.height-10;
			
			_serviceBtnBg = new ImageBox("map_GA_click");
			_serviceBtnBg.x = _serviceBtn.x+10;
			_serviceBtnBg.y = _serviceBtn.y+3;
			_serviceBtnBg.visible = false;
			
			addChild(_serviceBtnBg);
			addChild(_serviceBtn);
			
			_serviceBtn.addEventListener(MouseEvent.MOUSE_DOWN, onDownServiceBtn);
			_serviceBtn.addEventListener(MouseEvent.MOUSE_UP, onUpServiceBtn);
			_serviceBtn.addEventListener(MouseEvent.CLICK, onClickServiceBtn);
			
			FloorView.instance.addEventListener(FloorView.UPDATE_STATUS, update);
			
		}
		
		private function onDownServiceBtn(e:MouseEvent):void 
		{
			_serviceBtnBg.visible = true;
		}
		
		private function onUpServiceBtn(e:MouseEvent):void 
		{
			_serviceBtnBg.visible = false;
		}
		
		private function onClickServiceBtn(e:MouseEvent):void 
		{
			Controller.instance.changeView(2);
		}
		
		private function update(e:Event):void 
		{
			Application.instance.enabled = false;
			
			var tx:int = (FloorView.instance.curHall == "WEST")?0: -920;
			TweenNano.to(_mapContainer, _sec, { x:tx, onComplete:delay } );
			
			tx = 1080/2 - _floorMenu.width / 2 - x;
			TweenNano.to(_floorMenu, _sec, { x:tx } );
			
			
			
			function delay():void { Application.instance.enabled = true}
			
			_sec = 0.4;
			
			
		}
		
	}

}