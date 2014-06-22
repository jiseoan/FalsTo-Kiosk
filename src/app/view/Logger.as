package app.view 
{
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author joe
	 */
	public class Logger extends TextField 
	{
		
		public function Logger() 
		{
			mouseEnabled = false;
		}
		
		public function log(str:String):void
		{
			text = str + "\r" + text;
			//appendText(str + "\r\n");
		}
	}

}