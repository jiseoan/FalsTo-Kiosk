package app.view.gourmet494 
{
	import app.model.Model;
	import app.text.TextFormatter;
	import app.view.common.Button;
	import app.view.common.ImageBox;
	import flash.events.Event;
	import flash.text.TextField;
	/**
	 * ...
	 * @author joe
	 */
	public class MonthPagination extends MonthPaginationAsset 
	{
		public static const SELECT:String = "select";
		
		private var _btns:Array = [];
		private var _numTFs:Array = [];
		private var _prevBtn:Button;
		private var _nextBtn:Button;
		
		private var _focusBtn:Button;
		private var _curYear:int;
		private var _curMonth:int;
		
		private var _firstYear:int;
		private var _lastYear:int;
		
		public function MonthPagination() 
		{
			super();
			
			TextFormatter.setTextFormat(yearTF, 0xffffff, 34, MyriadProBold, "center", false, 0, true);
			TextFormatter.setTextFormat(prevYearTF, 0x9A9A9A, 24, MyriadProBold, "center", false, 0, true);
			TextFormatter.setTextFormat(nextYearTF, 0x9A9A9A, 24, MyriadProBold, "center", false, 0, true);
			
			for (var i:int = 0; i < 12; i++) 
			{
				var btn:Button = new Button([new ImageBox("gourmet/btn_page"), new ImageBox("gourmet/btn_page_press"), new ImageBox("gourmet/btn_page_disable"), new ImageBox("gourmet/btn_page_focus")]);
				btn.x = 174 + 61 * i;
				btn.y = 68;
				addChildAt(btn, 0);
				
				_btns.push(btn);
				
				btn.addEventListener(Button.CLICK, onClickBtn);
				btn.addEventListener(Button.UP, onUpBtn);
				btn.addEventListener(Button.FOCUS, onFocusBtn);
				btn.addEventListener(Button.DISABLE, onDisableBtn);
				
				var numTF:TextField = getChildByName("m" + (i + 1)) as TextField;
				numTF.text = i + 1 +"";
				numTF.mouseEnabled = false;
				TextFormatter.setTextFormat(numTF, 0xffffff, 24, MyriadProBold, "center", false, 0, true);
				_numTFs.push(numTF);
			}
			
			_prevBtn = new Button([new ImageBox("gourmet/btn_prev"), new ImageBox("gourmet/btn_prev_press")]);
			_prevBtn.x = 128;
			_prevBtn.y = 68;
			addChild(_prevBtn);
			_prevBtn.addEventListener(Button.CLICK, onClickPrevBtn);
			
			_nextBtn = new Button([new ImageBox("gourmet/btn_next"), new ImageBox("gourmet/btn_next_press")]);
			_nextBtn.x = 896;
			_nextBtn.y = 68;
			addChild(_nextBtn);
			_nextBtn.addEventListener(Button.CLICK, onClickNextBtn);
			
			var firstItem:Object = Model.instance.tastyCharts[Model.instance.tastyCharts.length-1];
			var lastItem:Object = Model.instance.tastyCharts[0];
			
			_firstYear = firstItem.year;
			_lastYear = lastItem.year;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			setYear(_lastYear, true );
		}
		
		private function onClickPrevBtn(e:Event):void 
		{
			setYear(_curYear-1)
		}
		
		private function onClickNextBtn(e:Event):void 
		{
			setYear(_curYear+1)
		}
		
		private function onClickBtn(e:Event):void 
		{
			var t:Button = e.target as Button;
			var index:int = _btns.indexOf(t);
			
			setMonth(index + 1);
		}
		
		private function onUpBtn(e:Event):void 
		{
			var t:Button = e.target as Button;
			var index:int = _btns.indexOf(t);
			
			var numTF:TextField = getChildByName("m" + (index + 1)) as TextField;
			TextFormatter.setTextFormat(numTF, 0xffffff, 24, MyriadProBold, "center", false, 0, true);
		}
		
		private function onFocusBtn(e:Event):void 
		{
			var t:Button = e.target as Button;
			var index:int = _btns.indexOf(t);
			
			var numTF:TextField = getChildByName("m" + (index + 1)) as TextField;
			TextFormatter.setTextFormat(numTF, 0x000000, 24, MyriadProBold, "center", false, 0, true);
		}
		
		private function onDisableBtn(e:Event):void 
		{
			var t:Button = e.target as Button;
			var index:int = _btns.indexOf(t);
			
			var numTF:TextField = getChildByName("m" + (index + 1)) as TextField;
			TextFormatter.setTextFormat(numTF, 0x777777, 24, MyriadProBold, "center", false, 0, true);
		}
		
		private function setYear(year:int, isFirstCall:Boolean = false):void
		{
			var charts:Array = Model.instance.tastyCharts;
			var items:Array = [];
			
			for (var i:int = 0; i < charts.length; i++) 
			{
				var item:Object = charts[i];
				if (item.year == year)
				{
					items[item.month-1] = item;
				}
			}
			
			var activeBtns:Array = [];
			
			for (i = 0; i < 12; i++) 
			{
				var btn:Button = _btns[i];
				//var numTF:TextField = _numTFs[i];
				
				if (items[i])
				{
					btn.up();
					activeBtns.push(btn);
				}
				else
				{
					btn.disable();
				}
			}
			
			if (year > _curYear)
			{
				_focusBtn = activeBtns[0];
			}
			else
			{
				_focusBtn = activeBtns[activeBtns.length-1];
			}
			
			//첫로드시 가장 최근월을 보여줌..
			if (isFirstCall) _focusBtn = activeBtns[activeBtns.length - 1];
			
			_focusBtn.focus();
			
			_prevBtn.up();
			_nextBtn.up();
			if (year <= _firstYear) {
				_prevBtn.disable();
			}
			if (year >= _lastYear) {
				_nextBtn.disable();
			}

			yearTF.text = year + "";
			prevYearTF.text = (year - 1) + "";
			nextYearTF.text = (year + 1) + "";
			
			_curYear = year;
			_curMonth = _btns.indexOf(_focusBtn) + 1;
			
			dispatchEvent(new Event(MonthPagination.SELECT));
		}
		
		private function setMonth(month:int):void
		{
			
			_focusBtn.up();
			
			_focusBtn = _btns[month - 1];
			_focusBtn.focus();
			
			_curMonth = month;
			
			dispatchEvent(new Event(MonthPagination.SELECT));
		}
		
		private function setChart(year:int, month:int):void
		{
			
		}
		
		public function get curYear():int 
		{
			return _curYear;
		}
		
		public function get curMonth():int 
		{
			return _curMonth;
		}
	}

}