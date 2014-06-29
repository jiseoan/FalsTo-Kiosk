package  
{
	import app.model.Model;
	import app.net.LoadManager2;
	import app.view.gourmet494.GourmetView;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author joe
	 */
	public class GourmetMain extends Sprite 
	{
		
		public function GourmetMain() 
		{
			super();
			
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			
			
			
			Model.instance = new Model();
			Model.instance.mode = 6;
			
			var loadManager:LoadManager2 = new LoadManager2();
			loadManager.addEventListener(LoadManager2.COMPLETE, init);
			loadManager.load();
		}
		
		private function init(e:Event):void 
		{
			
			addChild(new GourmetView());
		}
		
	}

}