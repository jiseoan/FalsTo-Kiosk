package app.view.gourmet494 
{
	import app.view.common.ImageBox;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author joe
	 */
	public class HomeView extends Sprite 
	{
		
		public function HomeView() 
		{
			super();
			
			var logo:ImageBox = new ImageBox("gourmet/logo");
			logo.y = 110;
			addChild(logo);
			
			var slider:ImageSlider = new ImageSlider();
			slider.y = 335;
			addChild(slider);
			
			var menu:MainMenu = new MainMenu();
			menu.y = 1046;
			addChild(menu);
			
		}
		
	}

}