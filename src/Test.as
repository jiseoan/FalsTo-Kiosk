/**
 * //@mxmlc -help
* //@mxmlc -o test/BrandViewTest.swf -debug=true -default-size 540 960 -default-background-color 0x000000 -use-network=false -l lib/assets.swc -l lib/sharedFont.swc -l lib/greensock.swc -l C:\Program Files (x86)\FlashDevelop\Tools\flexsdk\frameworks\libs\core.swc
*/

package  
{
	import app.view.Keypad;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author joe
	 */
	public class Test extends Sprite 
	{
		private var _keypad:Keypad;
		
		public function Test() 
		{
			super();
			scaleX = scaleY = 0.5;
			
			_keypad = new Keypad();
			trace( "_keypad : " + _keypad );
			addChild(_keypad);
			
			_keypad.addEventListener(Keypad.UPDATE, onUpdate)

		}
		
		private function onUpdate(e:Event):void 
		{
			_keypad.outputStr
			trace( "outputStr : " + _keypad.outputStr );
		}
		
	}

}