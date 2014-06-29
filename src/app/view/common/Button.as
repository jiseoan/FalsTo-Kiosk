package app.view.common 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author ...
	 */
	dynamic public class Button extends Sprite 
	{
		public static const CLICK:String = "buttonClick";
		public static const UP:String = "buttonUp";
		public static const DOWN:String = "buttonDown";
		public static const FOCUS:String = "buttonFocus";
		public static const DISABLE:String = "buttonDisable";
		
		private var _status:Array;
		private var _focused:Boolean = false;
		private var _disabled:Boolean = false;
		
		public function Button(status:Array) 
		{
			super();
			
			_status = status;
			addChild(status[0]);
			
			buttonMode = true;
			mouseChildren = false;
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onMouseOut(e:MouseEvent):void 
		{
			if (_focused || _disabled) return;
			
			up();
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			if (_focused || _disabled) return;
			
			down();
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			if (_focused || _disabled) return;
			
			up();
			dispatchEvent(new Event(Button.CLICK));
		}
		
		private function onClick(e:MouseEvent):void 
		{
			
			
		}
		
		public function up():void
		{
			mouseEnabled = true;
			
			removeChildAt(0);
			addChildAt(_status[0], 0);
			
			_focused = false;
			_disabled = false
			dispatchEvent(new Event(Button.UP));
		}
		
		public function down():void
		{
			mouseEnabled = true;
			
			removeChildAt(0);
			addChildAt(_status[1] , 0);
			dispatchEvent(new Event(Button.DOWN));
		}
		
		public function focus():void
		{
			mouseEnabled = false;
			
			removeChildAt(0);
			
			addChildAt(_status[_status.length-1], 0);
			
			
			_focused = true;
			dispatchEvent(new Event(Button.FOCUS));
		}
		
		public function disable():void
		{
			mouseEnabled = false;
			
			if (_status[2])
			{
				removeChildAt(0);
				addChildAt(_status[2], 0);
			}
			
			_disabled = true;
			dispatchEvent(new Event(Button.DISABLE));
		}
	}

}