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
		
		private var _status:Array;
		private var _focused:Boolean = false;
		
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
			if (_focused) return;
			
			up();
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			if (_focused) return;
			
			down();
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			if (_focused) return;
			
			up();
			dispatchEvent(new Event(Button.CLICK));
		}
		
		private function onClick(e:MouseEvent):void 
		{
			
			
		}
		
		public function up():void
		{
			removeChildAt(0);
			addChildAt(_status[0], 0);
			
			_focused = false;
		}
		
		public function down():void
		{
			removeChildAt(0);
			addChildAt(_status[1] ,0);
		}
		
		public function focus():void
		{
			removeChildAt(0);
			
			addChildAt(_status[_status.length-1], 0);
			
			
			_focused = true;
		}
	}

}