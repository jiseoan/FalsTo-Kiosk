/**
 * //@mxmlc -help
* //@mxmlc -o test/BrandViewTest.swf -debug=true -default-size 540 960 -default-background-color 0x000000 -use-network=false -l lib/assets.swc -l lib/sharedFont.swc -l lib/greensock.swc -l C:\Program Files (x86)\FlashDevelop\Tools\flexsdk\frameworks\libs\core.swc
*/

package  
{
	import app.model.Searcher;
	import app.view.Keypad;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author joe
	 */
	public class Test4 extends Sprite 
	{
		private var c_top:Array = ['ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'];
		
		public function Test4() 
		{
			super();
			
			var s:String = "abc";
			
			//var temp:Boolean = lookupKor("ㅎㅁㅇ", "브루클린;웍스;홈메이드소스;햄버거;치즈;베이컨;;Western");
			var temp:Boolean = Searcher.search("ㅇㅁㄹㅋㄴ", "아메리카노");
			trace( "temp : " + temp );
		}
		
		
		private function lookupKor(exp:String, src:String):Boolean {
		   if (src.search(exp) >= 0) {
				  return true;
		   }
		  
		   var i:int = lookupKorFirst(exp, src);
		   trace( "i : " + i );
		   if (i < 0 || src.length - i < exp.length) {
			   trace(11);
				  return false;
		   }
		  
		   var k:int = 1;
		   for (i++ ; k < exp.length && i < src.length ; k++, i++) {
				  if (src.charAt(i) == exp.charAt(k)) {
					  trace(22);
						  continue;
				  }
				  var idx:int = src.charCodeAt(i) - 44032;
				  if (idx < 0 || idx >= 11172) {
					  trace(33);
						  return false;
				  }
				 
				  idx /= 588;
				  if (idx < 0 && idx >= c_top.length) {
					  trace(44);
						  return false;
				  }
				 
				  for (var j:int = 0 ; j < c_top.length ; j++) {
					  if (c_top[idx] != exp.charAt(k)) {
						  trace( "exp.charAt(k) : " + exp.charAt(k) );
						  trace( "c_top[idx] : " + c_top[idx] );
						  trace(55);
							 return false;
					  }
				  }
			}
		  
		   return true;
		}
		
		private function lookupKorFirst(exp:String, src:String):int
		{
			for (var i:int = 0; i < src.length; i++)
			{
				var idx:int = src.charCodeAt(i) - 44032;
				if (idx >= 0 && idx < 11172)
				{
					idx /= 588;
					if (idx >= 0 && idx < c_top.length)
					{
						for (var j:int = 0; j < c_top.length; j++)
						{
							if (c_top[idx] == exp.charAt(0))
							{
								return i;
							}
						}
					}
				}
			}
			return -1;
		}

		
	}

}