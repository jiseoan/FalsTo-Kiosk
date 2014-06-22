package app.net 
{
	import app.Application;
	import app.model.Brand;
	import app.model.FloorName;
	import app.model.Language;
	import app.model.Model;
	import app.model.ShoppingInfo;
	import app.model.StaticImageUrl;
	import app.text.TextFormatter;
	import app.view.floorView.DestinationIndicator;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Mouse;
	
	/** 
	 * ...
	 * @author joe
	 */
	public class LoadManager extends EventDispatcher 
	{
		public static const COMPLETE:String = "complete";
		
		private var _jsons:Array = ["configure", "brand", "ranking", "shopping_info", "main_slide"];
		private var _jsonUrls:Array = [];
		
		public function LoadManager() 
		{
			for (var i:int = 0; i < _jsons.length; i++) 
			{
				var url:String;
				if (Main.instance.appid)	//웹버전일때
				{
					url = "preview/" + _jsons[i] + ".php";
					if (_jsons[i] == "configure")
					{
						url += "?appid=" + Main.instance.appid;
					}
				}
				else
				{
					url = "json/" + _jsons[i] + ".json";
				}
				
				
				_jsonUrls.push(url);
			}
		}
		
		public function load():void
		{
			var multiLoader:MultiLoader = new MultiLoader();
			
			for (var i:int = 0; i < _jsonUrls.length; i++) 
			{
				multiLoader.addTask(_jsonUrls[i], _jsons[i]);
			}
			multiLoader.addEventListener(Event.COMPLETE, onCompleteJSON);
			multiLoader.start();
		}
		
		private function onCompleteJSON(e:Event):void 
		{
			Application.instance.logger.log("Loaded JSON Data");
		
			var multiLoader:MultiLoader = e.target as MultiLoader;
			multiLoader.removeEventListener(Event.COMPLETE, onCompleteJSON);
			
			Model.instance.config = JSON.parse(String(multiLoader.getItemContent(0)));
			Model.instance.config.hall = String(Model.instance.config.hall).toUpperCase();
			Model.instance.config.floor = FloorName.name[Model.instance.config.floor];
			
			Model.instance.rankings = JSON.parse(String(multiLoader.getItemContent(2))).tables;
			
			//brand
			var brands:Array = JSON.parse(String(multiLoader.getItemContent(1))).items;
			for (var i:int = 0; i < brands.length; i++) 
			{
				var obj:Object = brands[i];
				var brand:Brand = new Brand(obj);
				Model.instance.brands.push(brand);
			}
			Model.instance.setCategories();	//카테고리별로 브랜드를 미리 계산해 저장
			
			var temp:Array = Model.instance.brands;
			//shopping info
			var shoppingInfos:Array = JSON.parse(String(multiLoader.getItemContent(3))).items;
			var infoItems:Array = [];
			for (var j:int = 0; j < shoppingInfos.length; j++) 
			{
				var info:Object = shoppingInfos[j];
				var shoppingInfo:ShoppingInfo = new ShoppingInfo(info);
				infoItems.push(shoppingInfo);
			}
			Model.instance.shoppingInfos = infoItems;
			
			//main_slide
			trace( "String(multiLoader.getItemContent(4)) : " + String(multiLoader.getItemContent(4)) );
			var slideImages:Array = JSON.parse(String(multiLoader.getItemContent(4))).images;
			loadDynamicImages(slideImages);
			
			
		}
		
		private function loadDynamicImages(slideImages:Array):void
		{
			var multiLoader:MultiLoader = new MultiLoader();			
			
			for (var i:int = 0; i < slideImages.length; i++) 
			{
				multiLoader.addTask(slideImages[i], "slideImage"+i, MultiLoader.MOVIE);
				
				//Application.instance.logger.log("Start Loading Static Image [" + url +"]");
			}

			multiLoader.addEventListener(Event.COMPLETE, onCompleteDynamicImages);
			multiLoader.start();
		}
		
		private function onCompleteDynamicImages(e:Event):void 
		{
			var multiLoader:MultiLoader = e.target as MultiLoader;
			
			for (var i:int = 0; i < multiLoader.length; i++) 
			{
				var loader:Loader = Loader(multiLoader.getItemContent(i));
				if (loader == null)
				{
					trace( "name : " + multiLoader.getItemRegistrationName(i) );
				}
				var image:BitmapData = creatBitmapData(loader);
				
				Model.instance.mainSlideImages[i] = image;
			}
			
			multiLoader.removeEventListener(Event.COMPLETE, onCompleteDynamicImages);
			
			loadStaticImages();
		}
		
		private function loadStaticImages():void
		{
			
			var multiLoader:MultiLoader = new MultiLoader();
			var keys:Array = StaticImageUrl.commonImageKeys;
			var key:String;
			var url:String;
			
			
			for (var i:int = 0; i < keys.length; i++) 
			{
				key = StaticImageUrl.commonImageKeys[i];
				url = StaticImageUrl.getUrl(key);
				multiLoader.addTask(url, key, MultiLoader.MOVIE);
				
				//Application.instance.logger.log("Start Loading Static Image [" + url +"]");
			}
			
			keys = StaticImageUrl.imageKeys;
			
			for (var j:int = 0; j < keys.length; j++) 
			{
				for (var k:int = 0; k < 4; k++) 
				{
					key = StaticImageUrl.imageKeys[j];
					url = StaticImageUrl.getUrl(key, Language.all[k]);
					multiLoader.addTask(url, key + "@" + Language.all[k], MultiLoader.MOVIE);
					
					
					//Application.instance.logger.log("Start Loading Static Image [" + url +"]");
				}
				
			}
			multiLoader.addEventListener(Event.COMPLETE, onCompleteStaticImages);
			multiLoader.start();
			
		}

		
		private function onCompleteStaticImages(e:Event):void 
		{
			Application.instance.logger.log("Load Complete!!");
			
			var multiLoader:MultiLoader = e.target as MultiLoader;
			
			for (var i:int = 0; i < multiLoader.length; i++) 
			{
				var loader:Loader = Loader(multiLoader.getItemContent(i));
				
				if (loader == null)
				{
					trace( "name : " + multiLoader.getItemRegistrationName(i) );
				}
				var image:BitmapData = creatBitmapData(loader);
				var name:String = multiLoader.getItemRegistrationName(i);
				
				Model.instance.staticImages[name] = image;
			}
			
			multiLoader.removeEventListener(Event.COMPLETE, onCompleteStaticImages);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function loadIntroImage():void
		{
			//var multiLoader:MultiLoader = new MultiLoader();
			//
			//for (var i:int = 0; i < Model.instance.introXML.image.length(); i++) 
			//{
				//var url:String = Model.instance.introXML.image[i];
				//multiLoader.addTask(url, "intro" + i, MultiLoader.MOVIE);
				//
				//Application.instance.logger.log("Start Loading Intro Image [" + url +"]");
			//}
			//multiLoader.addEventListener(Event.COMPLETE, onCompleteIntroImage);
			//multiLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorIntroImage);
			//multiLoader.start();
			
			
		}
		
		private function onIOErrorIntroImage(e:IOErrorEvent):void 
		{
			trace( "onIOErrorIntroImage : " + onIOErrorIntroImage );
			
		}
		
		private function onCompleteIntroImage(e:Event):void 
		{
			//Application.instance.logger.log("Loaded Intro Images");
			//
			//var multiLoader:MultiLoader = e.target as MultiLoader;
			//
			//for (var i:int = 0; i < multiLoader.length; i++) 
			//{
				//var introImage:Bitmap = creatBitmap(Loader(multiLoader.getItemContent(i)));
				//
				//Model.instance.introImages.push(introImage);
			//}
			
		}
		
		private function creatBitmapData(loader:Loader, transparent:Boolean=true):BitmapData
		{
			//return loader.content as Bitmap;	//테스트용
			
			var bd:BitmapData = new BitmapData(loader.width, loader.height, true, 0);
			bd.draw(loader.content,null,null,null,null, true);
			return bd;
		}
	}

}





















