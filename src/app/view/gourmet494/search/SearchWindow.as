package app.view.gourmet494.search 
{
	import app.model.Model;
	import app.view.common.Button;
	import app.view.common.ImageBox;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quart;
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import com.greensock.TweenNano;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SearchWindow extends Sprite 
	{
		private var _bg:Shape;
		private var _closeBtn:Button;
		private var _tab:SearchTab;
		private var _searchForm:SearchForm;
		private var _keypad:KeypadBlack;
		private var _category:CategoryList;
		
		public function SearchWindow() 
		{
			super();
			
			_closeBtn = new Button([new ImageBox("gourmet/search_close"), new ImageBox("gourmet/search_close_press") ]);
			_closeBtn.alpha = 0;
			_closeBtn.visible = false;
			addChild(_closeBtn);
			
			_bg = new Shape();
			_bg.graphics.beginFill(0x121212);
			_bg.graphics.drawRect(0, 0, 1080, 800);
			_bg.y = 82;
			_bg.alpha = 0;
			addChild(_bg);
			
			_tab = new SearchTab();
			_tab.x = 100;
			_tab.y = 142;
			addChild(_tab);
			
			_keypad = new KeypadBlack();
			_keypad.x = 100;
			_keypad.y = 124 + 263;
			addChild(_keypad);
			
			_searchForm = new SearchForm(_keypad);
			_searchForm.x = 100;
			_searchForm.y = 263;
			addChild(_searchForm);
			
			_category = new CategoryList();
			_category.x = 100;
			_category.y = 263;
			_category.visible = false;
			addChild(_category);
			
			_tab.addEventListener(SearchTab.TAB_SELECT, tab_tabSelect);
			_searchForm.addEventListener(SearchForm.SEARCH, searcher_search);
			_closeBtn.addEventListener(MouseEvent.CLICK, onClickCloseBtn);
		}
		
		private function onClickCloseBtn(e:MouseEvent):void 
		{
			close();
		}
		
		private function searcher_search(e:Event):void 
		{
			close(0.4);
			TweenMax.delayedCall(0.6, search);
		}
		
		private function search():void 
		{
			Model.instance.searchFoods(_searchForm.keyword);
		}
		
		private function onUpdate():void 
		{
			//var gp:Point = _searcher.localToGlobal(new Point(_searcher.searchForm.x, _searcher.searchForm.y));
			//var lp:Point = parent.globalToLocal(gp);
			//
			//if (_searcher.searchForm.x == 100) return;
			//
			//if (lp.y > 1369)
			//{
				//_searcher.searchForm.x = 100;
				//_searcher.searchForm.y = 1369;
				//parent.addChild(_searcher.searchForm);
			//}
		}
		
		private function tab_tabSelect(e:Event):void 
		{
			if (_tab.selected == 0)
			{
				_searchForm.visible = true;
				_keypad.visible = true;
				_category.visible = false;
			}
			else
			{
				_searchForm.visible = false;
				_keypad.visible = false;
				_category.visible = true;
			}
		}
		
		public function open():void
		{
			_searchForm.bg.mouseEnabled = false;
			
			TweenMax.to(_tab, 0.3, { autoAlpha:1} );
			TweenMax.to(_keypad, 0.3, { autoAlpha:1} );
			TweenMax.to(_bg, 0.3, { autoAlpha:1} );
			TweenMax.to(_closeBtn, 0.3, { autoAlpha:1} );
			
			TweenNano.to(this, 0.3, { y:762, ease:Sine.easeInOut} );
		}
		
		public function close(sec:Number=0.3):void
		{
			_searchForm.bg.mouseEnabled = true;
			TweenMax.to(_tab, 0.2, { autoAlpha:0} );
			TweenMax.to(_keypad, 0.2, { autoAlpha:0 } );
			TweenMax.to(_bg, 0.2, { autoAlpha:0} );
			TweenMax.to(_closeBtn, 0.2, { autoAlpha:0} );
			
			_tab.tab1.dispatchEvent(new Event(Button.CLICK));
			
			TweenNano.to(this, sec, { y:1100, ease:Sine.easeInOut});
		}
	}

}