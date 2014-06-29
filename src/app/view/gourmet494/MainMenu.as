package app.view.gourmet494 
{
	import app.event.DynamicEvent;
	import app.model.Model;
	import app.view.common.ImageBox;
	import com.greensock.TweenNano;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author joe
	 */
	public class MainMenu extends MainMenuAsset 
	{
		
		public function MainMenu() 
		{
			super();
			
			var menu:ImageBox = new ImageBox("gourmet/menu", true);
			addChildAt(menu, 0);
			
			for (var i:int = 1; i <= 5; i++) 
			{
				
				var btn:MovieClip = getChildByName("b" + i) as MovieClip;
				btn.alpha = 0;
				
				btn.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				btn.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				btn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				btn.addEventListener(MouseEvent.CLICK, onClick);
			}
		}
		
		private function onMouseOut(e:MouseEvent):void 
		{
			var t:MovieClip = e.target as MovieClip;
			
			t.alpha = 0;
		}
		
		private function onClick(e:MouseEvent):void 
		{
			var t:MovieClip = e.target as MovieClip;
			var id:int = int(t.name.substr(1));
			
			t.alpha = 0;
			
			Model.instance.gourmetMode = id;
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			var t:MovieClip = e.target as MovieClip;
			
			t.alpha = 0;
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			var t:MovieClip = e.target as MovieClip;
			
			var focus:ImageBox = new ImageBox("gourmet/menu_click", true);
			
			var bd:BitmapData = new BitmapData(t.width, t.height);
			bd.draw(focus, new Matrix(1, 0, 0, 1, -t.x, -t.y), null, null, null, true);
			var patch:Bitmap = new Bitmap(bd, "auto", true);
			
			if (t.numChildren == 2)
			{
				t.removeChildAt(1);
			}
			t.addChild(patch);
			
			t.alpha = 1;
		}
		

	}

}


