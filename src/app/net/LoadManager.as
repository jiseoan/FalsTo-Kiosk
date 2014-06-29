package app.net 
{
	import app.Application;
	import app.model.Brand;
	import app.model.FloorName;
	import app.model.Food;
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
		
		private var _jsons:Array = ["configure", "brand", "ranking", "shopping_info", "main_slide", "gourmet_slide", "only_galleria", "menu", "tasty_chart"];
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
			var i:int;
			
			Application.instance.logger.log("Loaded JSON Data");
		
			var multiLoader:MultiLoader = e.target as MultiLoader;
			multiLoader.removeEventListener(Event.COMPLETE, onCompleteJSON);
			
			Model.instance.config = JSON.parse(String(multiLoader.getItemContent(0)));
			Model.instance.config.hall = String(Model.instance.config.hall).toUpperCase();
			Model.instance.config.floor = FloorName.name[Model.instance.config.floor];
			
			Model.instance.rankings = JSON.parse(String(multiLoader.getItemContent(2))).tables;
			
			//brand
			var brands:Array = JSON.parse(String(multiLoader.getItemContent(1))).items;
			var brandMap:Object = { };
			for (i = 0; i < brands.length; i++) 
			{
				var brandObj:Object = brands[i];
				var brand:Brand = new Brand(brandObj);
				Model.instance.brands.push(brand);
				
				brandMap[brandObj.iditem] = brand;
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
			var slideImages:Array = JSON.parse(String(multiLoader.getItemContent(4))).images;
			
			//gourmet_slide
			var gourmetSlideImages:Array = JSON.parse(String(multiLoader.getItemContent(5))).images;
			
			
			//only_galleria
			var onlyGalleriaItems:Array = JSON.parse(String(multiLoader.getItemContent(6))).items;
			
			//food menu
			var foods:Array = JSON.parse(String(multiLoader.getItemContent(7))).items;
			for (i = 0; i < foods.length; i++) 
			{
				var foodObj:Object = foods[i];
				var b:Brand = brandMap[foodObj.idbrand];
				foodObj.category = b.data.category;
				b.data.isFoodStore = true;	//지하 음식매장인경우 (Gourmet494)
				
				var food:Food = new Food(foodObj);
				Model.instance.foods.push(food);
			}
			
			//tasty_chart
			var charts:Array = JSON.parse(String(multiLoader.getItemContent(8))).items;
			var newCharts:Array = [];
			var now:Date = new Date();
			var year:int = now.getFullYear();
			var month:int = now.getMonth() + 1;
			
			for (i = 0; i < charts.length; i++) 
			{
				var chartItem:Object = charts[i];
				chartItem.year = int(chartItem.year);
				chartItem.month = int(chartItem.month);
				
				if (chartItem.year * 100 + chartItem.month < year * 100 + month)
				{
					newCharts.push(chartItem);
				}
				
			}
			Model.instance.tastyCharts = newCharts;
			
			var obj:Object = { };
			obj.slideImages = slideImages;
			obj.gourmetSlideImages = gourmetSlideImages;
			obj.onlyGalleriaItems = onlyGalleriaItems;
			loadDynamicImages(obj);
		}
		
		private function loadDynamicImages(obj:Object):void
		{
			var multiLoader:MultiLoader = new MultiLoader();			
			
			for (var i:int = 0; i < obj.slideImages.length; i++) 
			{
				multiLoader.addTask(obj.slideImages[i], "mainSlideImage_"+i, MultiLoader.MOVIE);
				
				//Application.instance.logger.log("Start Loading Static Image [" + url +"]");
			}

			for (i = 0; i < obj.gourmetSlideImages.length; i++) 
			{
				multiLoader.addTask(obj.gourmetSlideImages[i], "gourmetSlideImage_"+i, MultiLoader.MOVIE);
				
			}
			
			var item:Object;
			var lang:Array = Language.all;
			for (i = 0; i < obj.onlyGalleriaItems.length; i++) 
			{
				item = obj.onlyGalleriaItems[i];
				
				for (var j:int = 0; j < 4; j++) 
				{
					multiLoader.addTask(item.thumbnail[lang[j]], "onlyGalleriaItems_thumbnail_"+lang[j]+"_"+i, MultiLoader.MOVIE);
					multiLoader.addTask(item.text[lang[j]], "onlyGalleriaItems_text_"+lang[j]+"_"+i, MultiLoader.MOVIE);
					multiLoader.addTask(item.image[lang[j]], "onlyGalleriaItems_image_"+lang[j]+"_"+i, MultiLoader.MOVIE);
				}
			}
			
			multiLoader.addEventListener(Event.COMPLETE, onCompleteDynamicImages);
			multiLoader.start();
		}
		
		private function onCompleteDynamicImages(e:Event):void 
		{
			var multiLoader:MultiLoader = e.target as MultiLoader;
			var loader:Loader;
			var name:String;
			var id:int;
			var arr:Array;
			
			for (var i:int = 0; i < multiLoader.length; i++) 
			{
				loader = Loader(multiLoader.getItemContent(i));
				name = multiLoader.getItemRegistrationName(i);
				
				if (loader == null)
				{
					trace( "name : " +  name);
				}

				var image:BitmapData = creatBitmapData(loader);
				
				if (name.indexOf("mainSlideImage") != -1)
				{
					id = int(name.split("_")[1]);
					Model.instance.mainSlideImages[id] = image;
				}
				else if (name.indexOf("gourmetSlideImage") != -1)
				{
					id = int(name.split("_")[1]);
					Model.instance.gourmetSlideImages[id] = image;
				}
				else if (name.indexOf("onlyGalleriaItems") != -1)
				{
					arr = name.split("_");
					id = arr[3];
					
					if (!Model.instance.onlyGalleriaItems[id]) Model.instance.onlyGalleriaItems[id] = { };
					
					Model.instance.onlyGalleriaItems[id][arr[1] + "@" + arr[2]] = image;
					
				}
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
			
			var bitmap:Bitmap = loader.content as Bitmap;
			return bitmap.bitmapData;

			//return new BitmapData(0, 0);
			
			//var bd:BitmapData = new BitmapData(loader.width, loader.height, true, 0);
			//bd.draw(loader.content,null,null,null,null, true);
			//return bd;
		}
	}

}





















