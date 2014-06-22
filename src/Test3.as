package  
{
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Test3 extends Sprite 
	{
		
		public function Test3() 
		{
			super();
			
			var nc:NetConnection = new NetConnection(); 
			nc.connect(null);
			
			var ns:NetStream = new NetStream(nc); 
			var videoVolumeTransform:SoundTransform = new SoundTransform();

			videoVolumeTransform.volume = 0;

			ns.soundTransform = videoVolumeTransform;

			var customClient:Object = new Object();
			customClient.onMetaData = metaDataHandler;
			ns.client = customClient;
			ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler); 
			ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			var vid:Video = new Video();
			vid.attachNetStream(ns); 
			addChild(vid);
			
			
			ns.play("images/dynamic/videos/WEST RE-OPEN_1080x1589.f4v"); 
			function asyncErrorHandler(event:AsyncErrorEvent):void 
			{
				trace( "asyncErrorHandler : " + asyncErrorHandler );
				// ignore error 
			}
			
			function metaDataHandler(infoObject:Object):void {
				vid.width = infoObject.width;
				vid.height = infoObject.height;
				
			}
			
		}
		
		private function netStatusHandler(e:NetStatusEvent):void 
		{
			if (e.info.code == "NetStream.Play.Stop") {
				trace( "e.info.code : " + e.info.code );
				// do loop...
			}
			
		}

		
	}

}