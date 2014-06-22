package app.view.window 
{
	import app.view.common.Button;
	import app.view.common.ImageBox;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author joe
	 */
	public class Scroller extends Sprite 
	{
		private var _handle:Button;
		private var _target:TextField;
		private var _boundaryH:Number;
		private var _targetOY:Number;
		
		public function Scroller(target:TextField, boundaryH:Number) 
		{
			super();
			
			_target = target;
			_boundaryH = boundaryH;
			_targetOY = _target.y;
			trace( "_targetOY : " + _targetOY );
			
			var bg:ImageBox = new ImageBox("scroll_bg");
			bg.scaleX = 0.5;
			bg.height = boundaryH;
			addChild(bg);
			
			
			_handle = new Button([new ImageBox("handle"), new ImageBox("handle_press")]);
			_handle.scaleX = _handle.scaleY = 0.5;
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
			trace( "ratio : " + ratio );
			_target.y = _targetOY -(_target.height - _boundaryH) * ratio;
			trace( "_target.y : " + _target.y );
		}
		
		private function onUp(e:MouseEvent):void 
		{
			removeEventListener(Event.ENTER_FRAME, loop);
			_handle.stopDrag();
			_handle.up();
		}
		
		public function reset():void
		{
			_handle.y = 0;
		}
		
		public function get handle():Button 
		{
			return _handle;
		}
		
	}

}