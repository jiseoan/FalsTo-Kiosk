package app.view.gourmet494.search 
{
	import app.text.TextFormatter;
	import app.view.common.Button;
	import app.view.common.ImageBox;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import mx.utils.StringUtil;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SearchForm extends Sprite 
	{
		public static const SEARCH:String = "search";
		
		private var _keypad:KeypadBlack;
		private var _bg:ImageBox;
		private var _btn:Button;
		private var _tf:TextField;
		private var _keyword:String;
		
		public function SearchForm(keypad:KeypadBlack) 
		{
			super();
			
			_keypad = keypad;
			
			_bg = new ImageBox("gourmet/search_field");
			_bg.mouseEnabled = false;
			_bg.width = 794;
			addChild(_bg);
			
			_btn = new Button([new ImageBox("gourmet/btn_search"), new ImageBox("gourmet/btn_search_press")]);
			_btn.x = _bg.width;
			addChild(_btn);
			
			_btn.addEventListener(Button.CLICK, btn_click);
			
			_tf = new TextField();
			_tf.x = 20;
			_tf.y = 20;
			_tf.width = _bg.width -40;
			_tf.mouseEnabled = false;
			TextFormatter.setTextFormat(_tf, 0xffffff, 24, MalgunGothicBold, "left", false);
			addChild(_tf);
			
			_keypad.addEventListener(KeypadBlack.UPDATE, onUpdateKeypad);
			_bg.addEventListener(MouseEvent.CLICK, onClickBg);
		}
		
		private function onClickBg(e:MouseEvent):void 
		{
			SearchWindow(parent).open();
		}
		
		private function onUpdateKeypad(e:Event):void 
		{
			_tf.text = _keypad.outputStr;
		}
		
		private function btn_click(e:Event):void 
		{
			trace( "btn_click : " + btn_click );
			_keyword = StringUtil.trim(_tf.text);
			dispatchEvent(new Event(SearchForm.SEARCH, true));
		}
		
		public function setText(keyword:String):void
		{
			_tf.text = keyword;
		}
		
		public function get keyword():String 
		{
			return _keyword;
		}
		
		public function get bg():ImageBox 
		{
			return _bg;
		}
	}

}