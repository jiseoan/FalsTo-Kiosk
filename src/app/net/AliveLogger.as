package app.net 
{
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author ...
	 */
	public class AliveLogger 
	{
		
		public function AliveLogger() 
		{
			var timer:Timer = new Timer(1000 * 10);
			timer.addEventListener(TimerEvent.TIMER, saveTime);
			timer.start();
			
			saveTime(null);
		}
		
		private function saveTime(e:TimerEvent):void 
		{
			var file:File = File.applicationDirectory.resolvePath( "conf/alive.txt" );
			var wr:File = new File( file.nativePath );
			var stream:FileStream = new FileStream();
			stream.open( wr , FileMode.WRITE);
			stream.writeUTFBytes(new Date().getTime().toString());
			stream.close();

		}
		
		
	}

}