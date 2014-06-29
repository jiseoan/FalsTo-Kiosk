package app.view.gourmet494 
{
	import app.Application;
	import app.controller.Controller;
	import app.model.Model;
	import app.view.IView;
	import com.greensock.TweenMax;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author joe
	 */
	public class GourmetView extends Sprite implements IView
	{
		private var _curMode:int = 0;
		
		public var homeView:HomeView;
		public var onlyGalleriaView:OnlyGalleriaView;
		public var menuSearchView:MenuSearchView;
		public var tastyChartView:TastyChartView;
		public var subMenu:SubMenu;
		
		public function GourmetView(mode:int=0) 
		{
			trace( "GourmetView : " + mode );
			super();
			
			y = -108;
			
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0x161616);
			bg.graphics.drawRect(0, 0, 1080, 1920);
			addChild(bg);

			
			var line:Shape = new Shape();
			line.graphics.beginFill(0x202123);
			line.graphics.drawRect(0, 0, 1080, 2);
			line.y = 108;
			addChild(line);
			
			homeView = new HomeView();
			addChild(homeView);
			
			onlyGalleriaView = new OnlyGalleriaView();
			onlyGalleriaView.x = 1080;
			addChild(onlyGalleriaView);
			
			menuSearchView = new MenuSearchView();
			menuSearchView.x = 1080;
			addChild(menuSearchView);
			
			tastyChartView = new TastyChartView();
			tastyChartView.x = 1080;
			addChild(tastyChartView);
			
			subMenu = new SubMenu();
			subMenu.x = 1080;
			subMenu.y = 1566;
			addChild(subMenu);
			
			if (mode == 1)
			{
				_curMode = mode;
				Model.instance.gourmetMode = _curMode;
				homeView.x = -1080;
				onlyGalleriaView.x = 0;
				subMenu.x = 0;
			}
			else if (mode == 3)
			{
				_curMode = mode;
				Model.instance.gourmetMode = _curMode;
				homeView.x = -1080;
				menuSearchView.x = 0;
				subMenu.x = 0;
			}
			else if (mode == 5)
			{
				_curMode = mode;
				Model.instance.gourmetMode = _curMode;
				homeView.x = -1080;
				tastyChartView.x = 0;
				subMenu.x = 0;
			}
			
			Model.instance.addEventListener(Model.UPDATE_GOURMET_MODE, onUpdateGourmetMode);
		}
		
		/* INTERFACE app.view.IView */
		
		public function destroy():void 
		{
			Model.instance.removeEventListener(Model.UPDATE_GOURMET_MODE, onUpdateGourmetMode);
			Model.instance.gourmetMode = 0;
		}
		
		private function onUpdateGourmetMode(e:Event):void 
		{
			trace( "onUpdateGourmetMode : " + Model.instance.gourmetMode );
			changeView(Model.instance.gourmetMode);
		}
		
		public function changeView(nextMode:int, byNavigator:Boolean = false):void
		{
			var views:Array = [homeView, onlyGalleriaView, null, menuSearchView, null, tastyChartView];
			
			if (nextMode == 2)
			{
				Model.instance.floorViewInitObj = { hall:"WEST", floor:0 };
				Controller.instance.changeView(1);
				Model.instance.syncGourmetMode(0);
			}
			else if (nextMode == 4)
			{
				Model.instance.fromGourmetView = true;
				Controller.instance.changeView(5);
				Model.instance.syncGourmetMode(0);
			}
			else
			{
				var curView:Sprite = views[_curMode] as Sprite;
				var nextView:Sprite = views[nextMode] as Sprite;
				
				if (nextMode > _curMode)
				{
					nextView.x = 1080;
					nextView.visible = true;
					TweenMax.to(nextView, 0.5, { x:0 } );
					TweenMax.to(curView, 0.5, { x:-1080} );
				}
				else
				{
					nextView.x = -1080;
					nextView.visible = true;
					TweenMax.to(nextView, 0.5, { x:0 } );
					TweenMax.to(curView, 0.5, { x:1080} );
				}
				_curMode = nextMode;
				Model.instance.syncGourmetMode(_curMode);
				
				//히스토리 설정
				if (!byNavigator)
				{
					Controller.instance.setHistory(6, nextMode);
				}
				else
				{
					subMenu.onUpdateGourmetMode(null);
				}
				
				Application.instance.navigator.updateVisible(6);
			}
			
			
			if (nextMode == 0)
			{
				TweenMax.to(subMenu, 0.5, { x:1080 } );
			}
			else
			{
				TweenMax.to(subMenu, 0.5, { x:0 } );
			}
		}
	}

}





