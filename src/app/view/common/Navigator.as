package app.view.common 
{
	import app.controller.Controller;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Navigator extends Sprite 
	{
		private var _backBtn:Button;
		private var _foreBtn:Button;
		
		public function Navigator() 
		{
			super();
			
			y = 1574 - 101;
			
			_backBtn = new Button([new ImageBox("prev_btn"), new ImageBox("prev_btn_press")]);
			addChild(_backBtn);
			
			_foreBtn = new Button([new ImageBox("next_btn"), new ImageBox("next_btn_press")]);
			_foreBtn.x = 1080 - 175;
			addChild(_foreBtn);
			
			_backBtn.addEventListener(MouseEvent.CLICK, onClickBackBtn);
			_foreBtn.addEventListener(MouseEvent.CLICK, onClickForeBtn);
			
			if (Controller.instance.isLastHistory())
			{
				_foreBtn.visible = false;
			}
		}
		
		private function onClickBackBtn(e:MouseEvent):void 
		{
			Controller.instance.goBack();
		}
		
		private function onClickForeBtn(e:MouseEvent):void 
		{
			Controller.instance.goForward();
		}
		
	}

}