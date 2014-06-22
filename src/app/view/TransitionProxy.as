package app.view 
{
	import app.Application;
	import app.model.Model;
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import com.greensock.TweenNano;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author joe
	 */
	public class TransitionProxy extends Sprite 
	{
		public static const TRANSITION_COMPLETE:String = "transitionComplete";
		
		private var _curViewProxy:Bitmap;
		private var _nextViewProxy:Bitmap;
		private var _sec:Number = 0.5;
		private var _ease:Function = Sine.easeInOut;
		
		public function TransitionProxy() 
		{
			super();
			
			y = 108;
			
			//_homeProxy = new Bitmap(new BitmapData(1744, 1080));
			//_homeProxy.smoothing = true;
			//
			//_contentProxy = new Bitmap(new BitmapData(1744, 1080));
			//_contentProxy.smoothing = true;
			//
			//_viewProxy1 = new Bitmap(new BitmapData(1574, 1080));
			//_viewProxy1.smoothing = true;
			//
			//_viewProxy2 = new Bitmap(new BitmapData(1574, 1080));
			//_viewProxy2.smoothing = true;
		}
		
		public function homeToContent(mode:int):void
		{
			if (mode == 6) return;
			
			var self:TransitionProxy = this;
			
			_curViewProxy = new Bitmap(new BitmapData(1080, 1744, false));
			_nextViewProxy = new Bitmap(new BitmapData(1080, 1744, false));
			
			_curViewProxy.bitmapData.draw(Application.instance.home, new Matrix(1,0,0,1,0,-108), null, null, new Rectangle(0,0,1080,1744), true);
			addChild(_curViewProxy);
			
			_nextViewProxy.bitmapData.draw(Application.instance.content, null, null, null, new Rectangle(0,0,1080,1744), true);
			_nextViewProxy.x = 1080;
			addChild(_nextViewProxy);
			
			TweenMax.to(_curViewProxy, _sec, { x: -200, colorMatrixFilter:{brightness:-0.7 }, ease:_ease} );
			TweenNano.to(_nextViewProxy, _sec, { x: 0, ease:_ease, onComplete:dispose } );
			
			Application.instance.addChild(this);

		}
		
		public function contentToContent(curView:Bitmap, mode:int):void
		{
			if (mode == 6) return;
			
			var self:TransitionProxy = this;
			var dir:int = (mode > Model.instance.mode)?1: -1;
			
			_curViewProxy = curView;
			_nextViewProxy = new Bitmap(new BitmapData(1080, 1574, false));
			
			addChild(_curViewProxy);
			
			_nextViewProxy.bitmapData.draw(Application.instance.content, null, null, null, new Rectangle(0,0,1080,1574), true);
			_nextViewProxy.x = 1080 * dir;
			addChild(_nextViewProxy);
			
			TweenMax.to(_curViewProxy, _sec, { x: -200*dir, colorMatrixFilter:{brightness:-0.7 }, ease:_ease} );
			TweenNano.to(_nextViewProxy, _sec, { x: 0, ease:_ease, onComplete:dispose } );
			
			Application.instance.addChild(this);
		}
		
		public function contentToHome():void
		{
			_curViewProxy = new Bitmap(new BitmapData(1080, 1744, false));
			_nextViewProxy = new Bitmap(new BitmapData(1080, 1744, false));
			
			_curViewProxy.bitmapData.draw(Application.instance.content, null, null, null, new Rectangle(0,0,1080,1744), true);
			addChild(_curViewProxy);
			
			_nextViewProxy.bitmapData.draw(Application.instance.home, new Matrix(1,0,0,1,0,-108), null, null, new Rectangle(0,0,1080,1744), true);
			_nextViewProxy.x = -1080;
			addChild(_nextViewProxy);
			
			TweenMax.to(_curViewProxy, _sec, { x: 200, ease:_ease, colorMatrixFilter:{brightness:-0.7 }} );
			TweenNano.to(_nextViewProxy, _sec, { x: 0, ease:_ease, onComplete:dispose } );
			
			Application.instance.addChild(this);
		}

		private function dispose():void
		{
			if(Application.instance.contains(this)) Application.instance.removeChild(this);
			TweenMax.to(_curViewProxy, 0, { colorMatrixFilter:{brightness:1 }} );
			_curViewProxy.bitmapData.dispose();
			_nextViewProxy.bitmapData.dispose();
			
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
			
			Application.instance.enabled = true;
			
			dispatchEvent(new Event(TransitionProxy.TRANSITION_COMPLETE));
		}
	}

}