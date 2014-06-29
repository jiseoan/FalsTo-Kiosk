package app.view.common 
{
	import app.controller.Controller;
	import app.model.Model;
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
			
			visible = false;
			
			_backBtn = new Button([new ImageBox("prev_btn"), new ImageBox("prev_btn_press")]);
			addChild(_backBtn);
			
			_foreBtn = new Button([new ImageBox("next_btn"), new ImageBox("next_btn_press")]);
			_foreBtn.x = 1080 - _foreBtn.width;
			addChild(_foreBtn);
			
			var centerY:int = 787;	// 컨텐츠 영역의 중심
			y = int(centerY - _foreBtn.height/2) + 108;
			
			_backBtn.addEventListener(MouseEvent.CLICK, onClickBackBtn);
			_foreBtn.addEventListener(MouseEvent.CLICK, onClickForeBtn);
			
			//if (Controller.instance.isLastHistory())
			//{
				//_foreBtn.visible = false;
			//}
		}
		
		private function onClickBackBtn(e:MouseEvent):void 
		{
			Controller.instance.goBack();
		}
		
		private function onClickForeBtn(e:MouseEvent):void 
		{
			Controller.instance.goForward();
		}
		
		public function updateVisible(mode:int):void
		{
			if (Model.instance.screensaverMode)
			{
				visible = false;
				return;
			}
			
			if (Controller.instance.isLastHistory())
			{
				_foreBtn.visible = false;
			}
			else
			{
				_foreBtn.visible = true;
			}
			
			if (mode == 0)
			{
				visible = false;
			}
			else
			{
				visible = true;
			}
		}
		
		public function get foreBtn():Button 
		{
			return _foreBtn;
		}
		
	}

}