package app.view 
{
	import app.text.TextFormatter;
	import app.view.common.ImageBox;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author joe
	 */
	public class SearchAlert extends Sprite 
	{
		private var _alert:ImageBox;
		private var _keywordTF:TextField;
		
		public function SearchAlert() 
		{
			super();
			
			visible = false;
			
			_keywordTF = new TextField();
			_keywordTF.x = 235;
			_keywordTF.width = 730;
			_keywordTF.height = 46;
			TextFormatter.setTextFormat(_keywordTF, 0x000000, 36, MalgunGothicBold, "left", false);
			
			addChild(_keywordTF);
			
			_alert = new ImageBox("alert_nodata_search", true);
			_alert.y = 60;
			addChild(_alert);
			
			
		}
		
		
		public function open(keyword:String):void
		{
			_keywordTF.text = "'" + keyword +"'";
			visible = true;
		}
		
		public function close():void
		{
			visible = false;
		}
	}

}