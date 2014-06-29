package app.view.gourmet494 
{
	import app.view.common.Button;
	import app.view.common.ImageBox;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author joe
	 */
	public class Scroller extends Sprite 
	{
		private var _handle:Button;
		private var _target:Sprite;
		private var _boundaryH:Number;
		
		public function Scroller(target:Sprite, boundaryH:Number) 
		{
			super();
			
			_target = target;
			_boundaryH = boundaryH;
			
			var bg:ImageBox = new ImageBox("gourmet/scroll_bg");
			bg.height = _boundaryH;
			addChild(bg);
			
			_handle = new Button([new ImageBox("gourmet/handle"), new ImageBox("gourmet/handle_press")]);
			addChild(_handle);
			
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			
		}
		
		private function onDown(e:MouseEvent):void 
		{
			_handle.startDrag(false, new Rectangle(0, 0, 0, _boundaryH-_handle.height));
			
			addEventListener(Event.ENTER_FRAME, loop);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
		}
		
		private function loop(e:Event):void 
		{
			var ratio:Number = _handle.y / (_boundaryH - _handle.height);
			_target.y = -(_target.height - _boundaryH) * ratio;
		}
		
		private function onUp(e:MouseEvent):void 
		{
			removeEventListener(Event.ENTER_FRAME, loop);
			_handle.stopDrag();
			_handle.up();
		}
		
		public function get handle():Button 
		{
			return _handle;
		}
		
	}

}