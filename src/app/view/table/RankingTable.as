package app.view.table 
{
	import app.model.FloorName;
	import app.text.TextFormatter;
	import app.view.common.ImageBox;
	import com.greensock.TweenMax;
	import com.greensock.TweenNano;
	import flash.display.MovieClip;
	import flash.text.StyleSheet;
	import mx.utils.StringUtil;
	/**
	 * ...
	 * @author ...
	 */
	public class RankingTable extends RankingTableAsset 
	{
		//private var _header:ImageBox;
		private var _rows:Array = [];
		private var _ranking:Object;
		
		public function RankingTable(ranking:Object) 
		{
			super();
			
			_ranking = ranking;
			
			x = 80;
			y = 453 - 108;
			
			var j:int;
			if (ranking == null)
			{
				for ( j= 0; j < 10; j++) 
				{
					getChildByName("row" + j).visible = false;
					
				}
				return;
			}
			
			if (ranking.list.length == 0)
			{
				for ( j= 0; j < 10; j++) 
				{
					getChildByName("row" + j).visible = false;
					
				}
				return;
			}
			
			
			floorMC.gotoAndStop(FloorName.name.indexOf(ranking.floor));
			titleTF.text = ranking.category;
			TextFormatter.setTextFormat(titleTF, 0x444444, 32, YoonGothic145, "center");
			titleTF.x = 460 - titleTF.width / 2;
			
			var size:Array = [40, 40, 40, 30, 30, 30, 30, 30, 30, 30];
			var color:Array = [0x222222, 0x666666, 0x666666, 0x888888, 0x888888, 0x888888, 0x888888, 0x888888, 0x888888, 0x888888]
			for (var i:int = 0; i < 10; i++) 
			{
				var row:MovieClip = getChildByName("row" + i) as MovieClip;
				row.num.gotoAndStop(i + 1);
				
				TextFormatter.setTextFormat(row.tf, color[i], size[i], YoonGothic145, "center"); 
				
				if (ranking.list[i])
				{
					
					if (ranking.list[i].product == "없음") 
					{
						row.tf.text = StringUtil.trim(ranking.list[i].brand);
						
					}
					else
					{
						header.gotoAndStop(2);
						row.tf.text = StringUtil.trim(ranking.list[i].product);
						row.tf2.text = StringUtil.trim(ranking.list[i].brand);
						row.tf.y -= 10;
						row.tf2.y -= 10;
						TextFormatter.setTextFormat(row.tf2, color[i], size[i]*0.5, YoonGothic145, "center"); 
						row.tf2.x = 460 - row.tf2.width / 2;
					}
					
					TextFormatter.setTextFormat(row.icon.tf, 0x888888, 30, MyriadProBold, "left"); 
					if (Number(ranking.list[i].change) < 0)			{row.icon.gotoAndStop(1); row.icon.tf.text = -Number(ranking.list[i].change);}
					else if (Number(ranking.list[i].change) == 0)	{row.icon.gotoAndStop(2); row.icon.tf.text = "";}
					else if (Number(ranking.list[i].change) > 0) 	{row.icon.gotoAndStop(3); row.icon.tf.text = Number(ranking.list[i].change);}
					else  											{row.icon.gotoAndStop(4);}
				}
				else
				{
					row.tf.text = "";
					row.icon.visible = false;
				}
				
				
				
				row.alpha = 0;
				row.oy = row.y;
				row.y = row.oy + 22;
				row.tf.x = 460 - row.tf.width / 2;
			}
		}
		
		public function show():void
		{
			for (var i:int = 0; i < 10; i++) 
			{
				var row:MovieClip = getChildByName("row" + i) as MovieClip;
				
				if (i < _ranking.list.length)
				{
					TweenMax.to(row, 0.3, { alpha:1, y:row.oy, delay:0.5 + i * 0.05 } );
				}
				
			}
		}
		
		public function hide():void
		{
			TweenNano.to(floorMC, 0.3, { alpha:0 } );
			TweenNano.to(titleTF, 0.3, { alpha:0 } );

			
			TweenMax.delayedCall(1, remove);
		}
		
		private function remove():void
		{
			if (parent)
			{
				if (parent.contains(this)) parent.removeChild(this);
			}
			
		}
	}

}