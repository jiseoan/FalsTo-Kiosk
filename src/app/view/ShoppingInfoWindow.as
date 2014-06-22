package app.view 
{
	import app.Application;
	import app.model.Model;
	import app.model.ShoppingInfo;
	import app.view.common.Button;
	import app.view.common.ImageBox;
	import app.view.common.Window;
	import com.greensock.TweenNano;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author joe
	 */
	public class ShoppingInfoWindow extends Window 
	{
		private var _prevBtn:Button;
		private var _nextBtn:Button;
		private var _index:int;
		private var _container:Sprite;
		private var _template:ShoppingInfoTemplate;
		private var _nextTemplate:ShoppingInfoTemplate;
		
		public function ShoppingInfoWindow(index:int) 
		{
			super(920, 1271, false);
			
			_index = index;
			
			_container = new Sprite();
			addChild(_container);
			
			var info:ShoppingInfo = Model.instance.shoppingInfos[index];
			
			_template = new ShoppingInfoTemplate(index);
			_container.addChild(_template);
			
			var m:Shape = new Shape();
			m.graphics.beginFill(0);
			m.graphics.drawRect(0, 0, 920, 1171);
			addChild(m);
			
			_container.mask = m;
			
			if (Model.instance.shoppingInfos.length < 2)
			{
				return;
			}
			
			_prevBtn = new Button([new ImageBox("btn_prev"), new ImageBox("btn_prev_press")]);
			_nextBtn = new Button([new ImageBox("btn_next"), new ImageBox("btn_next_press")]);
			
			_prevBtn.x = 20;
			_prevBtn.y = 1271 - 61-20;
			
			_nextBtn.x = 920-61-20;
			_nextBtn.y = 1271 - 61-20;
			
			addChild(_prevBtn);
			addChild(_nextBtn);
			
			_prevBtn.addEventListener(MouseEvent.CLICK, onClickPrev)
			_nextBtn.addEventListener(MouseEvent.CLICK, onClickNext)
		}
		
		private function onClickPrev(e:MouseEvent):void 
		{
			_index--;
			if (_index < 0)
			{
				_index = Model.instance.shoppingInfos.length-1;
			}
			
			var info:ShoppingInfo = Model.instance.shoppingInfos[_index];
			
			_nextTemplate = new ShoppingInfoTemplate(_index);
			_nextTemplate.x = -920;
			_container.addChild(_nextTemplate);
			
			Application.instance.enabled = false;
			TweenNano.to(_container, 0.4, { x:920, onComplete:onTween} );
		}
		
		private function onTween():void 
		{
			_nextTemplate.x = 0;
			_container.addChild(_nextTemplate);
			_container.removeChild(_template);
			_container.x = 0;
			
			_template = _nextTemplate;
			
			Application.instance.enabled = true;
		}
		
		private function onClickNext(e:MouseEvent):void 
		{
			_index++;
			if (_index > Model.instance.shoppingInfos.length-1)
			{
				_index = 0;
			}
			
			var info:ShoppingInfo = Model.instance.shoppingInfos[_index];
			
			_nextTemplate = new ShoppingInfoTemplate(_index);
			_nextTemplate.x = 920;
			_container.addChild(_nextTemplate);
			
			Application.instance.enabled = false;
			TweenNano.to(_container, 0.4, { x:-920, onComplete:onTween} );
		}
		
	}

}