package app.view.gourmet494 
{
	import app.view.common.ImageBox;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author joe
	 */
	public class OnlyGalleriaView extends Sprite 
	{
		private var _grid:OnlyGalleriaGrid;
		
		public function OnlyGalleriaView() 
		{
			super();
			
			var title:ImageBox = new ImageBox("gourmet/title_only_galleria", true);
			title.y = 110;
			addChild(title);
			
			
			_grid = new OnlyGalleriaGrid();
			_grid.x = 80;
			_grid.y = 381;
			addChild(_grid);
		}
		
	}

}