package app 
{
	import app.controller.Controller;
	import app.model.Model;
	import app.net.LoadManager;
	import app.net.UpdateManager;
	import app.text.TextFormatter;
	import app.view.common.ImageBox;
	import app.view.Content;
	import app.view.Header;
	import app.view.HomeView;
	import app.view.IView;
	import app.view.LanguageWindow;
	import app.view.Logger;
	import app.view.TransitionProxy;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author joe
	 */
	public class Application extends Sprite 
	{
		public static const INIT:String = "applicationInit";
		
		private static var _instance:Application;
		
		private var _loadManager:LoadManager;
		private var _updateManager:UpdateManager;
		private var _logger:Logger;
		
		private var _enabled:Boolean = true;
		
		public var home:HomeView;
		public var content:Content;
		public var proxy:TransitionProxy;
		public var dimBox:Sprite;
		
		public var langWindow:LanguageWindow;
		
		public function Application() 
		{
			
			_logger = new Logger();
			_logger.width = 1060;
			_logger.height = 1900;
			_logger.x = _logger.y = 10;
			TextFormatter.setTextFormat(_logger, 0xFFFFFF, 14, YoonGothic135);
			addChild(_logger);
			
			_logger.log("Start Loading Data...");
			
			Model.instance = new Model();
			
			_loadManager = new LoadManager();
			_loadManager.addEventListener(LoadManager.COMPLETE, init);
			_loadManager.load();
			
			dimBox = new Sprite();
			dimBox.graphics.beginFill(0, 0.5);
			dimBox.graphics.drawRect(0, 0, 1080, 1920);
			dimBox.y = 108;
			dimBox.visible = false;
			dimBox.alpha = 0;
		}
		
		private function init(e:Event):void 
		{
			proxy = new TransitionProxy();
			
			home = new HomeView();
			addChild(home);
			
			content = new Content();
			content.visible = false;
			addChild(content);
			
			var header:Header = new Header();
			addChild(header);
			
			var footer:ImageBox = new ImageBox("footer");
			footer.y = 1852;
			addChild(footer);
			
			
			
			removeChild(_logger);
			_logger = null;
			
			langWindow  = new LanguageWindow(774, 896);
			
			//컨트롤러 생성
			Controller.instance;
			
			//업데이트 여부 체크
			_updateManager = new UpdateManager();
			_updateManager.start();
			
			var bd:BitmapData = new BitmapData(1080, 1920, false);
			bd.draw(this);
			Main.instance.homeCapture = new Bitmap(bd);
			
			
			dispatchEvent(new Event(Application.INIT));
		}
		
		static public function get instance():Application 
		{
			if (_instance == null)
			{
				_instance = new Application();
			}
			
			return _instance;
		}
		
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			if (_enabled)
			{
				mouseChildren = true;
				mouseEnabled = true;
			}
			else
			{
				mouseChildren = false;
				mouseEnabled = false;
			}
		}

		public function get logger():Logger 
		{
			return _logger;
		}
		
		static public function set instance(value:Application):void 
		{
			_instance = value;
		}
		
	}

}