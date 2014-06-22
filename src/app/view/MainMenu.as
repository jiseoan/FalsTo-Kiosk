package app.view 
{
	import app.Application;
	import app.controller.Controller;
	import app.model.Model;
	import app.view.common.ImageBox;
	import com.greensock.TweenNano;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author joe
	 */
	public class MainMenu extends Sprite 
	{
		private var _btns:Array = [];
		
		public function MainMenu() 
		{
			super();
			
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0xFFFFFF);
			bg.graphics.drawRect(0, 0, 1080, 1083);
			addChild(bg);
			
			var posX:Array = [122, 609,122, 609,122, 609];
			var posY:Array = [72, 72, 387, 387, 702, 702];
			
			for (var i:int = 0; i < 6; i++) 
			{
				var btn:ImageBox = new ImageBox("main_menu_item_press");
				btn.alpha = 0;
				btn.x = posX[i];
				btn.y = posY[i];
				_btns.push(btn);
				
				addChild(btn);
				
				btn.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				btn.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				btn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				btn.addEventListener(MouseEvent.CLICK, onClick);
			}
			
			var image:ImageBox = new ImageBox("main_menu", true);
			image.mouseEnabled = false;
			addChild(image);
		}
		
		private function onMouseOut(e:MouseEvent):void 
		{
			var t:ImageBox = e.target as ImageBox;
			
			//t.alpha = 0;
			TweenNano.to(t, 0.2, { alpha:0 } );
		}
		
		private function onClick(e:MouseEvent):void 
		{
			var t:ImageBox = e.target as ImageBox;
			var id:int = _btns.indexOf(t)+1;
			
			if (id == 6) 
			{
				Application.instance.langWindow.open();
			}
			else
			{
				Controller.instance.changeView(id);
			}
			
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			var t:ImageBox = e.target as ImageBox;
			
			//t.alpha = 0;
			TweenNano.to(t, 0.2, { alpha:0 } );
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			var t:ImageBox = e.target as ImageBox;
			
			//t.alpha = 1;
			TweenNano.to(t, 0.2, { alpha:1 } );
		}
		
	}

}