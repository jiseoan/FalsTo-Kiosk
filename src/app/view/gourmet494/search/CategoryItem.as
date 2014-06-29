package app.view.gourmet494.search 
{
	import app.text.TextFormatter;
	import app.view.common.Button;
	import app.view.common.ImageBox;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author joe
	 */
	public class CategoryItem extends Sprite 
	{
		private var _category:String;
		
		public function CategoryItem(category:String) 
		{
			super();
			_category = category;
			
			var bg:Button = new Button([new ImageBox("gourmet/category_item"), new ImageBox("gourmet/category_item_press")]);
			addChild(bg);
			
			var tf:TextField = new TextField();
			TextFormatter.setTextFormat(tf, 0xcccccc, 18, MyriadPro, "center", true);
			
			tf.width = bg.width;
			tf.height = 60;
			tf.multiline = true;
			tf.mouseEnabled = false;
			tf.text = category;
			addChild(tf);
			
			
			
			if (tf.textHeight > 30)
			{
				tf.y = 10;
			}
			else
			{
				tf.y = 20;
			}
			
		}
		
		public function get category():String 
		{
			return _category;
		}
		
	}

}