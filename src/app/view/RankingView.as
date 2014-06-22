package app.view 
{
	import app.controller.ScreenSaverController;
	import app.model.Model;
	import app.view.common.ImageBox;
	import app.view.common.Navigator;
	import app.view.table.RankingTable;
	import com.greensock.TweenNano;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class RankingView extends Sprite  implements IView
	{
		private var _curTable:RankingTable;
		private var _nextTable:RankingTable;
		private var _navigator:Navigator;
		
		private var _rankings:Array;
		
		private var _interval:Number;
		private var _timer:Timer;
		private var _curIndex:int = 0;
		
		//아이콘 x값 - 860
		public function RankingView() 
		{
			super();
			
			_interval = Model.instance.config.rollingInterval.ranking;
			
			var title:ImageBox = new ImageBox("title_ranking", true);
			addChild(title);
			
			_rankings = Model.instance.getRankingsByFloor(Model.instance.config.floor);
			
			if (_rankings.length == 0) 
			{
				var alert:ImageBox = new ImageBox("alert_nodata_brand", true); 
				alert.y = 480;
				addChild(alert);
				
				return;
			}
			
			if (Model.instance.screensaverMode)
			{
				_curIndex = ScreenSaverController.instance.count%_rankings.length;
			}
			
			_curTable = new RankingTable(_rankings[_curIndex]);
			addChild(_curTable);
			
			_curTable.show();
			
			_navigator = new Navigator();
			addChild(_navigator);
			
			if (_rankings.length > 1)
			{
				slide();
			}
		}
		
		private function slide():void
		{
			_timer = new Timer(_interval*1000, 0);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
			
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			if (Model.instance.screensaverMode) return;
			
			_curIndex++;
			if (_curIndex == _rankings.length) _curIndex = 0;
			
			_nextTable = new RankingTable(_rankings[_curIndex]);
			_nextTable.alpha = 0;
			TweenNano.to(_nextTable, 0.3, { alpha:1, onComplete:_nextTable.show } );
			addChild(_nextTable);
			
			_curTable.hide();
			
			_curTable = _nextTable;
		}
		
		
		/* INTERFACE app.view.IView */
		
		public function destroy():void 
		{
			if (_timer) 
			{
				_timer.reset();
				_timer.removeEventListener(TimerEvent.TIMER, onTimer);
				_timer = null;
			}
			
			_curTable = null;
			_nextTable = null;
			_rankings = null;
			
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
		}
		
	}

}