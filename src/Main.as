package 
{
	import app.Application;
	import app.controller.Controller;
	import app.controller.ScreenSaverController;
	import app.model.Model;
	import app.net.AliveLogger;
	import app.view.floorView.Balloon;
	import app.view.UpdateAlert;
	import app.view.window.BrandInfoWindow;
	import com.greensock.TweenMax;
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import mx.utils.StringUtil;
	
	/**
	 * ...
	 * @author joe
	 */
	public class Main extends Sprite 
	{
		public static const BEFORE_RESTART:String = "beforeRestart";
		public static var instance:Main;
		
		private var _mouseVisible:Boolean = false;
		private var _appid:String;
		
		private var _homeCapture:Bitmap;
		private var _updateAlert:UpdateAlert;
		
		public function Main():void 
		{
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			
			
			var m:Shape = new Shape();
			m.graphics.beginFill(0);
			m.graphics.drawRect(0, 0, 1080, 1920);
			addChild(m);
			
			mask = m;
			
			//scaleX = scaleY = 0.5;
			
			_appid = LoaderInfo(this.root.loaderInfo).parameters.appid;
			if (!_appid)
			{
				Mouse.hide();
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				
				var logger:AliveLogger = new AliveLogger();
			}
			
			Main.instance = this;
			
			addChild(Application.instance);
			
		}
		
		public function restart():void
		{
			dispatchEvent(new Event(Main.BEFORE_RESTART));
			
			TweenMax.killAll(false);
			
			Balloon.instance.destory();
			BrandInfoWindow.instance.destroy();
			Controller.instance.destory();
			ScreenSaverController.instance.destroy();
			
			removeChild(Application.instance);
			
			_updateAlert = new UpdateAlert();
			
			Model.instance.destroy();
			
			Application.instance = new Application();
			addChild(Application.instance);
			
			addChild(_updateAlert);
			
			Application.instance.addEventListener(Application.INIT, onInitApplication);
		}
		
		private function onInitApplication(e:Event):void 
		{
			Application.instance.removeEventListener(Application.INIT, onInitApplication);
			
			removeChild(_updateAlert);
			_updateAlert = null;
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.ESCAPE || e.keyCode == Keyboard.ENTER || e.keyCode==Keyboard.SPACE)
			{
				NativeApplication.nativeApplication.exit();
			}
			
			else if (e.keyCode == Keyboard.C)
			{
				if (_mouseVisible)
				{
					Mouse.hide();
					_mouseVisible = false;
				}
				else
				{
					Mouse.show();
					_mouseVisible = true;
				}
				
			}
			
			else if (e.keyCode == Keyboard.F)
			{
				if (stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
				{
					stage.nativeWindow.width = 540;
					stage.nativeWindow.height = 960;
					stage.displayState = StageDisplayState.NORMAL;
					Mouse.show();
					_mouseVisible = true;
					
				}
				else
				{
					stage.nativeWindow.width = 1080;
					stage.nativeWindow.height = 1920;
					stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
					Mouse.hide();
					_mouseVisible = false;
				}
			}
			
		}
		
		public function get appid():String 
		{
			return _appid;
		}
		
		public function get homeCapture():Bitmap 
		{
			return _homeCapture;
		}
		
		public function set homeCapture(value:Bitmap):void 
		{
			_homeCapture = value;
		}
		
	}
	
}




