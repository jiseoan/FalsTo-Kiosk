package app.view 
{
	import app.model.Language;
	import app.model.Model;
	import flash.display.Bitmap;
	import flash.events.Event;
	/**
	 * ...
	 * @author joe
	 */
	public class UpdateAlert extends UpdateAlertAsset 
	{
		
		public function UpdateAlert() 
		{
			super();
			
			addChildAt(Main.instance.homeCapture, 0);
			
			var frame:int = Language.all.indexOf(Model.instance.lang) + 1;
			gotoAndStop(frame);
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}
		
		private function removedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			
			spin.stop();
		}
		
	}

}