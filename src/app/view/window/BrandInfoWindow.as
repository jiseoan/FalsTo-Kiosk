package app.view.window 
{
	import app.model.Brand;
	import app.view.common.Window;
	
	/**
	 * ...
	 * @author joe
	 */
	public class BrandInfoWindow extends Window 
	{
		private static var _instance:BrandInfoWindow;
		
		private var _body:BrandInfoWindowBody;
		
		public function BrandInfoWindow(w:int=774, h:int=1197, allCover:Boolean=false) 
		{
			super(w, h, allCover);
			
			_body = new BrandInfoWindowBody();
			addChild(_body);
		}
		
		public function update(brand:Brand):void
		{
			_body.update(brand);
			
		}
		
		public function destroy():void
		{
			_instance = null;
		}
		
		static public function get instance():BrandInfoWindow 
		{
			if (_instance == null)
			{
				_instance = new BrandInfoWindow();
			}
			
			return _instance;
		}
	}

}