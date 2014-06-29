package app.model 
{
	/**
	 * ...
	 * @author joe
	 */
	public class StaticImageUrl2
	{
		public static var commonImageKeys:Array = [
		
"gourmet/submenu",
"gourmet/submenu_click",
"gourmet/logo",
"gourmet/alert_close",
"gourmet/btn_next_white",
"gourmet/btn_prev_white",
"gourmet/btn_page",
"gourmet/btn_page_disable",
"gourmet/btn_page_focus",
"gourmet/btn_page_press",
"gourmet/btn_next",
"gourmet/btn_next_press",
"gourmet/btn_prev",
"gourmet/btn_prev_press",
"gourmet/search_close",
"gourmet/search_close_press",
"gourmet/search_field",
"gourmet/btn_search",
"gourmet/btn_search_press",
"gourmet/tab_search",
"gourmet/tab_search_press",
"gourmet/tab_category",
"gourmet/tab_category_press",
"gourmet/search_food_table",
"gourmet/category_item",
"gourmet/category_item_press",
"gourmet/alert_body_bg",
"gourmet/alert_button_bg",
"gourmet/alert_button_bg_press"
		];
		
		public static var imageKeys:Array = [
		
			"gourmet/menu", 
			"gourmet/menu_click",
			"gourmet/title_only_galleria",
			"gourmet/title_menu_search",
			"gourmet/title_tasty_chart",
			"gourmet/title_menu",
		];
		
		public static function getUrl(key:String, lang:String=null):String
		{
			var path:String = "images/static/common/";
			
			if (lang)
			{
				path = "images/static/" + lang + "/";
			}
			
			return path + key + ".png";
		}
		
	}

}




