package app.view 
{
	import app.controller.ScreenSaverController;
	import app.model.Model;
	import app.view.common.ImageBox;
	import app.view.common.Pagination;
	import com.greensock.TweenMax;
	import com.greensock.TweenNano;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ShoppingInfoView extends Sprite  implements IView
	{
		private var _table:ShoppingInfoTable;
		private var _pagination:Pagination;
		private var _videoPlayer:VideoPlayer;
		
		public function ShoppingInfoView() 
		{
			super();
			
			var title:ImageBox = new ImageBox("title_shopping_info", true);
			addChild(title);
			
			
			
			var totalPages:int = Math.floor((Model.instance.shoppingInfos.length - 1) / 4) + 1;
			trace( "(Model.instance.shoppingInfos.length : " + (Model.instance.shoppingInfos.length ));
			_pagination = new Pagination(totalPages);
			_pagination.y = 1450;
			
			_table = new ShoppingInfoTable(_pagination);
			_table.x = 158;
			_table.y = 273;
			
			addChild(_table);
			addChild(_pagination);
			
			if (Model.instance.screensaverMode)
			{
				var index:int = ScreenSaverController.instance.count % Model.instance.shoppingInfos.length;
				
				TweenMax.delayedCall(0.6, showWindow);
				
				function showWindow():void {
					var window:ShoppingInfoWindow = new ShoppingInfoWindow(index);
					window.open();
				}
			}
			
			Model.instance.addEventListener(Model.UPDATE_MODE, onUpdateMode);
		}
		
		private function onUpdateMode(e:Event):void 
		{
			if (_videoPlayer)
			{
				_videoPlayer.stopVideo();
			}
		}
		
		public function startVideoPlayer():void
		{
			trace( "startVideoPlayer : " + startVideoPlayer );
			_videoPlayer = new VideoPlayer();
			addChild(_videoPlayer);
			
		}
		
		/* INTERFACE app.view.IView */
		
		public function destroy():void 
		{
			Model.instance.fromGourmetView = false;
		}
		
		public function get table():ShoppingInfoTable 
		{
			return _table;
		}
		
	}

}