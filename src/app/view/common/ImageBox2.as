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
	public class ImageBox2 extends Sprite 
	{
		private var _bitmap:Bitmap;
		private var _bitmapDatas:Object;
		
		public function ImageBox2(bitmapDatas:Array) 
		{
			super();
			_bitmapDatas = bitmapDatas;
			_bitmap = new Bitmap(_bitmapDatas[Language.all.indexOf(Model.instance.lang)], "auto", true);
				
			addChild(_bitmap);
			
			Model.instance.addEventListener(Model.CHANGE_LANGUAGE, onChangeLanguage);
			
		}
		
		private function onChangeLanguage(e:Event):void 
		{
			_bitmap.bitmapData = _bitmapDatas[Language.all.indexOf(Model.instance.lang)];
		}
		
	}

}