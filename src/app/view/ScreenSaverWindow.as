package app.view 
{
	import app.Application;
	import app.controller.Controller;
	import app.controller.ScreenSaverController;
	import app.model.Language;
	import app.model.Model;
	import app.text.TextFormatter;
	import app.view.common.ImageBox;
	import app.view.common.Window;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author joe
	 */
	public class ScreenSaverWindow extends Window 
	{
		private var _tf:TextField;
		private var _timer:Timer;
		private var _sec:int = 5;
		
		public function ScreenSaverWindow() 
		{
			super(474, 637, true);
			
			var bg:ImageBox = new ImageBox("alert_screensaver", true);
			addChild(bg);
			
			_tf = new TextField();
			//_tf.border = true;
			_tf.width = 230;
			_tf.height = 150;
			_tf.x = 123;
			_tf.y = 80+40;
			_tf.text = _sec.toString();
			addChild(_tf);
			
			TextFormatter.setTextFormat(_tf, 0x222222, 120, MyriadProBold, "center");
			
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, loop)
			_timer.start();
			
			addEventListener(Window.BEFORE_CLOSE, onBeforeClose);
			
			Main.instance.addEventListener(Main.BEFORE_RESTART, onBeforeRestart);
		}
		
		private function onBeforeRestart(e:Event):void 
		{
			Main.instance.removeEventListener(Main.BEFORE_RESTART, onBeforeRestart);
			
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, loop);
			
			close();
		}
		
		private function onBeforeClose(e:Event):void 
		{
			Main.instance.removeEventListener(Main.BEFORE_RESTART, onBeforeRestart);
			Controller.instance.startMonitorUserTouch();
			
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, loop);
		}
		
		private function loop(e:TimerEvent):void 
		{
			_sec--;
			_tf.text = _sec.toString();
			
			if (_sec < 0)
			{
				_sec = 5;
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, loop);
				Main.instance.removeEventListener(Main.BEFORE_RESTART, onBeforeRestart);
				
				close();
				
				ScreenSaverController.instance.startScreenSaverMode();
			}
		}

	}

}