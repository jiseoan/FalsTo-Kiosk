package app.controller {
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.display.MovieClip;

	public class ScrollController {

        // Constant variables
        private static var DECAY:Number = 0.93;
        private static var MOUSE_DOWN_DECAY:Number = 0.5;
        private static var SPEED_SPRINGNESS:Number = 0.4;
        private static var BOUNCING_SPRINGESS:Number = 0.2;

		// variables
        private var _mouseDown:Boolean = false;
        private var _velocity:Number = 0;
        private var _mouseDownX:Number = 0;
        private var _mouseDownPoint:Point = new Point();
        private var _lastMouseDownPoint:Point = new Point();
        		
        // elements
        private var _canvasWidth:Number = 0;
		private var _myScrollElement:DisplayObjectContainer;
		private var _stage:Stage;
		private var _started:Boolean;
		
		public function ScrollController( pContent:DisplayObjectContainer, pStage:Stage ) {
			_stage = pStage;
			_myScrollElement = pContent;
			
			_canvasWidth = _myScrollElement.width;
			
			start();
			
			// add handlers
			_myScrollElement.addEventListener(MouseEvent.MOUSE_DOWN, on_mouse_down);
			_myScrollElement.addEventListener(Event.ENTER_FRAME, on_enter_frame);
		}
		
		private function on_enter_frame(e:Event):void {
			if ( started )
			{
				// decay the velocity
				if(_mouseDown) _velocity *= MOUSE_DOWN_DECAY;
				else _velocity *= DECAY;
				
				
				// if not mouse down, then move the element with the velocity
				if (!_mouseDown)
				{
					var textWidth:Number = _myScrollElement.width;
					
					var x:Number = _myScrollElement.x;
					var bouncing:Number = 0;
					
					// calculate a bouncing when the text moves over the canvas size
					if (x > 0 || textWidth <= _canvasWidth) // textHeight <= _canvasHeight => when the item is smaller than the stage.height, align to the top
					{
						bouncing = -x * BOUNCING_SPRINGESS;
					}else if( x + textWidth < _canvasWidth){
						bouncing = (_canvasWidth - textWidth - x) * BOUNCING_SPRINGESS;
					}
					
					_myScrollElement.x = x + _velocity + bouncing;
				}
			}
		}
		
		// when mouse button up
        private function on_mouse_down(e:MouseEvent):void
        {
            if (!_mouseDown)
            {
                // get some initial properties
                _mouseDownPoint = new Point(e.stageX, e.stageY);
                _lastMouseDownPoint = new Point(e.stageX, e.stageY);
                _mouseDown = true;
                _mouseDownX = _myScrollElement.x;

				// add some more mouse handlers
                _stage.addEventListener(MouseEvent.MOUSE_UP, on_mouse_up);
                _stage.addEventListener(MouseEvent.MOUSE_MOVE, on_mouse_move);
            }
        }

        // when mouse is moving
        private function  on_mouse_move(e:MouseEvent):void
        {
            if (_mouseDown)
            {
                // update the element position
                var point:Point = new Point(e.stageX, e.stageY);
                _myScrollElement.x = _mouseDownX + (point.x - _mouseDownPoint.x);

                // update the velocity
                _velocity += ((point.x - _lastMouseDownPoint.x) * SPEED_SPRINGNESS);
                _lastMouseDownPoint = point;
            }
        }

        // clear everythign when mouse up
        private function  on_mouse_up(e:MouseEvent):void
        {
            if (_mouseDown)
            {
                _mouseDown = false;
                _stage.removeEventListener(MouseEvent.MOUSE_UP, on_mouse_up);
                _stage.removeEventListener(MouseEvent.MOUSE_MOVE, on_mouse_move);
            }
        }
		
		public function release():void
		{
			_myScrollElement.removeEventListener(MouseEvent.MOUSE_DOWN, on_mouse_down);
			_myScrollElement.removeEventListener(Event.ENTER_FRAME, on_enter_frame);
			
			_myScrollElement = null;
		}
		
		public function start():void
		{
			_started = true;
		}
		
		public function stop():void
		{
			_started 	= false;
			_velocity 	= 0;
		}
		
		public function set canvasWidth( pVal:Number ):void
		{
			_canvasWidth = pVal;
		}
		
		public function get canvasWidth():Number
		{
			return _canvasWidth;
		}
		
		public function get percPosition():Number
		{
			var finalPos:Number 	= _canvasWidth - _myScrollElement.width;
			var currentPos:Number 	= _myScrollElement.x;
			
			return currentPos / finalPos;
		}
		
		public function get started():Boolean { return _started; }
		
		public function set started(value:Boolean):void 
		{
			if ( value ) 	start();
			else			stop();
		}
		
		public function get myScrollElement():DisplayObjectContainer { return _myScrollElement; }
	}
}