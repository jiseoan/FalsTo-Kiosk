package app.view.gourmet494 
{
	import app.model.Brand;
	import app.view.common.ImageBox;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author joe
	 */
	public class MenuWindowBody extends Sprite 
	{
		private var _menuList:MenuList;
		
		public function MenuWindowBody(brand:Brand) 
		{
			super();
			
			var title:ImageBox = new ImageBox("gourmet/title_menu", true);
			addChild(title);
			
			_menuList = new MenuList(brand);
			_menuList.x = 50;
			_menuList.y = 226;
			addChild(_menuList);
		}
		
	}

}