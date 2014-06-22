package app.view.common 
{
	import adobe.utils.CustomActions;
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import com.greensock.TweenNano;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author joe
	 */
	public class TextMaskSlider 
	{
		private static var _objs:Array = [];
		
		public static function setMaskSlider(tf:TextField):void
		{
			removeMaskSlider(tf);
			
			if (tf.width >= tf.textWidth - 5) 
			{
				return;
			}
			
			var obj:Object = { };
			obj.tf = tf;
			
			obj.ow = tf.width;
			obj.ox = tf.x;
			
			tf.multiline = false;
			tf.wordWrap = false;
			
			var m:Shape = new Shape();
			m.graphics.beginFill(0);
			m.graphics.drawRect(tf.x, tf.y, tf.width, tf.height);
			tf.parent.addChild(m);
			tf.mask = m;
			
			obj.mask = m;
			
			tf.autoSize = TextFieldAutoSize.LEFT;
			
			var sec:Number = (tf.width - m.width) / 100;
			if (sec < 1) sec = 1;
			var tm:TweenMax = TweenMax.to(tf, sec, { x: tf.x - (tf.width - m.width), yoyo:true, repeat:-1, repeatDelay:0.5, ease:Linear.easeNone } );
			
			obj.tween = tm;
			
			_objs.push(obj);
			

		}

		private static function removeMaskSlider(tf:TextField):void
		{
			var index:int = -1;
			var obj:Object;
			
			for (var i:int = 0; i < _objs.length; i++) 
			{
				obj = _objs[i];
				if (tf == obj.tf)
				{
					index = i;
					break;
				}
			}
			
			if (index == -1) return;
			
			obj = _objs.splice(index, 1)[0];
			
			tf.mask = null;
			tf.autoSize = TextFieldAutoSize.NONE;
			tf.x = obj.ox;
			tf.width = obj.ow/tf.scaleX;
			if (obj.mask.parent) obj.mask.parent.removeChild(obj.mask);
			obj.mask.graphics.clear();
			
			TweenMax.killTweensOf(tf);
		}


		
	}

}