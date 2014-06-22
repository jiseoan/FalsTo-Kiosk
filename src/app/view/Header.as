package app.view 
{
	import app.Application;
	import app.controller.Controller;
	import app.model.Model;
	import app.text.TextFormatter;
	import app.view.common.ImageBox;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author joe
	 */
	public class Header extends Sprite 
	{
		private var _slider:HeaderSlider;
		private var _dateTF:TextField;
		private var _days:Array = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
		
		public function Header() 
		{
			super();
			
			addChild(new ImageBox("header"));
			
			_slider = new HeaderSlider();
			addChild(_slider);
			
			_dateTF = new TextField();
			_dateTF.width = 140;
			_dateTF.height = 30;
			_dateTF.x = 923;
			_dateTF.y = 54;
			_dateTF.mouseEnabled = false;
			
			//_dateTF.border = true;
			
			_dateTF.text = getDate();
			TextFormatter.setTextFormat(_dateTF, 0xcab26a, 18, MyriadProBold);
			
			addChild(_dateTF);
			
			buttonMode = true;
			mouseChildren = false;
			addEventListener(MouseEvent.CLICK, onClick);
			
			var timer:Timer = new Timer(1000 * 60, 0);
			timer.addEventListener(TimerEvent.TIMER, loop);
			timer.start();
		}
		
		private function loop(e:TimerEvent):void 
		{
			_dateTF.text = getDate();
		}
		
		private function getDate():String
		{
			var d:Date = new Date();
			var str:String = d.getFullYear() + "." + (d.getMonth() + 1) + "." + d.getDate() + " " + _days[d.getDay()];
			
			return str;
		}
		
		private function onClick(e:MouseEvent):void 
		{
			Application.instance.langWindow.close();
			Controller.instance.changeView(0);
		}
		
	}

}