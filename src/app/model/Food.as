package app.model 
{
	import app.Application;
	import app.view.common.ImageBox;
	import com.greensock.layout.AlignMode;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author joe
	 */
	public class Food 
	{
		public var data:Object;
		public var image:Bitmap;
		
		public function Food(obj:Object) 
		{
			data = obj;
			
			//var arr:Array = data.price.split(" ");
			//data.price = arr[arr.length - 1];
			
			loadImage();
		}

		
		public function loadImage():void 
		{
			if (!data.image) return;
			
			var request:URLRequest = new URLRequest(data.image);
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
			
			image = new Bitmap();
		}
		
		
		private function onCompleteImage(e:Event):void 
		{
			var loader:Loader = LoaderInfo(e.target).loader;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteImage);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorImage);
			
			//var bd:BitmapData = new BitmapData(loader.width, loader.height, true, 0);
			//bd.draw(loader.content, null, null, null, null, true);
			//image = new Bitmap(bd, "auto", true);
			
			image = loader.content as Bitmap;
			image.width = 230;
			image.height = 223;
		}
		
	}

}