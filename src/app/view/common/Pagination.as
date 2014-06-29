package app.view.common 
{
	import app.model.Model;
	import app.text.TextFormatter;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author joe
	 */
	public class Pagination extends Sprite 
	{
		public static const UPDATE:String = "update";
		
		private var _curPage:int;
		private var _totalPages:int;
		private var _curGroup:int;
		private var _totalGroups:int;
		
		private var _pageBtns:Array = [];
		private var _prevBtn:Button;
		private var _nexBtn:Button;
		
		public function Pagination(totalPages:int=1) 
		{
			_prevBtn = new Button([new ImageBox("btn_prev"), new ImageBox("btn_prev_press")]);
			_prevBtn.addEventListener(Button.CLICK, onClickPrevBtn, false, 0, true);
			addChild(_prevBtn);
			
			_nexBtn = new Button([new ImageBox("btn_next"), new ImageBox("btn_next_press")]);
			_nexBtn.addEventListener(Button.CLICK, onClickNextBtn, false, 0, true);
			addChild(_nexBtn);
			
			for (var i:int = 1; i <=5; i++) 
			{
				var pageBtn:Button = new Button([new ImageBox("btn_page"), new ImageBox("btn_page_press"), , new ImageBox("btn_page_focus")]);
				pageBtn.x = 61 + (i-1) * 61;
				pageBtn.id = i;
				var tf:TextField = new TextField();
				tf.y = 12;
				tf.width = 61;
				tf.mouseEnabled = false;
				TextFormatter.setTextFormat(tf, 0x787878, 24, MyriadPro, "center", false, 0, true);
				
				pageBtn.tf = tf;
				pageBtn.addChild(tf);
				
				pageBtn.addEventListener(Button.CLICK, onClickPageBtn, false, 0, true);
				addChild(pageBtn);
				
				_pageBtns.push(pageBtn);
			}
			
			update(1, totalPages);
		}
		
		private function onClickPageBtn(e:Event):void 
		{
			var t:Button = e.currentTarget as Button;
			update((_curGroup-1)*5 + t.id, _totalPages);
		}
		
		private function onClickNextBtn(e:Event):void 
		{
			var page:int = _curGroup * 5 + 1;
			update(page, _totalPages);
		}
		
		private function onClickPrevBtn(e:Event):void 
		{
			var page:int = (_curGroup-2) * 5 + 5;
			update(page, _totalPages);
		}
		
		public function update(curPage:int, totalPages:int):void
		{
			if (totalPages == 0)
			{
				totalPages = 1;
			}
			
			_curPage = curPage;
			_totalPages = totalPages;
			
			_totalGroups = Math.floor((_totalPages-1) / 5) + 1;
			_curGroup = Math.floor((_curPage-1) / 5) + 1;
			
			var lastBtnId:int = 0;
			
			for (var i:int = 1; i <= 5; i++) 
			{
				var pageBtn:Button = _pageBtns[i - 1];
				var page:int = (_curGroup - 1) * 5 + i;
				
				
				pageBtn.tf.text = page.toString();
				
				if (pageBtn.id == (_curPage-1)%5+1)
				{
					TextFormatter.setTextFormat(pageBtn.tf, 0xffffff, 24, MyriadProBold, "center", false, 0, true);
					
					pageBtn.focus();
					pageBtn.mouseEnabled = false;
				}
				else
				{
					TextFormatter.setTextFormat(pageBtn.tf, 0x787878, 24, MyriadProBold, "center", false, 0, true);
					
					pageBtn.up();
					pageBtn.mouseEnabled = true;
				}
				
				if (page > _totalPages)
				{
					pageBtn.visible = false;
				}
				else
				{
					pageBtn.visible = true;
					lastBtnId = pageBtn.id;
				}
			}
			
			_prevBtn.alpha = 1;
			_prevBtn.up();
			_nexBtn.alpha = 1;
			_nexBtn.up();
				
			if (_curGroup == 1)
			{
				_prevBtn.alpha = 0.5;
				_prevBtn.disable();
			}
			if (_curGroup == _totalGroups)
			{
				_nexBtn.alpha = 0.5;
				_nexBtn.disable();
			}
			
			_nexBtn.x = 61 + (lastBtnId - 1) * 61 + 61;
			x =  Math.round((1080 / 2) -((_nexBtn.x+_nexBtn.width) / 2));
			
			dispatchEvent(new Event(Pagination.UPDATE));
		}
		
		public function get curPage():int 
		{
			return _curPage;
		}
	}

}