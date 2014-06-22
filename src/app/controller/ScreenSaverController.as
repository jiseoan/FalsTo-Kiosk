package app.controller 
{
	import app.Application;
	import app.model.Language;
	import app.model.Model;
	import app.view.common.Window;
	import app.view.ShoppingInfoView;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author joe
	 */
	public class ScreenSaverController 
	{
		private static var _instance:ScreenSaverController;
		
		private var _timer:Timer;
		private var _order:int = 0;
		private var _count:int = 0;
		
		public function ScreenSaverController() 
		{
			_timer = new Timer(1000 * 5);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			
		}
		
		private function onMouseDownStage(e:MouseEvent):void 
		{
			stopScreenSaverMode();
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			if (_order == 0)
			{
				Controller.instance.changeView(4);
			}
			else if (_order == 1)
			{
				Controller.instance.changeView(5);
			}
			else if (_order == 2)
			{
				_timer.reset();
				Window.curWindow.close();
				ShoppingInfoView(Application.instance.content.curView).startVideoPlayer();
			}
			
			_order++;
			if (_order == 3) 
			{
				_order = 0;
				_count++;
			}
		}
		
		public function startScreenSaverMode():void
		{
			
			_order = 0;
			Model.instance.lang = Language.KOREAN;
			Controller.instance.changeView(0);
			
			_timer.reset();
			_timer.start();
			
			Model.instance.screensaverMode = true;
			Application.instance.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownStage);
		}
		
		public function stopScreenSaverMode():void
		{
			trace( "stopScreenSaverMode : " + stopScreenSaverMode );
			Model.instance.screensaverMode = false;
			
			_order = 0;
			_timer.reset();
			Application.instance.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownStage);
			
			Controller.instance.startMonitorUserTouch();
		}
		
		public function destroy():void
		{
			Model.instance.screensaverMode = false;
			
			_order = 0;
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			Application.instance.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownStage);
			
			_instance = null;
		}
		
		static public function get instance():ScreenSaverController 
		{
			if (_instance == null)
			{
				_instance = new ScreenSaverController();
			}
			
			return _instance;
		}
		
		public function get count():int 
		{
			return _count;
		}
	}

}