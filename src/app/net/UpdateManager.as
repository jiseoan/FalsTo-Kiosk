package app.net 
{
	import app.Application;
	import app.model.Model;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author joe
	 */
	public class UpdateManager 
	{
		private var _timer:Timer;
		
		private var _isFirst:Boolean = true;
		private var _data:Object;
		
		public function UpdateManager() 
		{
			
		}
		
		public function start():void
		{
			check(null);
			
			//_timer = new Timer(Number(10 * 1000));
			_timer = new Timer(Number(Model.instance.config.updateInterval) * 60 * 1000);
			_timer.addEventListener(TimerEvent.TIMER, check);
			_timer.start();
		}
		
		private function check(e:TimerEvent):void
		{
			var url:String;
			
			if (Main.instance.appid)	//웹버전일때
			{
				url = "preview/dataupdate.php";
			}
			else
			{
				url = "json/dataupdate.json";
			}
			
			var request:URLRequest = new URLRequest(url);
			var loader:URLLoader = new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, loader_complete);
			loader.load(request);
		}
		
		private function loader_complete(e:Event):void 
		{
			var loader:URLLoader = e.target as URLLoader;
			var data:Object = JSON.parse(loader.data);
			//trace( "data.releaseno : " + data.releaseno );
			
			if (_isFirst)
			{
				_data = data;
				_isFirst = false;
			}
			else
			{
				if (_data.releaseno != data.releaseno)
				{
					_timer.stop();
					Main.instance.restart();
					return;
				}
				
				if (_data.ranking != data.ranking)
				{
					_data = data;
					loadRankingData();
				}
			}
		}
		
		private function loadRankingData():void
		{
			trace( "loadRankingData : " + loadRankingData );
			var url:String = "json/ranking.json";
			var request:URLRequest = new URLRequest(url);
			var loader:URLLoader = new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, onCompleteRankingData);
			loader.load(request);
		}
		
		private function onCompleteRankingData(e:Event):void 
		{
			trace( "onCompleteRankingData : " + onCompleteRankingData );
			var loader:URLLoader = e.target as URLLoader;
			Model.instance.rankings = JSON.parse(loader.data).tables;
		}

	}

}