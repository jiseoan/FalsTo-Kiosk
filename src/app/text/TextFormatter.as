package app.text
{
	import app.model.Model;
	import flash.text.Font;
	import flash.text.FontStyle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * 텍스트 포맷을 설정하는 클래스
	 */
	public class TextFormatter
	{
		public function TextFormatter():void
		{
			
		}
		/**
		 * 텍스트포맷을 설정
		 * @param	tf				//타겟 텍스트필드
		 * @param	size			//텍스트 크기
		 * @param	color			//텍스트 색상
		 * @param	letterSpacing	//텍스트 자간
		 */
		public static function setTextFormat(tf:TextField, color:int, size:Number, fontClass:Class, align:String="left", wordWrap:Boolean = true, letterSpacing:Number = 0, bold:Boolean=false):void
		{
			var font:Font;
			
			if (fontClass == null)
			{
				var fonts:Object = { kor:YoonGothic145, eng:MyriadProBold, chn:MicrosoftYaHei, jpn:KozukaGothicBold };
				fontClass = fonts[Model.instance.lang];
			}

			font= new fontClass() as Font;
			
			var format:TextFormat = new TextFormat(font.fontName);
			format.size = size;
			format.bold = bold;
			format.align = align;
			format.letterSpacing = letterSpacing;
			
			if (fontClass == YoonGothic135 || fontClass == YoonGothic145)
			{
				format.letterSpacing = -size * 0.1;
				tf.scaleX = 0.92;
			}
			
			tf.embedFonts = true;
			if (color != -1) tf.textColor = color;
			tf.wordWrap = wordWrap;
			tf.defaultTextFormat = format;
			tf.setTextFormat(format);
			
		}

		
	}

}