package app.controller 
{
	import app.Application;
	import app.model.Model;
	import app.view.ScreenSaverWindow;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author joe
	 */
	public class Controller extends EventDispatcher
	{
		public static const TRANSITION:String = "transition";
		private static var _instance:Controller;
		
		private var _timer:Timer;
		
		private var _history:Array = [0];
		private var _historyIndex:int = 0;
		
		public function Controller() 
		{
			
			//_timer = new Timer(1000*3);
			_timer = new Timer(1000*60*Model.instance.config.screensaverInterval);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			
			startMonitorUserTouch();
		}
		
		public function startMonitorUserTouch():void
		{
			trace( "startMonitorUserTouch : "  );
			
			_timer.reset();
			_timer.start();
			
			Application.instance.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownStage);
		}
		
		public function stopMonitorUserTouch():void
		{
			_timer.reset();
			_timer.stop();
		}
		
		public function destory():void
		{
			stopMonitorUserTouch();
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_timer = null;
			Application.instance.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownStage);
			
			_instance = null;
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			trace( "onTimer Controller : " + onTimer );
			Application.instance.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownStage);
			_timer.reset();
			_timer.stop();
			
			var screenSaverWindow:ScreenSaverWindow = new ScreenSaverWindow();
			screenSaverWindow.open();
			
			
		}

		private function onMouseDownStage(e:MouseEvent):void 
		{
			trace( "onMouseDownStage : " + onMouseDownStage );
			Application.instance.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownStage);
			Model.instance.screensaverMode = false;
			startMonitorUserTouch();
		}
		
		public function changeView(mode:int, byNavigator:Boolean = false):void
		{
			if (mode == Model.instance.mode) return;
			
			Application.instance.enabled = false;
			
			if (Model.instance.mode == 0)
			{
				Application.instance.home.visible = false;
				Application.instance.content.visible = true;
				Application.instance.content.changeView(mode);
				
				Application.instance.proxy.homeToContent(mode);
				
				Application.instance.home.updateTicker();
				
			}
			else
			{
				if (mode == 0)
				{
					Application.instance.content.visible = false;
					Application.instance.home.visible = true;
					
					
					Application.instance.proxy.contentToHome();
				}
				else
				{
					var curView:Bitmap = new Bitmap(new BitmapData(1080, 1574, false));
					curView.bitmapData.draw(Application.instance.content, null, null, null, null, true);
			
					Application.instance.content.changeView(mode);
					
					Application.instance.proxy.contentToContent(curView, mode);
					
				}
			}
			
			if (mode != 6)
			{
				if (!byNavigator)
				{
					_history.splice(_historyIndex + 1);
					_history.push(mode);
					_historyIndex++;
					if (mode == 0)
					{
						_history = [0];
						_historyIndex = 0;
					}
				}
				
				Model.instance.mode = mode;
				dispatchEvent(new Event(Controller.TRANSITION));
			}
			else
			{
				Application.instance.enabled = true;
			}
			
			
		}
		
		public function goBack():void
		{
			_historyIndex--;
			
			if (_historyIndex == 0)
			{
				_history = [0];
			}
			
			changeView(_history[_historyIndex], true);
		}
		
		public function goForward():void
		{
			if (_historyIndex != _history.length - 1)
			{
				_historyIndex++;
				
				changeView(_history[_historyIndex], true);	
			}
			
		}
		
		public function isLastHistory():Boolean
		{
			if (_historyIndex == _history.length - 1)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		static public function get instance():Controller 
		{
			if (_instance == null)
			{
				_instance = new Controller();
			}
			
			return _instance;
		}
		
		static public function set instance(value:Controller):void 
		{
			_instance = value;
		}
	}

	

}