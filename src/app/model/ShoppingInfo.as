package app.model 
{
	import app.Application;
	import app.net.MultiLoader;
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
	public class ShoppingInfo 
	{
		public var data:Object;
		public var thumbnail:Bitmap;
		public var detailImages:Array = [];
		
		public function ShoppingInfo(obj:Object) 
		{
			data = obj;
			loadThumbnail();
			loadDetailImages();
			
		}

		
		public function loadThumbnail():void 
		{
			var request:URLRequest = new URLRequest(data.thumbnail);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteThumbnail);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorImage);
			loader.load(request);
		}
		
		private function onIOErrorImage(e:IOErrorEvent):void 
		{
			var loader:Loader = LoaderInfo(e.target).loader;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteThumbnail);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorImage);
			
			thumbnail = new Bitmap();
		}
		
		
		private function onCompleteThumbnail(e:Event):void 
		{
			var loader:Loader = LoaderInfo(e.target).loader;
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteThumbnail);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorImage);
			
			//var bd:BitmapData = new BitmapData(loader.width, loader.height, true, 0);
			//bd.draw(loader.content, null, null, null, null, true);
			//thumbnail = new Bitmap(bd, "auto", true);
			
			thumbnail = loader.content as Bitmap;
			thumbnail.width = 380;
			thumbnail.height = 277;
		}
		
		private function loadDetailImages():void
		{
			var multiLoader:MultiLoader = new MultiLoader();			
			var images:Array = data.images.kor;
			
			for (var i:int = 0; i < images.length; i++) 
			{
				multiLoader.addTask(images[i], images[i], MultiLoader.MOVIE);
			}

			multiLoader.addEventListener(Event.COMPLETE, onCompleteDetailImages);
			multiLoader.start();
		}
		
		private function onCompleteDetailImages(e:Event):void 
		{
			var multiLoader:MultiLoader = e.target as MultiLoader;
			
			for (var i:int = 0; i < multiLoader.length; i++) 
			{
				var loader:Loader = Loader(multiLoader.getItemContent(i));
				if (loader == null)
				{
					trace( "ShoppingInfo : " + multiLoader.getItemRegistrationName(i) );
				}
				var image:Bitmap = loader.content as Bitmap;
				image.width = 920;
				image.height = 1171;
				detailImages[i] = image;
			}
			
			multiLoader.removeEventListener(Event.COMPLETE, onCompleteDetailImages);
		}
		

	}

}