package app.model 
{
	/**
	 * ...
	 * @author 
	 */
	public class Searcher 
	{
		private static var topChar:Array = ['ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'];
		
		public function Searcher() 
		{
			
		}
		
		public static function search(keyword:String, target:String):Boolean
		{
			keyword = keyword.toLowerCase();
			target = target.toLowerCase();
			
			var i:int;
			var max:int = target.length - (keyword.length - 1);
			var firstChar:String = keyword.substr(0, 1);
			var chunks:Array = [];
			
			
			for (i = 0; i < max; i++) 
			{
				if (compareChar(firstChar, target.substr(i, 1)))
				{
					chunks.push(target.substr(i, keyword.length));
				}
			}
			
			//검색어가 한글자일때..
			if (keyword.length == 1 && chunks.length > 0)
			{
				return true;
			}
			
			for (i = 0; i < chunks.length; i++) 
			{
				var chunk:String = chunks[i];
				for (var j:int = 1; j < keyword.length; j++) 
				{
					if (!compareChar(keyword.substr(j, 1), chunk.substr(j, 1)))
					{
						break;
					}
					
					if (j == keyword.length - 1)
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		private static function compareChar(char1:String, char2:String):Boolean
		{
			var isTopChar:int = Searcher.topChar.indexOf(char1);
			
			if (isTopChar!=-1)	//초성인 경우(ex: ㄱ, ㄴ, ㄷ..)
			{
				char2 = getTopChar(char2);
				if (char1 == char2)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else	//한글이거나 영어일때(ex: 가,나, a, b..)
			{
				if (char1 == char2)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
		}
		
		private static function getTopChar(char:String):String
		{
			var idx:int = char.charCodeAt(0) - 44032;
			idx /= 588;
			
			if (Searcher.topChar[idx])
			{
				return Searcher.topChar[idx];
			}
			else
			{
				return char;
			}
		}
	}

}