package app.model
{
	import app.view.IView;
	import com.greensock.easing.Elastic;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author joe
	 */
	public class Model extends EventDispatcher 
	{
		public static const UPDATE_MODE:String = "upateMode";
		public static const UPDATE_GOURMET_MODE:String = "upateGourmetMode";
		public static const CHANGE_LANGUAGE:String = "changeLanguage";
		public static const COMPLETE_SEARCH:String = "completeSearch";
		public static const COMPLETE_SEARCH_FOOD:String = "completeSearchFood";
		
		private static var _instance:Model;
		
		private var _mode:int = 0;
		private var _gourmetMode:int = 0;
		
		private var _lang:String = Language.KOREAN;
		
		public var screensaverMode:Boolean;
		
		public var config:Object;
		public var mallInfo:Object;
		
		public var appid:String;
		public var brands:Array = [];
		public var foods:Array = [];
		public var rankings:Array = [];
		private var _shoppingInfos:Array = [];
		
		public var searchWord:String;
		public var searchedBrands:Array = [];
		public var searchedFoods:Array = [];
		
		public var staticImages:Object = { };
		
		public var mainSlideImages:Array = [];
		
		private var _categoryBrands:Object = { };		//카테고리별로 브랜드를 미리 계산해 저장
		private var _categoryNames:Object = { };
		
		private var _prevView:IView;
		private var _curView:IView;
		
		public var floorViewInitObj:Object = null;
		
		//gourmet494관련 데이터
		public var gourmetSlideImages:Array = [];
		public var onlyGalleriaItems:Array = [];
		public var tastyCharts:Array = [];
		
		public var fromGourmetView:Boolean = false;
		
		
		public function Model() 
		{
			
		}
		
		public function getBrandById(id:String):Brand
		{
			
			var n:int = brands.length;
			for (var i:int = 0; i < n; i++) 
			{
				var brand:Brand = brands[i];
				if (brand.data.iditem == id)
				{
					return brand;
				}
			}
			
			return null;
		}
		
		public function getBrandsByHallFloor(hall:String, floor:String):Array
		{
			var output:Array = [];
			var leng:int = brands.length;
			
			for (var i:int = 0; i < leng; i++) 
			{
				var brand:Brand = brands[i];
				if (brand.data.hall == hall && brand.data.floor == floor)
				{
					var d:Object = brand.data;
					output.push({category:d.category, name:d.name[_lang], brand:brand});
				}
			}
			
			output.sortOn(['category', 'name']);
			return output;
		}
		
		public function getRankingsByFloor(floor:String):Array
		{
			var output:Array = [];
			var leng:int = rankings.length;
			
			for (var i:int = 0; i < leng; i++) 
			{
				var ranking:Object = rankings[i];
				if (ranking.floor ==  floor && ranking.list.length!=0)
				{
					output.push(ranking);
				}
			}
			
			return output;
		}
		
		public function searchBrands2(keyword:String):void
		{
			if (keyword == "")
			{
				searchedBrands = brands.concat();
				dispatchEvent(new Event(Model.COMPLETE_SEARCH));
				return;
			}
			
			searchedBrands = [];
			
			for (var i:int = 0; i < brands.length; i++) 
			{
				var brand:Brand = brands[i] as Brand;
				if (brand.data.name.kor.indexOf(keyword) != -1)
				{
					searchedBrands.push(brand);
					continue;
				}
				
				if (brand.data.name.eng.indexOf(keyword) != -1)
				{
					searchedBrands.push(brand);
					continue;
				}
			}
			dispatchEvent(new Event(Model.COMPLETE_SEARCH));
		}
		
		public function getAllCategory():Array
		{
			var output:Array = [];
			
			var leng:int = brands.length;
			
			for (var i:int = 0; i < leng; i++) 
			{
				var brand:Brand = brands[i];
				if (output.indexOf(brand.data.category)==-1)
				{
					output.push(brand.data.category);
				}
			}
			
			return output;
		}
		
		public function getAllFoodCategory():Array
		{
			var output:Array = [];
			
			var leng:int = foods.length;
			
			for (var i:int = 0; i < leng; i++) 
			{
				var food:Food = foods[i];
				if (output.indexOf(food.data.category)==-1)
				{
					output.push(food.data.category);
				}
			}
			
			return output;
		}
		
		public function setCategories():void
		{
			var output:Array = [];
			
			var leng:int = brands.length;
			
			for (var i:int = 0; i < leng; i++) 
			{
				var brand:Brand = brands[i];
				var key:String = brand.data.hall + brand.data.floor;
				
				if (!_categoryBrands[key])
				{
					_categoryBrands[key] = [];
					_categoryNames[key] = [];
				}
				_categoryBrands[key].push(brand);
				
				if (_categoryNames[key].indexOf(brand.data.category)==-1) {
					_categoryNames[key].push(brand.data.category);
				}
				
			}
		}

		
		public function getCategoryBrandsByHallFloor(hall:String, floor:String):Array
		{
			var output:Array = _categoryBrands[hall + floor];
			if (!output) output = [];
			return output;
		}
		
		public function getCategoryNamesByHallFloor(hall:String, floor:String):Array
		{
			var output:Array = _categoryNames[hall + floor];
			if (!output) output = [];
			return output;
		}
		
		public function searchByCategory(category:String):void
		{
			searchedBrands = [];
			
			var leng:int = brands.length;
			
			for (var i:int = 0; i < leng; i++) 
			{
				var brand:Brand = brands[i];
				if (brand.data.category == category)
				{
					searchedBrands.push(brand);
				}
			}
			
			
			dispatchEvent(new Event(Model.COMPLETE_SEARCH));
		}
		
		public function searchFoodsByCategory(category:String):void
		{
			searchedFoods = [];
			
			var leng:int = foods.length;
			
			for (var i:int = 0; i < leng; i++) 
			{
				var food:Food = foods[i];
				if (food.data.category == category)
				{
					searchedFoods.push(food);
				}
			}
			
			
			dispatchEvent(new Event(Model.COMPLETE_SEARCH_FOOD));
		}
		
		public function searchBrands(keyword:String):void
		{
			searchWord = keyword;
			
			if (keyword == "")
			{
				searchedBrands = brands.concat();
				dispatchEvent(new Event(Model.COMPLETE_SEARCH));
				return;
			}
			
			searchedBrands = [];
			
			for (var i:int = 0; i < brands.length; i++) 
			{
				var brand:Brand = brands[i] as Brand;
				if (brand.data.name.eng.search(keyword) >= 0 || Searcher.search(keyword, brand.data.name.kor) || Searcher.search(keyword, brand.data.tag))
				{
					searchedBrands.push(brand);
				}
			}
			
			dispatchEvent(new Event(Model.COMPLETE_SEARCH));
		}
		
		public function searchFoods(keyword:String):void
		{
			searchWord = keyword;
			
			if (keyword == "")
			{
				searchedFoods = foods.concat();
				dispatchEvent(new Event(Model.COMPLETE_SEARCH_FOOD));
				return;
			}
			
			searchedFoods = [];
			
			for (var i:int = 0; i < foods.length; i++) 
			{
				var food:Food = foods[i] as Food;
				if (food.data.name.eng.search(keyword) >= 0 || Searcher.search(keyword, food.data.name.kor) || Searcher.search(keyword, food.data.tag))
				{
					searchedFoods.push(food);
				}
			}
			
			dispatchEvent(new Event(Model.COMPLETE_SEARCH_FOOD));
		}

		//TODO
		public function destroy():void
		{
			var i:int;
			var bd:BitmapData;
			
			for (i = 0; i < brands.length; i++) 
			{
				var brand:Brand = brands[i];
				if(brand.image && brand.image.bitmapData) brand.image.bitmapData.dispose();
			}
			
			for (i = 0; i < mainSlideImages.length; i++) 
			{
				bd = mainSlideImages[i] as BitmapData;
				bd.dispose();
			}
			
			for (i = 0; i < _shoppingInfos.length; i++) 
			{
				var info:ShoppingInfo = _shoppingInfos[i];
				if(info.thumbnail && info.thumbnail.bitmapData) info.thumbnail.bitmapData.dispose();
				
				for (var j:int = 0; j < info.detailImages.length; j++) 
				{
					var image:Bitmap = info.detailImages[j];
					if(image && image.bitmapData) image.bitmapData.dispose();
				}
			}
			
			for (var name:String in staticImages) 
			{
				var bmd:BitmapData = staticImages[name];
				bmd.dispose();
			}
			
			for (i = 0; i < gourmetSlideImages.length; i++) 
			{
				bd = gourmetSlideImages[i] as BitmapData;
				bd.dispose();
			}
			
			_instance = null;
		}
		
		static public function get instance():Model 
		{
			if (_instance == null)
			{
				_instance = new Model();
			}
			
			return _instance;
		}
		
		public function get mode():int 
		{
			return _mode;
		}
		
		public function set mode(value:int):void 
		{
			if (_mode == value) return;
			
			_mode = value;
			dispatchEvent(new Event(Model.UPDATE_MODE));
		}
		
		public function get prevView():IView 
		{
			return _prevView;
		}
		
		public function set prevView(value:IView):void 
		{
			_prevView = value;
		}
		
		//public function get curView():IView 
		//{
			//return _curView;
		//}
		//
		//public function set curView(value:IView):void 
		//{
			//_curView = value;
		//}
		
		public function get lang():String 
		{
			return _lang;
		}
		
		public function set lang(value:String):void 
		{
			if (_lang == value) return;
			_lang = value;
			trace( "_lang : " + _lang );
			dispatchEvent(new Event(Model.CHANGE_LANGUAGE));
		}
		
		static public function set instance(value:Model):void 
		{
			_instance = value;
		}
		
		public function get shoppingInfos():Array 
		{
			var output:Array = [];
			var info:ShoppingInfo;
			
			//개시기간을 체크하여 지난 쇼핑인포 아이템를 제거
			for (var i:int = 0; i < _shoppingInfos.length; i++) 
			{
				info = _shoppingInfos[i];
				
				var begin:Date = getDate(info.data["post-begin"]);
				var end:Date = getDate(info.data["post-end"]);
				var now:Date = new Date();
				
				if (now.getTime()>begin.getTime() && now.getTime()<end.getTime())
				{
					output.push(_shoppingInfos[i]);
				}
			}
			
			//Gourmet에서 쇼핑뷰로 이동했을 경우
			if (fromGourmetView)
			{
				var site1:Array = [];
				var site2:Array = [];	//gourmet494관련된 쇼핑인포 저장(site == 2)
				
				for (var j:int = 0; j < output.length; j++) 
				{
					info = output[j];
					if (info.data.site == "2")
					{
						site2.push(info);
					}
					else
					{
						site1.push(info);
					}
				}
				
				return site2.concat(site1);
			}
			else
			{
				return output;
			}
			
			
		}
		
		public function set shoppingInfos(value:Array):void 
		{
			_shoppingInfos = value;
		}
		
		public function get gourmetMode():int 
		{
			return _gourmetMode;
		}
		
		public function set gourmetMode(value:int):void 
		{
			trace( "value : " + value );
			//if (value == 0)
			//{
				//_gourmetMode = 0;
				//return;
			//}
			
			if (_gourmetMode == value) return;
			
			_gourmetMode = value;
			dispatchEvent(new Event(Model.UPDATE_GOURMET_MODE));
		}

		public function syncGourmetMode(value:int):void
		{
			_gourmetMode = value;
		}
		
		private function getDate(s:String):Date
		{
			var arr:Array = s.split(" ");
			var d:Array = arr[0].split("-");
			var t:Array = arr[1].split(":");
			
			return new Date(d[0], int(d[1])-1, d[2], t[0], t[1], t[2]);
		}

	}

}