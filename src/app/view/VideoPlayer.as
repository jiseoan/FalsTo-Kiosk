package app.view 
{
	import app.controller.Controller;
	import app.controller.ScreenSaverController;
	import app.model.Model;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	/**
	 * ...
	 * @author ...
	 */
	public class VideoPlayer extends Sprite 
	{
		private var nc:NetConnection;
		private var ns:NetStream;
		private var _video:Video;
		
		public function VideoPlayer() 
		{
			super();
			
			nc = new NetConnection(); 
			nc.connect(null);
			
			ns = new NetStream(nc); 
			var videoVolumeTransform:SoundTransform = new SoundTransform();

			videoVolumeTransform.volume = 0;

			ns.soundTransform = videoVolumeTransform;

			var customClient:Object = new Object();
			customClient.onMetaData = metaDataHandler;
			ns.client = customClient;
			ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_video = new Video();
			_video.attachNetStream(ns); 
			addChild(_video);
			
			
			ns.play("images/dynamic/videos/WEST RE-OPEN_1080x1589.f4v"); 

			
			function metaDataHandler(infoObject:Object):void {
				_video.width = infoObject.width;
				_video.height = infoObject.height;
				
			}
			
			Model.instance.mode = 8;
			
			Main.instance.addEventListener(Main.BEFORE_RESTART, onBeforeRestart);
		}
		
		private function onBeforeRestart(e:Event):void 
		{
			Main.instance.removeEventListener(Main.BEFORE_RESTART, onBeforeRestart);
			
			stopVideo();
		}
		
		private function netStatusHandler(e:NetStatusEvent):void 
		{
			if (e.info.code == "NetStream.Play.Stop") {
				ns.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				Main.instance.removeEventListener(Main.BEFORE_RESTART, onBeforeRestart);
				
				if (Model.instance.screensaverMode)
				{
					ScreenSaverController.instance.startScreenSaverMode();
				}
				else
				{
					ScreenSaverController.instance.stopScreenSaverMode();
					Controller.instance.changeView(0);
				}
				
			}
			
		}
		
		public function stopVideo():void
		{
			ns.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			Main.instance.removeEventListener(Main.BEFORE_RESTART, onBeforeRestart);
			
			ns.pause();
			ns.dispose();
			nc.close();
			
			if (_video)
			{
				if (contains(_video)) removeChild(_video);
			}
		}
		
	}

}