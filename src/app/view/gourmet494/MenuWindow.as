package app.view.gourmet494 
{
	import app.model.Brand;
	import app.view.common.Window;
	
	/**
	 * ...
	 * @author joe
	 */
	public class MenuWindow extends Window 
	{
		private var _body:MenuWindowBody;
		
		public function MenuWindow(brand:Brand) 
		{
			super(1020, 1483, false, "black");
			
			_body = new MenuWindowBody(brand);
			addChild(_body);
		}

	}

}