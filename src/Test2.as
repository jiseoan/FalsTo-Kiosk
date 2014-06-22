package  
{
	import app.view.common.TextMaskSlider;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author joe
	 */
	public class Test2 extends Sprite 
	{
		
		public function Test2() 
		{
			super();
			
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0xffffff);
			shape.graphics.drawRect(0, 0, 1080, 1920);
			addChild(shape);
			
			var mc:MovieClip = new MovieClip();
			mc.x=100;
			mc.y=100;
			addChild(mc);

			var tf:TextField = new TextField();
			tf.width = 100;
			tf.height = 20;
			tf.multiline = false;
			tf.border=true;
			mc.addChild(tf);
			tf.text = "111fdfjkljflafjalfjlfsfdsfafafafdldf222";
			
			TextMaskSlider.setMaskSlider(tf);
		}
		
	}

}