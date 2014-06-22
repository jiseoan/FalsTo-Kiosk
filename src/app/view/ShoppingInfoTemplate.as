package app.view 
{
	import app.model.Model;
	import app.model.ShoppingInfo;
	import app.text.TextFormatter;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author joe
	 */
	public class ShoppingInfoTemplate extends ShoppingInfoTemplateAsset 
	{
		private var _index:int;
		private var _info:ShoppingInfo;
		private var _type:int;
		
		public function ShoppingInfoTemplate(index:int) 
		{
			super();
			
			_index = index;
			_info = Model.instance.shoppingInfos[index];
			_type = int(_info.data["template-type"]);
			
			if (_type == 0)
			{
				if(_info) addChild(_info.detailImages[0]);
				return;
			}
			
			
			TextFormatter.setTextFormat(titleTF, 0x7c7860, 24, YoonGothic135, "center");
			TextFormatter.setTextFormat(descTF, 0x7c7860, 46, YoonGothic135, "center");
			TextFormatter.setTextFormat(etcTF, 0x7c7860, 14, YoonGothic135, "left");
			
			titleTF.text = _info.data.title.kor;
			descTF.text = _info.data.desc.kor;
			etcTF.text = _info.data["etc-desc"].kor;
			
			if (_type == 1)
			{
				c1.addChild(_info.detailImages[0]);
				
				TextFormatter.setTextFormat(periodTF, 0x090506, 18, YoonGothic135, "left");
				TextFormatter.setTextFormat(targetTF, 0x090506, 18, YoonGothic135, "left");
				TextFormatter.setTextFormat(locationTF, 0x090506, 18, YoonGothic135, "left");
				
				periodTF.text = _info.data.period.kor;
				targetTF.text = _info.data.target.kor;
				locationTF.text = _info.data.location.kor;
			}
			else
			{
				gotoAndStop(_info.detailImages.length + 1);
				
				TextFormatter.setTextFormat(periodTF, 0x090506, 18, YoonGothic135, "center");
				periodTF.text = "증정기간 " + _info.data.period.kor + "    증정장소 " + _info.data.location.kor;
				
				for (var i:int = 0; i < _info.detailImages.length; i++) 
				{
					var container:MovieClip = getChildByName("c" + (i + 1)) as MovieClip;
					container.addChild(_info.detailImages[i]);
				}
			}
			
		}
		
	}

}