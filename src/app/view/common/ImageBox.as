package app.view.common 
{
	import app.model.Language;
	import app.model.Model;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author joe
	 */
	public class ImageBox extends Sprite 
	{
		private var _key:String;
		private var _bitmap:Bitmap;
		
		public function ImageBox(key:String, isLanguage:Boolean = false) 
		{
			super();
			_key = key;
			
			if (isLanguage)
			{
				_bitmap = new Bitmap(Model.instance.staticImages[key + "@" + Model.instance.lang], "auto", true);
				
				addChild(_bitmap);
				
				Model.instance.addEventListener(Model.CHANGE_LANGUAGE, onChangeLanguage);
			}
			else
			{
				_bitmap = new Bitmap(Model.instance.staticImages[key], "auto", true);
				addChild(_bitmap);
			}
			
		}
		
		private function onChangeLanguage(e:Event):void 
		{
			_bitmap.bitmapData = Model.instance.staticImages[_key + "@" + Model.instance.lang];
		}
		
	}

}