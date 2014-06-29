package app.view.gourmet494 
{
	import app.model.Model;
	import app.view.common.ImageBox;
	import app.view.common.ImageBox2;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import com.greensock.TweenNano;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author joe
	 */
	public class OnlyGalleriaGrid extends Sprite 
	{
		private var _guide:OnlyGalleriaGuideAsset;
		private var _items:Array = [];
		private var _timer:Timer = new Timer(5000);
		private var _mode:String = "thumbnail";	//thumbnail, text
		private var _aniBox:Shape;
		private var _player:OnlyGalleriaPlayer;
		
		public function OnlyGalleriaGrid() 
		{
			super();
			
			_guide = new OnlyGalleriaGuideAsset();
			
			var onlyGalleriaItems:Array = Model.instance.onlyGalleriaItems;
			var images:Array = [];
			for (var i:int = 0; i < onlyGalleriaItems.length; i++) 
			{
				var item:MovieClip = new MovieClip();
				var obj:Object = onlyGalleriaItems[i];
				var thumbnail:ImageBox2 = new ImageBox2([obj["thumbnail@kor"], obj["thumbnail@eng"], obj["thumbnail@chn"], obj["thumbnail@jpn"]]);
				var text:ImageBox2 = new ImageBox2([obj["text@kor"], obj["text@eng"], obj["text@chn"], obj["text@jpn"]]);
				var image:ImageBox2 = new ImageBox2([obj["image@kor"], obj["image@eng"], obj["image@chn"], obj["image@jpn"]]);
				
				image.width = 920;
				image.height = 1085;
				
				item.thumbnail = thumbnail;
				item.text = text;
				item.image = image;
				images.push(image);
				
				item.addChild(thumbnail);
				
				text.alpha = 0;
				text.visible = false;
				item.addChild(text);
				
				var guideItem:MovieClip = _guide.getChildByName("b" + i) as MovieClip;
				item.x = guideItem.x;
				item.y = guideItem.y;
				
				addChild(item);
				
				_items.push(item);
				
				item.mouseChildren = false;
				item.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				item.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				item.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				item.addEventListener(MouseEvent.CLICK, onClick);
			}

			_aniBox = new Shape();
			_aniBox.graphics.beginFill(0);
			_aniBox.graphics.drawRect(0, 0, 100, 100);
			_aniBox.alpha = 0;
			addChild(_aniBox);
			
			_player = new OnlyGalleriaPlayer(images);
			_player.addEventListener(OnlyGalleriaPlayer.HIDE, onHidePlayer);
			
			startAnimation();
		}
		
		private function onHidePlayer(e:Event):void 
		{
			var guideItem:MovieClip = _guide.getChildByName("b" + _player.index) as MovieClip;
			
			TweenMax.to(_aniBox, 0.3, { alpha:0, x:guideItem.x, y:guideItem.y, width:guideItem.width, height:guideItem.height } );
		}
		
		private function onMouseOut(e:MouseEvent):void 
		{
			var t:MovieClip = e.target as MovieClip;
			
			//t.alpha = 0;
			TweenMax.to(t, 0.2, { colorTransform:{brightness:1} } );
		}
		
		private function onClick(e:MouseEvent):void 
		{
			var t:MovieClip = e.target as MovieClip;
			var id:int = _items.indexOf(t);
			
			var guideItem:MovieClip = _guide.getChildByName("b" + id) as MovieClip;
			
			_aniBox.alpha = 0;
			_aniBox.x = guideItem.x;
			_aniBox.y = guideItem.y;
			_aniBox.width = guideItem.width;
			_aniBox.height = guideItem.height;
			
			TweenMax.to(_aniBox, 0.3, { alpha:0.6, x:0, y:0, width:920, height:1085, onComplete:onTween, onCompleteParams:[id] } );
		}
		
		private function onTween(id:int):void
		{
			addChild(_player);
			_player.show(id);
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			var t:MovieClip = e.target as MovieClip;
			
			//t.alpha = 0;
			TweenMax.to(t, 0.2, { colorTransform:{brightness:1} } );
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			var t:MovieClip = e.target as MovieClip;
			
			//t.alpha = 1;
			TweenMax.to(t, 0.2, { colorTransform:{brightness:0.5} } );
		}
		
		private function startAnimation():void
		{
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			if (_mode == "thumbnail")
			{
				showText();
				_mode = "text";
			}
			else
			{
				hideText();
				_mode = "thumbnail";
			}
		}
		
		private function stopAnimation():void
		{
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
		}
		
		private function showText():void
		{
			for (var i:int = 0; i < _items.length; i++) 
			{
				var item:MovieClip = _items[i];
				
				TweenMax.to(item.text, 0.4, { autoAlpha:1, delay:i*0.06, ease:Cubic.easeIn} );
			}
		}
		
		private function hideText():void
		{
			for (var i:int = 0; i < _items.length; i++) 
			{
				var item:MovieClip = _items[i];
				
				TweenMax.to(item.text, 0.4, { autoAlpha:0, delay:i*0.06, ease:Cubic.easeIn} );
			}
		}
	}

}