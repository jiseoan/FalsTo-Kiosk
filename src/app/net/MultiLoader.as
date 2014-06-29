package app.net
{
	import app.Application;
	import flash.events.IOErrorEvent;	
	import flash.events.ProgressEvent;	
	import flash.display.LoaderInfo;	
	import flash.display.Loader;	
	import flash.net.URLRequest;	
	import flash.net.URLLoader;	
	import flash.events.Event;	
	import flash.events.EventDispatcher;	
	
	/**
	 * @author Samoiloff
	 */
	public class MultiLoader extends EventDispatcher {
		
		/**
		* Content format (swf, png, jpg, gif), used in <code>addTask()</code> method as <code>type</code> parameter
		*/
		public static const MOVIE:String	= "movie";
		
		
		/**
		* Content format (xml, html, txt), used in <code>addTask()</code> method as <code>type</code> parameter
		*/ 
		public static const TEXT:String	= "text";
		
		
		public static const ITEM_COMPLETE:String = "item_complete";
		
		private static const STATUS_AWAITING:String = "awaiting";
		private static const STATUS_LOADING:String = "loading";
		private static const STATUS_COMPLETE:String = "complete";


		/**
		* stores load tasks, every item of the array is array with elements:
		* <p>[0] - link</p>
		* <p>[1] - registration name</p>
		* <p>[2] - type // default : <code>TEXT</code></p>
		* <p>[3] - status // AWAITING: LOADING : COMPLETE</p>
		* <p>[4] - content</p>
		* <p>[5] - loader or urlLoader</p>
		*/
		private var load_arr:Array;
		
		/**
		* Stores loaded items. Used for search optimization. Property name is registration name.
		*/
		private var loaded_obj:Object;
		
		
		/**
		* Current item to load
		*/
		private var _currentIndex:int;
		
		
		/**
		* Constructor
		*/
		public function MultiLoader() {
			load_arr = new Array();
			loaded_obj = new Object();
		}
		
		/**
		* Add load task.
		* 
		* @param    url    Link to the resource
		* @param    registrationName    Registration name of the task. Use the registrationName to get access to the loaded content
		* @param    type    Type of the resourse 
		* 
		* @return    Number of tasks <code>TEXT</code>, or <code>MOVIE</code>. Default value is <code>TEXT</code>.
		*/
		public function addTask(url:String, registrationName:String, type:String = TEXT):int {
			var position:int = load_arr.length;
			
			var arr:Array = new Array();
			load_arr.push(arr);
			
			setItemURL(position, url);
			setItemRegistrationName(position, registrationName);
			setItemType(position, type);
			setItemStatus(position, STATUS_AWAITING);
			
			return length;
		}
		
		public function start ():void {
			_currentIndex = 0;
			loadItem();
			addEventListener(ITEM_COMPLETE, onItemComplete);
		}
		
		public function loadByXML(xmlLink:String):void {
			addTask(xmlLink, "settings");
			loadItem();
			addEventListener(ITEM_COMPLETE, onSettingsLoaded);
		}
		
		private function onSettingsLoaded(e:Event):void {
			removeEventListener(ITEM_COMPLETE, onSettingsLoaded);
			var xml:XMLList = (new XML(getItemContent(0))).children();
			
			for (var i:int =0; i<xml.length(); i++) {
				var xmlItem:XML = xml[i];
				if (xmlItem.@preload != "false") {
					var registrationName:String = xmlItem.name().toString();
					var url:String = xmlItem.children()[0];
					var type:String = getTypeByURL(url);
					if (type) {
						addTask(url, registrationName, type);
					} else {
						addTask(url, registrationName);
					}
				}
			}
			_currentIndex++;
			loadItem();
			addEventListener(ITEM_COMPLETE, onItemComplete);
			
		}
		
		private function getTypeByURL(url:String):String {
			var arr:Array = url.split(".");
			var ext:String = arr[arr.length - 1];
			var i:int = ext.search(/jpg|png|gif|swf/);
			var type:String;
			if (ext.search(/jpg|png|gif|swf/) >=0) type = MOVIE;
			return type;
		}

		
		public function get progress():Number {
			if (_currentIndex >= length) return 1;
			return (_currentIndex + itemProgress)/length; 
		}
		
		public function get itemProgress():Number {
			var progress:Number;
			switch (getItemType(_currentIndex)) {
				case TEXT:
					var urlLoader:URLLoader = URLLoader(getItemLoader(_currentIndex));
					progress = urlLoader.bytesLoaded / urlLoader.bytesTotal;
				break;
				case MOVIE:
					var loader:Loader = Loader(getItemLoader(_currentIndex));
					progress = loader.contentLoaderInfo.bytesLoaded / loader.contentLoaderInfo.bytesTotal;
					break;
				default:
				break;
			}
			return progress;
		}
		
		public function getContentByRegistrationName(registrationName:String):Object {
			return loaded_obj[registrationName];
		}
		
		public function isPropertyRegistered(registrationName:String):Boolean {
			return Boolean(loaded_obj[registrationName]);
		}
		
		private function loadItem():void {
			var urlRequest:URLRequest = new URLRequest(getItemURL(_currentIndex));
			setItemStatus(_currentIndex, STATUS_LOADING); 
			switch (getItemType(_currentIndex)) {
				case TEXT:
					var urlLoader:URLLoader = new URLLoader();
					urlLoader.addEventListener(Event.COMPLETE, onItemLoaded);
					urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
					urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
					urlLoader.load(urlRequest);
					setItemLoader(_currentIndex, urlLoader);
					break;
				case MOVIE:
					var loader:Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onItemLoaded);
					loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
					loader.load(urlRequest);
					setItemLoader(_currentIndex, loader);
				break;
				default:
					throw new Error("Wrong task type in task at position " + _currentIndex + ": link" + getItemURL(_currentIndex));
				break;
			}
		}
		
		private function onProgress(e:Event):void {
			dispatchEvent(e);
		}
		
		private function onError(e:IOErrorEvent):void {
			setItemStatus(_currentIndex, STATUS_COMPLETE);
			setItemContent(_currentIndex, null);
			dispatchEvent(new Event(ITEM_COMPLETE));
		}		
		
		private function onItemLoaded(e:Event):void {
			switch (getItemType(_currentIndex)) {
				case TEXT:
					setItemContent(_currentIndex, URLLoader(e.target).data);
				break;
				case MOVIE:
					setItemContent(_currentIndex, LoaderInfo(e.target).loader);
				break;
				default:
					throw new Error("Wrong task type in task at position " + _currentIndex + ": link" + getItemURL(_currentIndex));
				break;
			}
			
			//Application.instance.logger.log(getItemURL(_currentIndex));
			trace(getItemURL(_currentIndex));
			setItemStatus(_currentIndex, STATUS_COMPLETE);
			dispatchEvent(new Event(ITEM_COMPLETE));
		}

		
		
		private function onItemComplete(e:Event):void {
			_currentIndex++;
			if (_currentIndex < length) {
				loadItem();
			} else {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		
		//url
		private function getItemURL(i:int):String {
			if (i >= length) i = length -1;
			return load_arr[i][0];
		}
		public function setItemURL(i:int, str:String):void {
			load_arr[i][0] = str;
		}
		//registrationName
		public function getItemRegistrationName(i:int):String {
			if (i >= length) i = length -1;
			return load_arr[i][1];
		}
		private function setItemRegistrationName(i:int, str:String):void {
			load_arr[i][1] = str;
		}
		//type
		public function getItemType(i:int):String {
			if (i >= length) i = length -1;
			return load_arr[i][2];
		}
		private function setItemType(i:int, str:String):void {
			load_arr[i][2] = str;
		}
		//status
		public function getItemStatus(i:int):String {
			if (i >= length) i = length -1;
			return load_arr[i][3];
		}
		private function setItemStatus(i:int, str:String):void {
			load_arr[i][3] = str;
		}
		//content
		public function getItemContent(i:int):Object {
			if (i >= length) i = length -1;
			return load_arr[i][4];
		}
		private function setItemContent(i:int, obj:Object):void {
			loaded_obj[getItemRegistrationName(i)] = obj;
			load_arr[i][4] = obj;
		}
		//content
		public function getItemLoader(i:int):Object {
			if (i >= length) i = length -1;
			return load_arr[i][5];
		}
		private function setItemLoader(i:int, obj:Object):void {
			loaded_obj[getItemRegistrationName(i)] = obj;
			load_arr[i][5] = obj;
		}
		//length
		public function get length ():int {
			return load_arr.length;
		}
		
		public function get currentIndex():int {
			return _currentIndex;
		}
	}
}
