package app.view.floorView 
{
	import app.text.TextFormatter;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author joe
	 */
	public class CategoryItem extends Sprite 
	{
		public function CategoryItem(category:String) 
		{
			super();
			
			var tf:TextField = new TextField();
			TextFormatter.setTextFormat(tf, 0x222222, 20, MyriadProBold);
			tf.width = 160;
			tf.height = 62;
			tf.x = 5;
			tf.y = 6;
			tf.text = category;
			//tf.border = true;
			addChild(tf);
		}
		
	}

}