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
	
	// TODO: 터치스크린 이상유무 확인
	import flash.events.MouseEvent;
	//import flash.ui.MouseCursorData;
	import flash.geom.Point;
	import com.greensock.TweenNano;
	
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
		
		// TODO: 터치스크린 이상유무 확인
		private var _curimage:Sprite;
		
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
				
				// TODO: 터치스크린 이상유무 확인
				stage.addEventListener(MouseEvent.CLICK, MouseClick);
				
				var logger:AliveLogger = new AliveLogger();
			}
			
			Main.instance = this;
			
			addChild(Application.instance);
			
			// TODO: 터치스크린 이상유무 확인
			_curimage = new Sprite();
			_curimage.graphics.beginFill(0x0000FF, 0.7);
			_curimage.graphics.drawCircle(0, 0, 30);
			//_curimage.graphics.drawRect(0, 0, 40, 40);
			_curimage.graphics.endFill();
			_curimage.visible = false;
			_curimage.alpha = 0;
			addChild(_curimage);
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
		
		// TODO: 터치스크린 이상유무 확인
		private function MouseClick(e:MouseEvent):void
		{
			_curimage.x = stage.mouseX;
			_curimage.y = stage.mouseY;
			_curimage.visible = true;			
			TweenNano.to(_curimage, 0.5, { alpha:1, scaleX:3, scaleY:3, onComplete:MouseClick_off } );
		}
		private function MouseClick_off():void
		{
			_curimage.visible = false;
			_curimage.alpha = 0;
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




