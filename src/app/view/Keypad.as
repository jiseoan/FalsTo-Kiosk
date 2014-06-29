
package app.view 
{
	import app.model.Language;
	import app.model.Model;
	import app.view.common.Button;
	import app.view.common.ImageBox;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.events.*;
	import flash.media.Sound;
	
	public class Keypad extends KeypadAsset
	{
		public static const UPDATE:String = "update";
		
		private var _topArr:Array = new Array('ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ');
		private var _middleArr:Array = new Array('ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ', 'ㅙ', 'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 'ㅡ', 'ㅢ', 'ㅣ');
		private var _bottomArr:Array = new Array(' ', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ', 'ㄹ', 'ㄺ', 'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 'ㅁ', 'ㅂ', 'ㅄ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ');
		
		
		private var _dualBottomArr:Array = new Array(
							1, 10, 3, // 종성 ㄱ + 초성 ㅅ = 종성 ㄳ
							3, 13, 5, // 종성 ㄴ + 초성 ㅈ = 종성 ㄵ
							3, 19, 6, // 종성 ㄴ + 초성 ㅎ = 종성 ㄶ
							6, 1, 9, // 종성 ㄹ + 초성 ㄱ = 종성 ㄺ
							6, 7, 10, // 종성 ㄹ + 초성 ㅁ = 종성 ㄻ
							6, 8, 11, // 종성 ㄹ + 초성 ㅂ = 종성 ㄼ
							6, 10, 12, // 종성 ㄹ + 초성 ㅅ = 종성 ㄽ
							6, 17, 13, // 종성 ㄹ + 초성 ㅌ = 종성 ㄾ
							6, 18, 14, // 종성 ㄹ + 초성 ㅍ = 종성 ㄿ
							6, 19, 15, // 종성 ㄹ + 초성 ㅎ = 종성 ㅀ
							8, 10, 18  // 종성 ㅂ+ 초성 ㅅ = 종성 ㅄ 
							);

		private var _dualMiddleArr:Array = new Array(
							24, 20, 9, // ㅗ + ㅏ = ㅘ
							24, 28, 10, // ㅗ + ㅐ = ㅙ
							24, 33, 11, // ㅗ + ㅣ = ㅚ
							26, 22, 14, // ㅜ + ㅓ = ㅝ
							26, 30, 15, // ㅜ + ㅔ = ㅞ
							26, 33, 16, // ㅜ + ㅣ = ㅟ
							32, 33, 19 // ㅡ + ㅣ = ㅢ      
							);
	
		private var _baseArr:Array = new Array("",
							"ㄱ",	"ㄲ",	"ㄴ",	"ㄷ",	"ㄸ",	"ㄹ",	"ㅁ",	"ㅂ",	"ㅃ",	"ㅅ",
							"ㅆ",	"ㅇ",	"ㅈ",	"ㅉ",	"ㅊ",	"ㅋ",	"ㅌ",	"ㅍ",	"ㅎ",	"ㅏ",
							"ㅑ",	"ㅓ",	"ㅕ",	"ㅗ",	"ㅛ",	"ㅜ",	"ㅠ",	"ㅐ",	"ㅒ",	"ㅔ",
							"ㅖ",	"ㅡ",	"ㅣ"
							);
		
		private var _alphabet:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		private var _number:String = "0123456789.-";
							
		private var _stackKey:Array = [];		//키를 클릭할때마다 keyID를 스택에 저장
		private var _stackChar:Array = [];		//각각의 자소를 분리하여 저장
		private var _triCharIndex:Array = [null, null, null];
		private var _triChar:Array = [null, null, null];
		private var _curChar:String = "";		//현재 편집중인 문자
		private var _stableStr:String = "";		//편집이 끝난 문자열
		private var _outputStr:String = "";		//최종 출력되는 문자열(_stableStr + _curChar)
		private var _stackType:Array = [588,28,1];		//배열의 각요소 -- 초성(588)/중성(28)/종성(1) 구분 [588, 28, 1]
		private var _editMode:int = 0;			//0=처음시작, 1=초성, 2=중성1, 3=중성2, 4=종성1, 5=종성2
		
		private var _keyTexts:Array = [];
		
		public function Keypad():void
		{
			setListener();
			setListener_num();
			
			onChangeLanguage(null);
			
			Model.instance.addEventListener(Model.CHANGE_LANGUAGE, onChangeLanguage);
		}
		
		private function onChangeLanguage(e:Event):void 
		{
			if (Model.instance.lang == Language.KOREAN)
			{
				korKey_click(null);
			}
			else
			{
				engKey_click(null);
			}
		}
		
		private function setListener():void 
		{
			korKey.addEventListener(MouseEvent.CLICK, korKey_click);
			engKey.addEventListener(MouseEvent.CLICK, engKey_click);
			clearKey.addEventListener(MouseEvent.CLICK, clearKey_click);
		}
		
		private function setListener_kor():void
		{
			for (var i:int = 1; i <= 35; i++) 
			{
				var key:SimpleButton = getChildByName("key" + i) as SimpleButton;
				key.addEventListener(MouseEvent.CLICK, onClickKey_kor);
			}
			
			transKey.addEventListener(MouseEvent.CLICK, transKey_click);
			
		}
		
		private function setListener_eng():void
		{
			for (var i:int = 1; i <= 26; i++) 
			{
				var key:SimpleButton = getChildByName("key" + i) as SimpleButton;
				key.addEventListener(MouseEvent.CLICK, onClickKey_eng);
			}
		}
		
		private function setListener_num():void
		{
			for (var i:int = 0; i < 12; i++) 
			{
				var key:SimpleButton = getChildByName("num" + i) as SimpleButton;
				key.addEventListener(MouseEvent.CLICK, onClickKey_num);
			}
		}
		
		
		private function clearKey_click(e:MouseEvent):void 
		{
			_stackKey = [];
			_stackChar = [];
			_curChar = "";
			_stableStr = "";
			_outputStr = "";
			dispatch();
		}
		
		private function engKey_click(e:MouseEvent):void 
		{
			_stackKey = [];
			_stackChar = [];
			_triCharIndex = [null, null, null];
			_triChar = [null, null, null];
			_curChar = "";
			_stableStr = _outputStr;
			_outputStr = _stableStr + _curChar;
				
			gotoFrame(3);
			setListener_eng()
		}
		
		private function korKey_click(e:MouseEvent):void 
		{
			gotoFrame(1);
			setListener_kor();
		}
		
		private function transKey_click(e:MouseEvent):void 
		{
			if (currentFrame == 1)
			{
				gotoFrame(2);
			} else if (currentFrame == 2)
			{
				gotoFrame(1);
			}
		}
		
		private function gotoFrame(frame:int):void
		{
			gotoAndStop(frame);
			
			//var keyText:ImageBox;
			//
			//if (!_keyTexts[frame-1])
			//{
				//keyText = new ImageBox("key" + frame, true);
				//keyText.mouseEnabled = false;
				//addChild(keyText);
				//
				//_keyTexts[frame-1] = keyText;
			//}
			//
			//for (var i:int = 0; i < 3; i++) 
			//{
				//keyText = _keyTexts[i];
				//if (keyText)
				//{
					//if (i == frame-1)
					//{
						//keyText.visible = true;
						//addChild(keyText);
					//}
					//else
					//{
						//keyText.visible = false;
					//}
				//}
			//}
			//
			
		}
		
		private function onClickKey_kor(e:MouseEvent):void 
		{
			var target:SimpleButton = e.target as SimpleButton;
			var id:int = int(target.name.substr(3));
			if (_outputStr.length < 30 || id==34)
			{
				setChar(id);
			}
		}
		
		private function onClickKey_eng(e:MouseEvent):void 
		{
			var target:SimpleButton = e.target as SimpleButton;
			var id:int = int(target.name.substr(3));
			if (_outputStr.length < 30)
			{
				_outputStr += _alphabet.substr(id - 1, 1);
				dispatch();
			}
		}
		
		private function onClickKey_num(e:MouseEvent):void 
		{
			
			var target:SimpleButton = e.target as SimpleButton;
			var id:int = int(target.name.substr(3));
			if (_outputStr.length < 30)
			{
				_stackKey = [];
				_stackChar = [];
				_triCharIndex = [null, null, null];
				_triChar = [null, null, null];
				_curChar = "";
				_stableStr = _outputStr;
				_outputStr = _stableStr + _curChar;
				
				_outputStr += _number.substr(id, 1);
				dispatch();
			}
		}
		
		
		private function setChar(keyID:int):void
		{
			if (keyID == 34)	//backspace
			{
				setBackSpace();
			}
			else if (keyID == 35)	//space
			{
				setSpace();
			}
			else
			{
				if (keyID < 20)	//자음일때
				{
					if (isTopChar(keyID))	//초성일때
					{
						setTopChar(keyID);
					}
					else	//종성일때
					{
						setBottomChar(keyID);
					}
				}
				else	//모음일때
				{
					setMiddleChar(keyID);
				}
			}
			dispatch();
		}
		
		private function setTopChar(keyID:int):void
		{
			typeNext(keyID);
		}
		private function setBottomChar(keyID:int):void
		{
			
			
			if (_stackKey[_stackKey.length - 1] < 20)	//스택의 마지막이 자음일때..(복자음)
			{
				_stackKey.push(keyID);
				_stackChar.push(_baseArr[keyID]);
				combineDualBottom(_stackKey[_stackKey.length - 2], _stackKey[_stackKey.length - 1]);
			}
			else
			{
				_stackKey.push(keyID);
				_stackChar.push(_baseArr[keyID]);
				_triCharIndex[2] = findIndex(_bottomArr, _baseArr[keyID]);
				_triChar[2] =  _middleArr[_triCharIndex[2]];
			}
			
			_curChar = combineChar(_triCharIndex);
			_outputStr = _stableStr + _curChar;
		}
		
		private function setMiddleChar(keyID:int):void
		{
			if (_stackKey.length == 0)	//1. 기존의 문자열이 없을때(처음 클릭했을때..)
			{
				typeNext(keyID);
			}
			else if (_stackKey.length==1 && _stackKey[0]<20)	//2. 초성만 있을때..
			{
				_stackKey.push(keyID);
				_stackChar.push(_baseArr[keyID]);
				_triCharIndex[1] = findIndex(_middleArr, _baseArr[keyID]);
				_triChar[1] =  _middleArr[_triCharIndex[1]];
				_curChar = combineChar(_triCharIndex);
				_outputStr = _stableStr + _curChar;
			}
			else if (_stackKey.length > 1 && _stackKey[_stackKey.length-1]>=20)	//3. 이미 중성이 있을때..
			{
				if (isDualMiddle(keyID))	//이중모음일때..
				{
					_stackKey.push(keyID);
					_stackChar.push(_baseArr[keyID]);
					combineDualMiddle(_stackKey[_stackKey.length - 2], _stackKey[_stackKey.length - 1]);
					_curChar = combineChar(_triCharIndex);
					_outputStr = _stableStr + _curChar;
				}
				else
				{
					typeNext(keyID);
				}
			}
			else if (_stackKey.length>2 && _stackKey[_stackKey.length-1]<20)	//4. 종성까지 있을때..
			{
				var tmpStackKey:Array = _stackKey.concat();
				var tmpStackChar:Array = _stackChar.concat();
				var tmpTriCharIndex:Array = _triCharIndex.concat();
				
				_stackKey = [tmpStackKey[tmpStackKey.length - 1], keyID];
				_stackChar = [_baseArr[_stackKey[0]], _baseArr[_stackKey[1]]];
				_triCharIndex = [findIndex(_topArr, _stackChar[0]), findIndex(_middleArr, _baseArr[keyID]), null];
				_triChar = [_topArr[_triCharIndex[0]], _middleArr[_triCharIndex[1]], null];
				_curChar = combineChar(_triCharIndex);
				
				if (tmpStackKey[tmpStackKey.length - 2] >= 20)	//받침이 모음에 붙어서 뒷글자로 넘어갔을때..
				{
					tmpTriCharIndex[2] = null;
				}
				else	//받침이 뒷글자로 넘어가고도 받침이 남아있을대.즉 복자음이었던 경우.
				{
					tmpTriCharIndex[2] = findIndex(_bottomArr, tmpStackChar[tmpStackChar.length-2]);
				}
				
				_stableStr += combineChar(tmpTriCharIndex);
				_outputStr = _stableStr + _curChar;
			}
			else
			{
				typeNext(keyID);
			}
			
		}
		private function setSpace():void
		{
			_stackKey = [];
			_stackChar = [];
			_triCharIndex = [null, null, null];
			_triChar = [null, null, null];
			_curChar = " ";
			_stableStr = _outputStr;
			_outputStr = _stableStr + _curChar;
		}
		private function setBackSpace():void
		{
			if (_stackKey.length==0)	//스택이 비었을때..
			{
				_stableStr = _stableStr.substr(0, _stableStr.length - 1);
				_outputStr = _outputStr.substr(0, _outputStr.length - 1);
			}
			else
			{
				
				if (_stackKey.length == 1)
				{
					_stackKey.pop();
					_stackChar.pop();
					_triCharIndex = [null, null, null];
					_triChar = [null, null, null];
					_curChar = "";
					_outputStr = _stableStr + _curChar;
				}
				else if (_stackKey.length == 2)
				{
					_stackKey.pop();
					_stackChar.pop();
					_triCharIndex[1] = null;
					_triChar[1] = null;
					_curChar = _triChar[0];
					_outputStr = _stableStr + _curChar;
				}
				else if (_stackKey.length == 3)
				{
					if (_stackKey[2]<20)	//받침이 있는 경우
					{
						_stackKey.pop();
						_stackChar.pop();
						_triCharIndex[2] = null;
						_triChar[2] = null;
						_curChar = combineChar(_triCharIndex);
						_outputStr = _stableStr + _curChar;
					}
					else	//받침이 없는 복모음인 경우.
					{
						_stackKey.pop();
						_stackChar.pop();
						_triCharIndex[1] = findIndex(_middleArr, _stackChar[_stackChar.length - 1]);
						_triChar[1] = _bottomArr[_triCharIndex[1]];
						_curChar = combineChar(_triCharIndex);
						_outputStr = _stableStr + _curChar;
					}
				}
				else if (_stackKey.length == 4)
				{
					if (_stackKey[2]<20)	//받침이 복자음인 경우
					{
						_stackKey.pop();
						_stackChar.pop();
						_triCharIndex[2] = findIndex(_bottomArr, _stackChar[_stackChar.length - 1]);
						_triChar[2] = _bottomArr[_triCharIndex[2]];
						_curChar = combineChar(_triCharIndex);
						_outputStr = _stableStr + _curChar;
					}
					else	//중성이 복모음인 경우
					{
						_stackKey.pop();
						_stackChar.pop();
						_triCharIndex[2] = null;
						_triChar[2] = null;
						_curChar = combineChar(_triCharIndex);
						_outputStr = _stableStr + _curChar;
					}
				}
				else if (_stackKey.length == 5)
				{
					_stackKey.pop();
					_stackChar.pop();
					_triCharIndex[2] = findIndex(_bottomArr, _stackChar[_stackChar.length - 1]);
					_triChar[2] = _bottomArr[_triCharIndex[2]];
					_curChar = combineChar(_triCharIndex);
					_outputStr = _stableStr + _curChar;
				}
				
			}
		}
		private function typeNext(keyID:int):void
		{
			trace("type next!");
			if (keyID < 20)	//자음일때..
			{
				_stackKey = [keyID];
				_stackChar = [_baseArr[keyID]];
				_triCharIndex = [keyID - 1, null, null];
				_triChar = [_topArr[_triCharIndex[0]], null, null];
				_curChar = _baseArr[keyID];
				_stableStr = _outputStr;
				_outputStr = _stableStr + _curChar;
			}
			else
			{
				_stackKey = [keyID];
				_stackChar = [_baseArr[keyID]];
				_triCharIndex = [null, keyID - 20, null];
				_triChar = [null, _middleArr[_triCharIndex[1]], null];
				_curChar = _baseArr[keyID];
				_stableStr = _outputStr;
				_outputStr = _stableStr + _curChar;
			}	
		}
		
		/**
		 * 눌려진 자음이 초성인지를 체크
		 * @param	keyID
		 */
		private function isTopChar(keyID:int):Boolean
		{
			if (_stackKey.length == 0)	//1. 기존의 문자열이 없을때(처음 클릭했을때..)
			{
				return true;
			}
			if (_stackKey.length == 1)	//제대로된 조합이 아닐때..
			{
				return true;
			}
			if(_stackKey[_stackKey.length-1]<20 && !isDualBottom(keyID))	//2. 스택의 마지막 글자가 자음이고 마지막 문자와 복자음 관계가 성립안될때..
			{
				return true;
			}
			if(!isBottom(keyID))	//3. 받침 가능한 문자가 아닐때..
			{
				return true;
			}
			if (_triCharIndex[0] == null)
			{
				return true;
			}
			return false;
		}
		
		//복자음 체크..
		private function isDualBottom(keyID:int):Boolean
		{
			var lastKeyID:int = _stackKey[_stackKey.length - 1];
			for (var i:int = 0; i < _dualBottomArr.length; i+=3) 
			{
				if (_dualBottomArr[i] == lastKeyID && _dualBottomArr[i + 1] == keyID)//복자음인지 체크..
				{
					return true;
				}
			}
			return false;
		}
		
		//받침가능한 자음인지 체크..
		private function isBottom(keyID:int):Boolean
		{
			for (var i:int = 0; i < _bottomArr.length; i++) 
			{
				if (_bottomArr[i] == _baseArr[keyID])
				{
					return true;
				}
			}
			return false;
			
		}
		
		private function isDualMiddle(keyID:int):Boolean
		{
			var lastKeyID:int = _stackKey[_stackKey.length - 1];
			for (var i:int = 0; i < _dualMiddleArr.length; i+=3) 
			{
				if (_dualMiddleArr[i] == lastKeyID && _dualMiddleArr[i + 1] == keyID)//복모음인지 체크..
				{
					return true;
				}
			}
			return false;
		}
		private function combineChar(triCharIndexArr:Array):String
		{
			var charCode:int = 44032;
			for (var i:int = 0; i < triCharIndexArr.length; i++) 
			{
				charCode += triCharIndexArr[i] * _stackType[i];
			}
			return String.fromCharCode(charCode);
		}
		
		private function combineDualMiddle(key1:int, key2:int):void
		{
			for (var i:int = 0; i < _dualMiddleArr.length; i+=3) 
			{
				if (_dualMiddleArr[i] == key1 && _dualMiddleArr[i + 1] == key2)
				{
					_triCharIndex[1] = _dualMiddleArr[i + 2];
					_triChar[1] = _middleArr[_triCharIndex[1]];
				}
			}
		}
		
		private function combineDualBottom(key1:int, key2:int):void
		{
			for (var i:int = 0; i < _dualBottomArr.length; i+=3) 
			{
				if (_dualBottomArr[i] == key1 && _dualBottomArr[i + 1] == key2)
				{
					_triCharIndex[2] = _dualBottomArr[i + 2];
					_triChar[2] = _bottomArr[_triCharIndex[2]];
				}
			}
		}
		
		private function findIndex(ArrayName:Array, searchWord:String):int
		{
			for (var  i:int = 0; i < ArrayName.length; i++)
			{
				if (ArrayName[i] == searchWord)
				{
					return i;
					break;
				}
			}
			return -1;
		}
		private function dispatch():void
		{
			//stackKeyTF.text = _stackKey.toString();
			//stackCharTF.text = _stackChar.toString();
			//triCharTF.text = _triChar.toString();
			//triCharIndexTF.text = _triCharIndex.toString();
			//curCharTF.text = _curChar;
			//stableStrTF.text = _stableStr;
			//outputStrTF.text = _outputStr;
			//trace( "_outputStr : " + _outputStr );
			
			dispatchEvent(new Event(Keypad.UPDATE));
		}
		
		public function get outputStr():String 
		{
			return _outputStr;
		}
	}
	
}