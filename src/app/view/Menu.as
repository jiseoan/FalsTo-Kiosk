package app.view 
{
	import app.Application;
	import app.controller.Controller;
	import app.model.Model;
	import app.view.common.Button;
	import app.view.common.ImageBox;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenNano;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Menu extends Sprite 
	{
		private var _btns:Array = [];
		private var _maskMC:MovieClip;
		private var _homeBtn:Button;
		
		public function Menu() 
		{
			super();
			
			y = 1682 - 108;
			
			mask = new MenuMaskAsset();
			addChild(mask);
			
			for (var i:int = 0; i < 7; i++) 
			{
				var index:int = i+1;
				var b1:ImageBox = new ImageBox("menu_item"+index);
				var b2:ImageBox = new ImageBox("menu_item"+index+"_press");
				
				var btn:Button = new Button([b1, b2]);
				btn.x = 134 * i + 142;
				_btns.push(btn);
				
				addChild(btn);
				
				btn.addEventListener(Button.CLICK, onClick);
			}
			
			_homeBtn = new Button([new ImageBox("menu_item0"), new ImageBox("menu_item0_press")]);
			addChild(_homeBtn);
			_homeBtn.addEventListener(MouseEvent.CLICK, onClickHomeBtn);
			
			Model.instance.addEventListener(Model.UPDATE_MODE, onUpdateMode);
		}
		
		private function onClickHomeBtn(e:MouseEvent):void 
		{
			Application.instance.langWindow.close();
			Controller.instance.changeView(0);
		}
		
		private function onUpdateMode(e:Event):void 
		{
			focus(Model.instance.mode);
		}
		
		private function onClick(e:Event):void 
		{
			var t:Button = e.target as Button;
			var id:int = _btns.indexOf(t) + 1;
			
			if (id == 7)
			{
				Application.instance.langWindow.open();
			}
			else
			{
				Controller.instance.changeView(id);
			}
			
		}
		
		private function focus(id:int):void
		{
			if (id == 7) return;
			
			for (var i:int = 0; i < 7; i++) 
			{
				var btn:Button = _btns[i];
				
				if (i+1 == id)
				{
					btn.focus();
				}
				else
				{
					btn.up();
				}
			}
			
			TweenNano.to(mask, 0.5, { x:134 * (id - 1), ease:Cubic.easeInOut } );
			
		}
		
	}

}