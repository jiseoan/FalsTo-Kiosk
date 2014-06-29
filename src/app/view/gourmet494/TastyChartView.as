package app.view.gourmet494
{
	import app.model.Model;
	import app.view.common.ImageBox;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author joe
	 */
	public class TastyChartView extends Sprite
	{
		private var _pagination:MonthPagination;
		private var _chartImage:Bitmap;
		
		public function TastyChartView()
		{
			super();
			
			var title:ImageBox = new ImageBox("gourmet/title_tasty_chart", true);
			title.y = 110;
			addChild(title);
			
			_pagination = new MonthPagination();
			_pagination.y = 1370;
			_pagination.addEventListener(MonthPagination.SELECT, onSelect);
			addChild(_pagination);
			
			_chartImage = new Bitmap(new BitmapData(920, 989, true, 0x00000000), "auto", true);
			_chartImage.x = 80;
			_chartImage.y = 381;
			addChild(_chartImage);
			
			
		}
		
		private function onSelect(e:Event):void
		{
			trace( "onSelect : " + onSelect );
			var y:int = _pagination.curYear;
			var m:int = _pagination.curMonth;
			
			var charts:Array = Model.instance.tastyCharts;
			
			for (var i:int = 0; i < charts.length; i++)
			{
				var item:Object = charts[i];
				
				if (item.year == y && item.month == m)
				{
					var url:String = item.image[Model.instance.lang];
					loadChart(url);
					break;
				}
			}
		}
		
		private function loadChart(url:String):void
		{
			trace( "loadChart : " + loadChart );
			var request:URLRequest = new URLRequest(url);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteImage);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorImage);
			loader.load(request);
		}
		
		private function onIOErrorImage(e:IOErrorEvent):void
		{
			var loader:Loader = LoaderInfo(e.target).loader;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteImage);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorImage);
		}
		
		private function onCompleteImage(e:Event):void
		{
			var loader:Loader = LoaderInfo(e.target).loader;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteImage);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorImage);
			
			var bitmap:Bitmap = loader.content as Bitmap;
			_chartImage.bitmapData = bitmap.bitmapData;
			
			_chartImage.width = 920;
			_chartImage.height = 989;
		}
	}

}