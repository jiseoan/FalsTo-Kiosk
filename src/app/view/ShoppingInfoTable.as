package app.view 
{
	import app.Application;
	import app.model.Language;
	import app.model.Model;
	import app.model.ShoppingInfo;
	import app.text.TextFormatter;
	import app.view.common.Pagination;
	import com.greensock.core.SimpleTimeline;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author joe
	 */
	public class ShoppingInfoTable extends ShoppingInfoTableAsset 
	{
		private var _pagination:Pagination;
		private var _btns:Array = [];
		private var _shoppingInfos:Array;
		
		public function ShoppingInfoTable(pagination:Pagination) 
		{
			super();
			
			_pagination = pagination;
			
			_pagination.addEventListener(Pagination.UPDATE, onUpdatePagination);
			
			init();
		}
		
		private function init():void
		{
			_shoppingInfos = Model.instance.shoppingInfos;
			
			for (var i:int = 0; i < 4; i++) 
			{
				var btn:SimpleButton = getChildByName("b" + (i + 1)) as SimpleButton;
				btn.addEventListener(MouseEvent.CLICK, onClickBtn);
				
				_btns.push(btn);
			}
			
			onUpdatePagination(null);
		}
		
		private function onClickBtn(e:MouseEvent):void 
		{
			var t:SimpleButton = e.target as SimpleButton;
			var id:int = int(t.name.substr(1, 1)) - 1;
			
			var index:int = id + ((_pagination.curPage-1) * 4);
			var info:ShoppingInfo = _shoppingInfos[index];
			if (info)
			{
				var window:ShoppingInfoWindow = new ShoppingInfoWindow(index);
				window.open();
			}
			
		}
		
		public function forceClick(index:int):void
		{
			var btn:SimpleButton = _btns[index] as SimpleButton;
			btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		private function onUpdatePagination(e:Event):void 
		{
			var item:MovieClip, container:MovieClip;
			
			for (var i:int = 1; i <= 4; i++) 
			{
				item = getChildByName("item" + i) as MovieClip;
				item.visible = false;
				item.titleTF.text = "";
				item.descTF.text = "";
				item.mouseChildren = false;
				item.mouseEnabled = false;
				
				container = getChildByName("container" + i) as MovieClip;
				if(container.numChildren>0) container.removeChildAt(0);
			}
			
			var startIndex:int = (_pagination.curPage-1) * 4;
			var endIndex:int = startIndex + 4;
			if (endIndex+1 > _shoppingInfos.length)
			{
				endIndex -= _pagination.curPage * 4 - _shoppingInfos.length;
			}
			
			for (var j:int = startIndex; j < endIndex; j++) 
			{
				var index:int = j - startIndex + 1;
				var info:ShoppingInfo = _shoppingInfos[j];
				
				item = getChildByName("item" + index) as MovieClip;
				item.visible = true;
				
				TextFormatter.setTextFormat(item.titleTF, 0x333333, 38, YoonGothic145, "left", true, 0, false);
				TextFormatter.setTextFormat(item.descTF, 0x777777, 26, YoonGothic135, "left", true, 0, false);
				
				item.titleTF.text = info.data.title[Model.instance.lang];
				item.descTF.text = info.data.ticker[Model.instance.lang];
				
				if(item.titleTF.text=="") item.titleTF.text = info.data.title[Language.KOREAN];
				if(item.descTF.text=="") item.descTF.text = info.data.ticker[Language.KOREAN];
				
				container = getChildByName("container" + index) as MovieClip;
				container.addChild(info.thumbnail);
			}
		}
		

	}

}