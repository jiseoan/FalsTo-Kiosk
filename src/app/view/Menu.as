package app.view 
{
	import app.controller.Controller;
	import app.model.Model;
	import app.view.common.Button;
	import app.view.common.ImageBox;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenNano;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Menu extends Sprite 
	{
		private var _btns:Array = [];
		private var _maskMC:MovieClip;
		
		public function Menu() 
		{
			super();
			
			y = 1682 - 108;
			
			mask = new MenuMaskAsset();
			addChild(mask);
			
			for (var i:int = 0; i < 6; i++) 
			{
				var index:int = i + 1;
				var b1:ImageBox = new ImageBox("menu_item"+index);
				var b2:ImageBox = new ImageBox("menu_item"+index+"_press");
				
				var btn:Button = new Button([b1, b2]);
				btn.x = 180 * i;
				_btns.push(btn);
				
				addChild(btn);
				
				btn.addEventListener(Button.CLICK, onClick);
			}
			
			Model.instance.addEventListener(Model.UPDATE_MODE, onUpdateMode);
		}
		
		private function onUpdateMode(e:Event):void 
		{
			focus(Model.instance.mode);
		}
		
		private function onClick(e:Event):void 
		{
			var t:Button = e.target as Button;
			var id:int = _btns.indexOf(t) + 1;
			
			Controller.instance.changeView(id);
		}
		
		private function focus(id:int):void
		{
			if (id == 6) return;
			
			for (var i:int = 0; i < 6; i++) 
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
			
			TweenNano.to(mask, 0.5, { x:180 * (id - 1), ease:Cubic.easeInOut } );
			
		}
		
	}

}