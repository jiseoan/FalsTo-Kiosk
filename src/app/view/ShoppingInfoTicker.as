package app.view 
{
	import app.Application;
	import app.model.Language;
	import app.model.Model;
	import app.model.ShoppingInfo;
	import app.text.TextFormatter;
	import app.view.common.ImageBox;
	import app.view.common.Pagination;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenNano;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author joe
	 */
	public class ShoppingInfoTicker extends Sprite 
	{
		private var _items:Array = [];
		private var _interval:Number;
		private var _timer:Timer;
		private var _infos:Array = [];
		private var _curInfo:ShoppingInfo;
		private var _container:Sprite;
		private var _totalWidth:Number;
		private var _tickerMask:Shape;
		private var _active:Boolean = true;
		private var _shoppingInfos:Array;
		
		
		public function ShoppingInfoTicker() 
		{
			super();
			
			addChild(new ImageBox("main_shopping_info"));
			
			var m:Shape = new Shape();
			m.graphics.beginFill(0);
			m.graphics.drawRect(0, 0, 1080, 80);
			addChild(m);
			
			mask = m;
			
			_container = new Sprite();
			_container.x = 188;
			_container.y = 25;
			addChild(_container);
			
			_tickerMask = new Shape();
			_tickerMask.graphics.beginFill(0, 0.3);
			_tickerMask.graphics.drawRect(188, 25, 800, 30);
			addChild(_tickerMask);
			
			_container.mask = _tickerMask;
			
			_shoppingInfos = Model.instance.shoppingInfos;
			
			var tx:Number = 0;
			var space:Number = 50;
			
			for (var i:int = 0; i < _shoppingInfos.length; i++) 
			{
				if (_shoppingInfos[i].data.ticker[Language.KOREAN] =="")
				{
					continue;
				}
				
				var item:Sprite = new Sprite();
				var info:ShoppingInfo = _shoppingInfos[i];
				var tf:TextField = new TextField();
				//tf.border = true;
				//tf.height = 30;
				TextFormatter.setTextFormat(tf, 0x222222, 24, YoonGothic145, "left", false);
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.text = _shoppingInfos[i].data.ticker[Language.KOREAN];
				
				item.addChild(tf);

				item.x = tx;
				_container.addChild(item);
				
				_items.push(item);
				_infos.push(info);
				
				tx = item.x + item.width + space;
				
				item.buttonMode = true;
				item.mouseChildren = false;
				
				item.addEventListener(MouseEvent.CLICK, click);
			}
			
			_container.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			_totalWidth = tx;
			
			Application.instance.proxy.addEventListener(TransitionProxy.TRANSITION_COMPLETE, onTransition);
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}
		
		private function removedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			Application.instance.proxy.removeEventListener(TransitionProxy.TRANSITION_COMPLETE, onTransition);
			
			for (var i:int = 0; i < _items.length; i++) 
			{
				var item:Sprite = _items[i];
				
				item.removeEventListener(MouseEvent.CLICK, click);
			}
			
			_container.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onTransition(e:Event):void 
		{
			if (Model.instance.mode == 0)
			{
				_active = true;
			}
			else
			{
				_active = false;
			}
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (!_active) return;
			
			var item:Sprite = e.target as Sprite;
			_container.x -= 2;
			
			if (_container.x + _container.width  < 188)
			{
				_container.x = 188 + 800;
			}
		}
		
		private function click(e:MouseEvent):void 
		{
			var item:Sprite = e.target as Sprite;
			var index:int = _items.indexOf(item);
			var window:ShoppingInfoWindow = new ShoppingInfoWindow(index);
			window.open();
			
		}
	}

}