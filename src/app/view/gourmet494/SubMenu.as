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
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author joe
	 */
	public class SubMenu extends SubMenuAsset 
	{
		
		public function SubMenu() 
		{
			super();
			
			var menu:ImageBox = new ImageBox("gourmet/submenu");
			addChildAt(menu, 0);
			
			for (var i:int = 1; i <= 5; i++) 
			{
				
				var btn:MovieClip = getChildByName("b" + i) as MovieClip;
				btn.alpha = 0;
				
				var focus:ImageBox = new ImageBox("gourmet/submenu_click");
			
				var bd:BitmapData = new BitmapData(btn.width, btn.height);
				bd.draw(focus, new Matrix(1, 0, 0, 1, -btn.x, -btn.y), null, null, null, true);
				var patch:Bitmap = new Bitmap(bd, "auto", true);
				btn.addChild(patch);
			
				btn.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				btn.addEventListener(MouseEvent.CLICK, onClick);
			}
			
			Model.instance.addEventListener(Model.UPDATE_GOURMET_MODE, onUpdateGourmetMode);
		}
		
		public function onUpdateGourmetMode(e:Event):void 
		{
			for (var i:int = 1; i <= 5; i++) 
			{
				var btn:MovieClip = getChildByName("b" + i) as MovieClip;
				if (i != Model.instance.gourmetMode)
				{
					btn.alpha = 0;
				}
				else
				{
					btn.alpha = 1;
				}
			}
		}
		
		private function onClick(e:MouseEvent):void 
		{
			var t:MovieClip = e.target as MovieClip;
			var id:int = int(t.name.substr(1));
			
			Model.instance.gourmetMode = id;
		}

		private function onMouseDown(e:MouseEvent):void 
		{
			var t:MovieClip = e.target as MovieClip;
			
			
			t.alpha = 1;
		}
	}

}


