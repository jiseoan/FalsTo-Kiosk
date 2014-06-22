package app.view.common 
{
	import app.Application;
	import app.controller.Controller;
	import app.model.Model;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import com.greensock.TweenNano;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Window extends Sprite 
	{
		public static const BEFORE_CLOSE:String = "beforeClose";
		public static var curWindow:Window;
		
		private var _allCover:Boolean;
		private var _bg:ImageBox;
		private var _closeBtn:Button;
		private var _closeTitle:ImageBox;
		private var _proxy:Sprite = new Sprite();	//rotationY회전을 위해 윈도우를 감싸는 컨테이너
		
		public function Window(w:int, h:int, allCover:Boolean = false ) 
		{
			super();

			_allCover = allCover;
			
			_bg = new ImageBox("alert_body_bg");
			_bg.width = w;
			_bg.height = h;
			addChild(_bg);
			
			_closeBtn = new Button([new ImageBox("alert_button_bg"), new ImageBox("alert_button_bg_press")]);
			_closeBtn.width = w;
			_closeBtn.y = h - _closeBtn.height;
			addChild(_closeBtn);
			
			_closeTitle = new ImageBox("alert_close");
			_closeTitle.x = Math.round(w / 2 - _closeTitle.width / 2);
			_closeTitle.y = _closeBtn.y;
			_closeTitle.mouseEnabled = false;
			addChild(_closeTitle);
			
			_closeBtn.addEventListener(Button.CLICK, onClickCloseBtn);
			
			Controller.instance.addEventListener(Controller.TRANSITION, onTransiton);
			
			
		}
		
		private function onTransiton(e:Event):void 
		{
			close();
		}
		
		private function onClickCloseBtn(e:Event):void 
		{
			dispatchEvent(new Event(Window.BEFORE_CLOSE));
			close();
		}
		
		public function open():void
		{
			if (Window.curWindow)
			{
				Window.curWindow.close();
			}
			
			x = Math.round(540 - width / 2);
			
			if (Model.instance.mode == 0)
			{
				y = Math.round(108 + (1920 - 108 - 68) / 2 - height / 2);
				Application.instance.dimBox.height = 1920 - 108 - 68;
				
			}
			else
			{
				y = Math.round(108 + (1920 - 108 - 68 - 170) / 2 - height / 2);
				Application.instance.dimBox.height = 1920 - 108 - 68;
				//Application.instance.dimBox.height = 1920 - 108 - 68 - 170;
			}
			
			TweenMax.to(Application.instance.dimBox, 0, { autoAlpha:1 } );
			Application.instance.addChild(Application.instance.dimBox);
			
			_proxy.x = 540;
			_proxy.y = Math.round(y + height / 2);
			x = -Math.round(width / 2);
			y = -Math.round(height / 2);
			_proxy.addChild(this);
			
			var xfactor:Number=_proxy.width/(_proxy.width+1);
			var yfactor:Number = _proxy.height / (_proxy.height + 1);

			_proxy.scaleX=xfactor;
			_proxy.scaleY=yfactor;
			var pp:PerspectiveProjection=new PerspectiveProjection();
			pp.fieldOfView=30;
			pp.projectionCenter=new Point(540,_proxy.y);
			Application.instance.transform.perspectiveProjection = pp;
			_proxy.alpha = 0;
			_proxy.rotationY = 60;
			TweenMax.to(_proxy, 0.2, { alpha:1, ease:Linear.easeNone } );
			TweenMax.to(_proxy, 0.4, { rotationY:0, ease:Sine.easeOut, onComplete:onTween } );
			Application.instance.addChild(_proxy);
			
			
			Application.instance.enabled = false;
			
			if (Model.instance.mode != 0)
			{
				Application.instance.content.menu.y = 1682;
				Application.instance.addChild(Application.instance.content.menu);
			}
			
			if (_allCover)
			{
				Application.instance.dimBox.y = 0;
				Application.instance.dimBox.height = 1920;
				Application.instance.addChild(Application.instance.dimBox);
				Application.instance.addChild(_proxy);
			}
		}
		
		private function onTween():void 
		{
			var p:Point = new Point(_proxy.x, _proxy.y);
			_proxy.transform.matrix3D = null;
			_proxy.x = p.x;
			_proxy.y = p.y;		
			
			Window.curWindow = this;
			Application.instance.enabled = true;
		}
		
		public function close():void 
		{
			TweenMax.to(Application.instance.dimBox, 0, { autoAlpha:0 } );
			TweenMax.to(_proxy, 0, { alpha:0, rotationY:0} );
			
			var p:Point = new Point(540, _proxy.y);
			_proxy.transform.matrix3D = null;
			_proxy.x = p.x;
			_proxy.y = p.y;
			
			if (_proxy.parent)
			{
				if(Application.instance.contains(_proxy)) Application.instance.removeChild(_proxy);
			}
			
			Window.curWindow = null;
			
			Application.instance.dimBox.y = 108;
			
			if (Application.instance.content)
			{
				Application.instance.content.menu.y = 1682 - 108;
				Application.instance.content.addChild(Application.instance.content.menu);
			}
			
		}

		
	}

}