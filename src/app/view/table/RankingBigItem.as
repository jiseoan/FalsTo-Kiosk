package app.view.table 
{
	import app.view.common.ImageBox;
	/**
	 * ...
	 * @author ...
	 */
	public class RankingBigItem extends RankingBigItemAsset 
	{
		
		public function RankingBigItem(ranking:Object) 
		{
			super();
			
			var rankingImg:ImageBox = new ImageBox("ranking" + ranking);
			addChild(rankingImg);
		}
		
	}

}