package app.view 
{
	import app.model.Language;
	import app.model.Model;
	import app.view.common.Button;
	import app.view.common.ImageBox;
	import app.view.common.Window;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author joe
	 */
	public class LanguageWindow extends Window 
	{
		private var _title:ImageBox;
		private var _body:ImageBox;
		
		private var _btns:Array = [];
		
		public function LanguageWindow(w:int, h:int) 
		{
			super(w, h);
			
			_body = new ImageBox("desc_language", false);
			addChild(_body);
			
			_title = new ImageBox("title_select_language", true);
			addChild(_title);
			
			var keys:Array = ["btn_kor", "btn_eng", "btn_chn", "btn_jpn"];
			for (var i:int = 0; i < 4; i++) 
			{
				var btn:Button = new Button([new ImageBox(keys[i]), new ImageBox(keys[i] + "_press")]);
				btn.x = 80 + 157 * i;
				btn.y = 574;
				btn.id = i;
				
				addChild(btn);
				_btns.push(btn);
				
				if (Language.all[i] == Model.instance.lang)
				{
					btn.focus();
				}
				
				btn.addEventListener(Button.CLICK, onClick);
			}
			
			Model.instance.addEventListener(Model.CHANGE_LANGUAGE, onChangeLanguage);
		}
		
		private function onChangeLanguage(e:Event):void 
		{
			for (var i:int = 0; i < 4; i++) 
			{
				var btn:Button = _btns[i] as Button;

				if (Language.all[i] == Model.instance.lang)
				{
					btn.focus();
				}
				else
				{
					btn.up();
				}
			}
		}
		
		private function onClick(e:Event):void 
		{
			var t:Button = e.target as Button;
			Model.instance.lang = Language.all[t.id];
			
			
		}
		
		
		
	}

}
