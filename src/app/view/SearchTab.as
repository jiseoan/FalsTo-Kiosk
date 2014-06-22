package app.view 
{
	import app.view.common.Button;
	import app.view.common.ImageBox;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SearchTab extends Sprite 
	{
		public static const TAB_SELECT:String = "tabSelect";
		
		private var _tab1:Button;
		private var _tab2:Button;
		
		private var _selected:int = 0;
		
		public function SearchTab() 
		{
			super();
			x = 100;
			
			_tab1 = new Button([new ImageBox("tab_search"), new ImageBox("tab_search_press")]);
			_tab2 = new Button([new ImageBox("tab_category"), new ImageBox("tab_category_press")]);
			
			_tab1.id = 0;
			_tab2.id = 1;
			
			_tab2.x = _tab1.width - 2;
			
			addChild(_tab2);
			
			_tab1.focus();
			addChild(_tab1);
			
			_tab1.addEventListener(Button.CLICK, tab_click);
			_tab2.addEventListener(Button.CLICK, tab_click);
		}
		
		private function tab_click(e:Event):void 
		{
			var t:Button = e.target as Button;
			
			if (t.id == _selected) return;
			
			_selected = t.id;
			t.focus();
			addChild(t);
			
			if (_selected == 0)
			{
				_tab2.up();
			}
			else
			{
				_tab1.up();
			}
			
			dispatchEvent(new Event(SearchTab.TAB_SELECT));
		}
		
		
		public function get selected():int 
		{
			return _selected;
		}
		
		public function get tab1():Button 
		{
			return _tab1;
		}

		
	}

}